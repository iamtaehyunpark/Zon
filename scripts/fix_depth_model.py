"""
Regenerates depth_anything_v2_small.onnx as a lightweight FP32 CNN
using only ONNX Runtime Mobile-supported ops (Conv, BN, ReLU, Resize).

The real Depth Anything V2-Small uses ConvInteger (INT8 dynamic quant)
which ORT Mobile on iOS does not support. This stub has the same
input/output shape and op profile as the TFLite FP16 target for M1.

Run: python scripts/fix_depth_model.py
"""

import numpy as np
import onnx
from onnx import helper, TensorProto, numpy_helper
import os

OUT_PATH = os.path.join(os.path.dirname(__file__), '..', 'assets', 'models',
                        'depth_anything_v2_small.onnx')


def conv_bn_relu(nodes, inits, name, x, out_ch, in_ch, k=3, stride=1):
    """Adds Conv → BatchNorm → ReLU block; returns output tensor name."""
    pad = k // 2
    w = np.random.randn(out_ch, in_ch, k, k).astype(np.float32) * 0.02
    b = np.zeros(out_ch, dtype=np.float32)
    bn_scale = np.ones(out_ch, dtype=np.float32)
    bn_bias  = np.zeros(out_ch, dtype=np.float32)
    bn_mean  = np.zeros(out_ch, dtype=np.float32)
    bn_var   = np.ones(out_ch, dtype=np.float32)

    wname   = f'{name}_w'
    bname   = f'{name}_b'
    bn_s    = f'{name}_bn_s'
    bn_b    = f'{name}_bn_b'
    bn_m    = f'{name}_bn_m'
    bn_v    = f'{name}_bn_v'
    conv_o  = f'{name}_conv'
    bn_o    = f'{name}_bn'
    relu_o  = f'{name}_relu'

    inits += [
        numpy_helper.from_array(w,        wname),
        numpy_helper.from_array(b,        bname),
        numpy_helper.from_array(bn_scale, bn_s),
        numpy_helper.from_array(bn_bias,  bn_b),
        numpy_helper.from_array(bn_mean,  bn_m),
        numpy_helper.from_array(bn_var,   bn_v),
    ]
    nodes += [
        helper.make_node('Conv', [x, wname, bname], [conv_o],
                         name=f'{name}_conv_node',
                         kernel_shape=[k, k], pads=[pad]*4, strides=[stride]*2),
        helper.make_node('BatchNormalization',
                         [conv_o, bn_s, bn_b, bn_m, bn_v], [bn_o],
                         name=f'{name}_bn_node', epsilon=1e-5, momentum=0.9),
        helper.make_node('Relu', [bn_o], [relu_o], name=f'{name}_relu_node'),
    ]
    return relu_o


def build():
    np.random.seed(42)
    nodes, inits = [], []

    # ── Encoder (stride-2 downsamples) ──────────────────────────────────
    x = conv_bn_relu(nodes, inits, 'e0', 'pixel_values', 32,  3, k=3, stride=2)  # 128
    x = conv_bn_relu(nodes, inits, 'e1', x,              64, 32, k=3, stride=2)  # 64
    x = conv_bn_relu(nodes, inits, 'e2', x,             128, 64, k=3, stride=2)  # 32
    x = conv_bn_relu(nodes, inits, 'e3', x,             256,128, k=3, stride=2)  # 16
    x = conv_bn_relu(nodes, inits, 'e4', x,             256,256, k=3, stride=1)  # 16

    # ── Decoder (bilinear upsample + conv) ───────────────────────────────
    def upsample(nodes, x, name, scale):
        scale_t = f'{name}_scales'
        out     = f'{name}_up'
        # opset 11 Resize: inputs = [X, roi, scales]; roi must be empty for non-TF modes
        roi_t   = f'{name}_roi'
        inits.append(numpy_helper.from_array(np.array([], dtype=np.float32), roi_t))
        inits.append(numpy_helper.from_array(
            np.array([1.0, 1.0, scale, scale], dtype=np.float32), scale_t))
        nodes.append(helper.make_node(
            'Resize', [x, roi_t, scale_t], [out], name=f'{name}_resize_node',
            mode='nearest', coordinate_transformation_mode='asymmetric'))
        return out

    x = upsample(nodes, x, 'd3_up', 2.0)                                         # 32
    x = conv_bn_relu(nodes, inits, 'd3', x, 128, 256, k=3)
    x = upsample(nodes, x, 'd2_up', 2.0)                                         # 64
    x = conv_bn_relu(nodes, inits, 'd2', x,  64, 128, k=3)
    x = upsample(nodes, x, 'd1_up', 2.0)                                         # 128
    x = conv_bn_relu(nodes, inits, 'd1', x,  32,  64, k=3)
    x = upsample(nodes, x, 'd0_up', 2.0)                                         # 256

    # ── Depth head: 1-channel output, Sigmoid ────────────────────────────
    head_w = np.random.randn(1, 32, 1, 1).astype(np.float32) * 0.02
    head_b = np.zeros(1, dtype=np.float32)
    inits += [
        numpy_helper.from_array(head_w, 'head_w'),
        numpy_helper.from_array(head_b, 'head_b'),
    ]
    nodes += [
        helper.make_node('Conv', [x, 'head_w', 'head_b'], ['head_conv'],
                         name='head_conv_node', kernel_shape=[1, 1], pads=[0]*4),
        helper.make_node('Sigmoid', ['head_conv'], ['depth_map'],
                         name='sigmoid_node'),
    ]

    # ── Graph ─────────────────────────────────────────────────────────────
    inp = helper.make_tensor_value_info('pixel_values', TensorProto.FLOAT,
                                       [1, 3, 256, 256])
    out = helper.make_tensor_value_info('depth_map',    TensorProto.FLOAT,
                                       [1, 1, 256, 256])
    graph = helper.make_graph(nodes, 'DepthAnythingV2Small', [inp], [out], inits)
    model = helper.make_model(graph, opset_imports=[helper.make_opsetid('', 11)])
    model.ir_version = 7  # ORT Mobile supports up to IR version 9; stay safe at 7
    model.doc_string = (
        'ZON M0 stub: same I/O shape as Depth Anything V2-Small. '
        'FP32 CNN with ORT Mobile-compatible ops only. '
        'Replace with real TFLite weights at M1.'
    )
    onnx.checker.check_model(model)
    os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)
    onnx.save(model, OUT_PATH)
    size_mb = os.path.getsize(OUT_PATH) / 1e6
    print(f'Saved: {OUT_PATH}  ({size_mb:.1f} MB)')
    print('Ops used: Conv, BatchNormalization, Relu, Resize, Sigmoid — all ORT Mobile supported.')


if __name__ == '__main__':
    build()
