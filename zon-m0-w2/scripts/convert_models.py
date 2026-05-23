#!/usr/bin/env python3
"""
ZON — AI Model Download & Conversion Script
Run from project root: python scripts/convert_models.py

Requirements:
  pip install torch torchvision onnx onnxruntime tensorflow huggingface_hub timm

Output (place in assets/models/):
  depth_anything_v2_small.tflite
  superpoint.onnx
  lightglue_lite.onnx
  mixvpr.tflite
"""

import os
import sys
import time
import struct
import argparse
import numpy as np
from pathlib import Path

OUTPUT_DIR = Path("assets/models")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# ── Helpers ──────────────────────────────────────────────

def log(msg): print(f"[ZON] {msg}", flush=True)
def ok(msg):  print(f"[ZON] ✅ {msg}", flush=True)
def err(msg): print(f"[ZON] ❌ {msg}", file=sys.stderr); sys.exit(1)

def check_size(path, max_mb):
    size_mb = Path(path).stat().st_size / 1e6
    if size_mb > max_mb:
        err(f"{path} is {size_mb:.1f}MB — exceeds {max_mb}MB budget!")
    ok(f"{Path(path).name}: {size_mb:.1f}MB (budget: {max_mb}MB)")

# ── 1. Depth Anything V2 Small → TFLite ─────────────────

def convert_depth_anything():
    log("Converting Depth Anything V2-Small → TFLite...")
    try:
        import torch
        from transformers import AutoModelForDepthEstimation
        import tensorflow as tf
        from huggingface_hub import hf_hub_download
    except ImportError as e:
        err(f"Missing dependency: {e}\nRun: pip install torch transformers tensorflow huggingface_hub")

    # Download from HuggingFace
    log("Downloading Depth Anything V2-Small weights...")
    model = AutoModelForDepthEstimation.from_pretrained(
        "depth-anything/Depth-Anything-V2-Small-hf"
    )
    model.eval()

    # Export to ONNX first
    dummy_input = torch.randn(1, 3, 256, 256)
    onnx_path = OUTPUT_DIR / "depth_anything_v2_small_tmp.onnx"

    torch.onnx.export(
        model,
        dummy_input,
        str(onnx_path),
        input_names=["pixel_values"],
        output_names=["predicted_depth"],
        dynamic_axes={"pixel_values": {0: "batch"}},
        opset_version=13,
    )
    log("ONNX export done. Converting to TFLite...")

    # ONNX → TF SavedModel → TFLite
    import onnx
    from onnx_tf.backend import prepare

    onnx_model = onnx.load(str(onnx_path))
    tf_rep = prepare(onnx_model)
    saved_model_dir = OUTPUT_DIR / "depth_anything_saved_model"
    tf_rep.export_graph(str(saved_model_dir))

    converter = tf.lite.TFLiteConverter.from_saved_model(str(saved_model_dir))
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.target_spec.supported_types = [tf.float16]
    tflite_model = converter.convert()

    out_path = OUTPUT_DIR / "depth_anything_v2_small.tflite"
    out_path.write_bytes(tflite_model)

    # Cleanup
    onnx_path.unlink(missing_ok=True)
    import shutil
    shutil.rmtree(saved_model_dir, ignore_errors=True)

    check_size(out_path, 28)
    ok("depth_anything_v2_small.tflite ready")


# ── 2. SuperPoint → ONNX ────────────────────────────────

def convert_superpoint():
    log("Converting SuperPoint → ONNX...")
    try:
        import torch
        import torch.nn as nn
    except ImportError as e:
        err(f"Missing dependency: {e}")

    # SuperPoint architecture (Magic Leap open-source implementation)
    # Reference: https://github.com/magicleap/SuperPointPretrainedNetwork
    class SuperPointNet(nn.Module):
        def __init__(self):
            super().__init__()
            c1, c2, c3, c4, c5 = 64, 64, 128, 128, 256
            self.relu = nn.ReLU(inplace=True)
            self.pool = nn.MaxPool2d(kernel_size=2, stride=2)

            # Encoder
            self.conv1a = nn.Conv2d(1, c1, 3, 1, 1)
            self.conv1b = nn.Conv2d(c1, c1, 3, 1, 1)
            self.conv2a = nn.Conv2d(c1, c2, 3, 1, 1)
            self.conv2b = nn.Conv2d(c2, c2, 3, 1, 1)
            self.conv3a = nn.Conv2d(c2, c3, 3, 1, 1)
            self.conv3b = nn.Conv2d(c3, c3, 3, 1, 1)
            self.conv4a = nn.Conv2d(c3, c4, 3, 1, 1)
            self.conv4b = nn.Conv2d(c4, c4, 3, 1, 1)

            # Detector head
            self.convPa = nn.Conv2d(c4, c5, 3, 1, 1)
            self.convPb = nn.Conv2d(c5, 65, 1, 1, 0)

            # Descriptor head
            self.convDa = nn.Conv2d(c4, c5, 3, 1, 1)
            self.convDb = nn.Conv2d(c5, 256, 1, 1, 0)

        def forward(self, x):
            x = self.relu(self.conv1a(x))
            x = self.relu(self.conv1b(x))
            x = self.pool(x)
            x = self.relu(self.conv2a(x))
            x = self.relu(self.conv2b(x))
            x = self.pool(x)
            x = self.relu(self.conv3a(x))
            x = self.relu(self.conv3b(x))
            x = self.pool(x)
            x = self.relu(self.conv4a(x))
            x = self.relu(self.conv4b(x))

            # Detector
            cPa = self.relu(self.convPa(x))
            semi = self.convPb(cPa)

            # Descriptor
            cDa = self.relu(self.convDa(x))
            desc = self.convDb(cDa)
            dn = torch.norm(desc, p=2, dim=1, keepdim=True)
            desc = desc / dn

            return semi, desc

    model = SuperPointNet()

    # Load pretrained weights if available
    weights_path = Path("scripts/superpoint_v1.pth")
    if weights_path.exists():
        model.load_state_dict(torch.load(str(weights_path), map_location="cpu"))
        log("Loaded pretrained SuperPoint weights")
    else:
        log("WARNING: No pretrained weights found at scripts/superpoint_v1.pth")
        log("Download from: https://github.com/magicleap/SuperPointPretrainedNetwork")
        log("Exporting with random weights for structure validation only...")

    model.eval()
    dummy = torch.randn(1, 1, 240, 320)

    out_path = OUTPUT_DIR / "superpoint.onnx"
    torch.onnx.export(
        model, dummy, str(out_path),
        input_names=["image"],
        output_names=["keypoint_scores", "descriptors"],
        dynamic_axes={"image": {2: "height", 3: "width"}},
        opset_version=13,
    )

    check_size(out_path, 3)
    ok("superpoint.onnx ready")


# ── 3. LightGlue Lite → ONNX ────────────────────────────

def convert_lightglue():
    log("Converting LightGlue (lite) → ONNX...")
    try:
        import torch
    except ImportError as e:
        err(f"Missing dependency: {e}")

    # Try to use official LightGlue repo if available
    lightglue_path = Path("scripts/LightGlue")
    if not lightglue_path.exists():
        log("LightGlue repo not found. Cloning...")
        os.system("git clone https://github.com/cvg/LightGlue.git scripts/LightGlue")
        sys.path.insert(0, "scripts/LightGlue")

    try:
        sys.path.insert(0, str(lightglue_path))
        from lightglue import LightGlue
        from lightglue.utils import load_image, rbd

        matcher = LightGlue(features="superpoint", depth_confidence=0.9,
                             width_confidence=0.95).eval()

        # Export to ONNX via torch.export
        # Note: LightGlue has dynamic shapes; use fixed size for mobile
        log("Exporting LightGlue with fixed keypoint count (512 max)...")

        # Create dummy inputs matching SuperPoint output format
        kpts0   = torch.randn(1, 512, 2)
        kpts1   = torch.randn(1, 512, 2)
        desc0   = torch.randn(1, 512, 256)
        desc1   = torch.randn(1, 512, 256)

        out_path = OUTPUT_DIR / "lightglue_lite.onnx"
        torch.onnx.export(
            matcher,
            (kpts0, kpts1, desc0, desc1),
            str(out_path),
            input_names=["kpts0", "kpts1", "desc0", "desc1"],
            output_names=["matches0", "scores0"],
            opset_version=13,
        )
    except Exception as e:
        log(f"Full LightGlue export failed: {e}")
        log("Falling back to simplified matcher stub for validation...")
        _export_lightglue_stub()
        return

    check_size(out_path, 8)
    ok("lightglue_lite.onnx ready")


def _export_lightglue_stub():
    """Exports a minimal attention-based matcher for latency testing."""
    import torch
    import torch.nn as nn

    class SimpleMatcher(nn.Module):
        def __init__(self, desc_dim=256, n_layers=4):
            super().__init__()
            self.layers = nn.ModuleList([
                nn.MultiheadAttention(desc_dim, 4, batch_first=True)
                for _ in range(n_layers)
            ])
            self.final = nn.Linear(desc_dim, 1)

        def forward(self, desc0, desc1):
            for attn in self.layers:
                desc0, _ = attn(desc0, desc1, desc1)
            scores = self.final(desc0).squeeze(-1)
            return scores

    model = SimpleMatcher().eval()
    desc0 = torch.randn(1, 512, 256)
    desc1 = torch.randn(1, 512, 256)
    out_path = OUTPUT_DIR / "lightglue_lite.onnx"
    torch.onnx.export(model, (desc0, desc1), str(out_path),
                      input_names=["desc0","desc1"],
                      output_names=["scores"],
                      opset_version=13)
    check_size(out_path, 8)
    ok("lightglue_lite.onnx (stub) ready — replace with full model before M1")


# ── 4. MixVPR → TFLite ──────────────────────────────────

def convert_mixvpr():
    log("Converting MixVPR → TFLite...")
    try:
        import torch
        import torch.nn as nn
        import tensorflow as tf
    except ImportError as e:
        err(f"Missing dependency: {e}")

    # MixVPR: ResNet50 backbone + MixerBlock aggregation
    # Reference: https://github.com/amaralibey/MixVPR
    class MixerBlock(nn.Module):
        def __init__(self, in_channels, out_channels):
            super().__init__()
            self.mix = nn.Sequential(
                nn.Linear(in_channels, out_channels),
                nn.GELU(),
                nn.Linear(out_channels, out_channels),
            )
            self.norm = nn.LayerNorm(out_channels)

        def forward(self, x):
            return self.norm(self.mix(x) + x if x.shape[-1] == self.mix[-1].out_features else self.mix(x))

    class MixVPR(nn.Module):
        def __init__(self, out_channels=512):
            super().__init__()
            import torchvision.models as models
            backbone = models.resnet50(weights=models.ResNet50_Weights.IMAGENET1K_V2)
            self.backbone = nn.Sequential(*list(backbone.children())[:-2])
            self.pool     = nn.AdaptiveAvgPool2d((4, 4))
            self.mix1     = MixerBlock(2048, 1024)
            self.mix2     = MixerBlock(1024, out_channels)
            self.norm     = nn.functional.normalize

        def forward(self, x):
            x = self.backbone(x)    # (B, 2048, H, W)
            x = self.pool(x)        # (B, 2048, 4, 4)
            x = x.flatten(1)        # (B, 2048*16 = 32768) — flatten spatial
            x = x[:, :2048]         # Use channel features only for speed
            x = self.mix1(x)
            x = self.mix2(x)
            return self.norm(x, dim=1)  # L2-normalized 512-dim embedding

    model = MixVPR(out_channels=512)

    # Load pretrained weights if available
    weights_path = Path("scripts/mixvpr_resnet50_R_512_G_512.ckpt")
    if weights_path.exists():
        state = torch.load(str(weights_path), map_location="cpu")
        # Handle checkpoint format variations
        if "state_dict" in state:
            state = {k.replace("model.", ""): v for k, v in state["state_dict"].items()}
        model.load_state_dict(state, strict=False)
        log("Loaded pretrained MixVPR weights")
    else:
        log("WARNING: No pretrained weights. Using ImageNet backbone only.")
        log("Download from: https://github.com/amaralibey/MixVPR (releases)")

    model.eval()

    # Export to ONNX
    dummy = torch.randn(1, 3, 224, 224)
    onnx_path = OUTPUT_DIR / "mixvpr_tmp.onnx"
    torch.onnx.export(model, dummy, str(onnx_path),
                      input_names=["image"],
                      output_names=["embedding"],
                      opset_version=13)

    # ONNX → TFLite
    try:
        import onnx
        from onnx_tf.backend import prepare

        onnx_model = onnx.load(str(onnx_path))
        tf_rep = prepare(onnx_model)
        saved_dir = OUTPUT_DIR / "mixvpr_saved"
        tf_rep.export_graph(str(saved_dir))

        converter = tf.lite.TFLiteConverter.from_saved_model(str(saved_dir))
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float16]
        tflite_model = converter.convert()

        out_path = OUTPUT_DIR / "mixvpr.tflite"
        out_path.write_bytes(tflite_model)

        import shutil
        shutil.rmtree(saved_dir, ignore_errors=True)
        onnx_path.unlink(missing_ok=True)

    except ImportError:
        log("onnx_tf not available. Saving as ONNX for now (TFLite conversion requires onnx_tf).")
        import shutil
        shutil.copy(str(onnx_path), str(OUTPUT_DIR / "mixvpr.onnx"))
        onnx_path.unlink(missing_ok=True)
        ok("mixvpr.onnx ready (convert to TFLite with onnx_tf when available)")
        return

    check_size(out_path, 15)
    ok("mixvpr.tflite ready")


# ── Main ─────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="ZON model conversion")
    parser.add_argument("--model", choices=["depth", "superpoint", "lightglue", "mixvpr", "all"],
                        default="all", help="Which model to convert")
    args = parser.parse_args()

    log(f"Output directory: {OUTPUT_DIR.absolute()}")
    log("="*50)

    if args.model in ("depth", "all"):
        try:
            convert_depth_anything()
        except Exception as e:
            log(f"Depth Anything conversion failed: {e}")
            log("Manual download: https://huggingface.co/depth-anything/Depth-Anything-V2-Small-hf")

    if args.model in ("superpoint", "all"):
        try:
            convert_superpoint()
        except Exception as e:
            log(f"SuperPoint conversion failed: {e}")
            log("Manual download: https://github.com/magicleap/SuperPointPretrainedNetwork")

    if args.model in ("lightglue", "all"):
        try:
            convert_lightglue()
        except Exception as e:
            log(f"LightGlue conversion failed: {e}")
            log("Manual: https://github.com/cvg/LightGlue")

    if args.model in ("mixvpr", "all"):
        try:
            convert_mixvpr()
        except Exception as e:
            log(f"MixVPR conversion failed: {e}")
            log("Manual: https://github.com/amaralibey/MixVPR")

    log("="*50)
    log("Conversion complete. Copy output files to assets/models/")
    log("Then run: flutter pub run scripts/validate_models.dart")


if __name__ == "__main__":
    main()
