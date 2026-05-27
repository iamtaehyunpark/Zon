"""
Downloads and converts real pretrained weights for all ZON M1 models.

Run once before M1 validation:
    pip install torch torchvision onnx kornia requests
    python scripts/download_real_weights.py

Output: assets/models/ (replaces stub .onnx files)
"""

import os
import sys
import urllib.request

MODELS_DIR = os.path.join(os.path.dirname(__file__), '..', 'assets', 'models')


def download(url, dest, label):
    if os.path.exists(dest):
        print(f'  [skip] {label} already exists')
        return
    print(f'  Downloading {label}…')
    urllib.request.urlretrieve(url, dest,
        reporthook=lambda b, bs, t: print(
            f'    {min(b*bs, t)*100//max(t,1)}%', end='\r'))
    print(f'  ✓ {label} saved ({os.path.getsize(dest)//1024//1024} MB)')


# ── M1: SuperPoint ────────────────────────────────────────────────────────────

def export_superpoint():
    """Download Magic Leap pretrained weights and export to ONNX."""
    import torch
    import torch.nn as nn

    WEIGHTS_URL = (
        'https://github.com/magicleap/SuperPointPretrainedNetwork/'
        'raw/master/superpoint_v1.pth'
    )
    weights_path = os.path.join(MODELS_DIR, '_superpoint_v1.pth')
    download(WEIGHTS_URL, weights_path, 'SuperPoint weights')

    # SuperPoint architecture (from the original paper)
    class SuperPointNet(nn.Module):
        def __init__(self):
            super().__init__()
            self.relu  = nn.ReLU(inplace=True)
            self.pool  = nn.MaxPool2d(kernel_size=2, stride=2)
            c1, c2, c3, c4, c5 = 64, 64, 128, 128, 256

            self.conv1a = nn.Conv2d(1,  c1, 3, padding=1)
            self.conv1b = nn.Conv2d(c1, c1, 3, padding=1)
            self.conv2a = nn.Conv2d(c1, c2, 3, padding=1)
            self.conv2b = nn.Conv2d(c2, c2, 3, padding=1)
            self.conv3a = nn.Conv2d(c2, c3, 3, padding=1)
            self.conv3b = nn.Conv2d(c3, c3, 3, padding=1)
            self.conv4a = nn.Conv2d(c3, c4, 3, padding=1)
            self.conv4b = nn.Conv2d(c4, c4, 3, padding=1)
            # Detector head
            self.convPa = nn.Conv2d(c4, c5, 3, padding=1)
            self.convPb = nn.Conv2d(c5, 65, 1)
            # Descriptor head
            self.convDa = nn.Conv2d(c4, c5, 3, padding=1)
            self.convDb = nn.Conv2d(c5, 256, 1)

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
            p = self.relu(self.convPa(x))
            scores = self.convPb(p)  # [B, 65, H/8, W/8]
            # Descriptor
            d = self.relu(self.convDa(x))
            desc = self.convDb(d)    # [B, 256, H/8, W/8]
            dn = desc.norm(p=2, dim=1, keepdim=True)
            desc = desc / (dn + 1e-8)
            return scores, desc

    print('  Building SuperPoint with pretrained weights…')
    model = SuperPointNet()
    weights = torch.load(weights_path, map_location='cpu')
    model.load_state_dict(weights)
    model.eval()

    dummy = torch.zeros(1, 1, 240, 320)
    out_path = os.path.join(MODELS_DIR, 'superpoint.onnx')
    torch.onnx.export(
        model, dummy, out_path,
        input_names=['image'],
        output_names=['scores', 'descriptors'],
        opset_version=11,
        dynamic_axes={'image': {0: 'batch'}},
    )
    print(f'  ✓ superpoint.onnx ({os.path.getsize(out_path)//1024//1024} MB)')


# ── M2: LightGlue ────────────────────────────────────────────────────────────

def export_lightglue():
    """Export LightGlue lite via kornia."""
    try:
        import kornia.feature as KF
    except ImportError:
        print('  [ERROR] Run: pip install kornia')
        return
    import torch

    print('  Exporting LightGlue lite…')
    matcher = KF.LightGlue('superpoint').eval()

    # LightGlue takes kpts + desc from two images
    kpts0  = torch.zeros(1, 512, 2)
    kpts1  = torch.zeros(1, 512, 2)
    desc0  = torch.zeros(1, 512, 256)
    desc1  = torch.zeros(1, 512, 256)

    out_path = os.path.join(MODELS_DIR, 'lightglue_lite.onnx')
    torch.onnx.export(
        matcher,
        (kpts0, kpts1, desc0, desc1),
        out_path,
        input_names=['kpts0', 'kpts1', 'desc0', 'desc1'],
        output_names=['matches0', 'matches1', 'matching_scores0'],
        opset_version=11,
    )
    print(f'  ✓ lightglue_lite.onnx ({os.path.getsize(out_path)//1024//1024} MB)')


# ── M3: MixVPR ───────────────────────────────────────────────────────────────

def export_mixvpr():
    """
    Builds a MixVPR-compatible model using torchvision pretrained ResNet50
    backbone (ImageNet weights) + L2-normalised 512-dim aggregation head.

    The backbone is properly trained and produces semantically meaningful
    visual features. The aggregation head uses random init; replace with
    the VPR-trained head when the official checkpoint becomes available at:
      https://github.com/amaralibey/MixVPR
    """
    try:
        import torch
        import torchvision.models as models
        import torch.nn as nn
        import torch.nn.functional as F
    except ImportError:
        print('  [ERROR] Run: pip install torch torchvision')
        return

    print('  Building MixVPR with ImageNet pretrained ResNet50 backbone…')

    class MixVPRModel(nn.Module):
        def __init__(self, out_dim=512):
            super().__init__()
            # ResNet50 with official ImageNet weights — real visual features
            backbone = models.resnet50(weights=models.ResNet50_Weights.IMAGENET1K_V2)
            # Drop the classification head; keep spatial features
            self.encoder = nn.Sequential(*list(backbone.children())[:-2])
            self.pool = nn.AdaptiveAvgPool2d((1, 1))
            self.proj = nn.Linear(2048, out_dim)

        def forward(self, x):
            feats = self.encoder(x)        # [B, 2048, H, W]
            feats = self.pool(feats)       # [B, 2048, 1, 1]
            feats = feats.flatten(1)       # [B, 2048]
            out   = self.proj(feats)       # [B, 512]
            return F.normalize(out, p=2, dim=1)  # L2-normalised

    model = MixVPRModel().eval()

    dummy = torch.zeros(1, 3, 224, 224)
    out_path = os.path.join(MODELS_DIR, 'mixvpr.onnx')
    torch.onnx.export(
        model, dummy, out_path,
        input_names=['image'],
        output_names=['embedding'],
        opset_version=11,
        dynamic_axes={'image': {0: 'batch'}},
    )

    # Enforce IR version 7 for ORT Mobile compatibility
    import onnx
    m = onnx.load(out_path)
    m.ir_version = 7
    onnx.save(m, out_path)

    size_mb = os.path.getsize(out_path) // 1024 // 1024
    print(f'  ✓ mixvpr.onnx ({size_mb} MB) — ImageNet backbone, L2 output')


# ── M1: Depth Anything V2-Small (TFLite path) ────────────────────────────────

def export_depth():
    """
    Downloads Depth Anything V2-Small and converts to ONNX with opset 11 / IR 7.

    The HuggingFace checkpoint (FP32, 24.8M params) is ~99 MB.
    For M1 on-device we target TFLite FP16 (~24 MB) via ai_edge_torch.

    If ai_edge_torch is not available, falls back to FP32 ONNX (99 MB).
    """
    try:
        from transformers import AutoImageProcessor
        from transformers import AutoModelForDepthEstimation
        import torch
    except ImportError:
        print('  [ERROR] Run: pip install transformers torch')
        return

    print('  Downloading Depth Anything V2-Small from HuggingFace…')
    model = AutoModelForDepthEstimation.from_pretrained(
        'depth-anything/Depth-Anything-V2-Small-hf')
    model.eval()

    dummy = {'pixel_values': torch.zeros(1, 3, 256, 256)}

    # Try ai_edge_torch → TFLite FP16 first
    try:
        import ai_edge_torch
        print('  Converting to TFLite via ai_edge_torch…')
        edge_model = ai_edge_torch.convert(
            model, (dummy['pixel_values'],))
        tflite_path = os.path.join(MODELS_DIR, 'depth_anything_v2_small.tflite')
        edge_model.export(tflite_path)
        print(f'  ✓ TFLite saved ({os.path.getsize(tflite_path)//1024//1024} MB)')
        return
    except Exception as e:
        print(f'  ai_edge_torch failed ({e}), falling back to ONNX…')

    # Fallback: export FP32 ONNX with opset 11 / IR version 7
    import onnx
    out_path = os.path.join(MODELS_DIR, 'depth_anything_v2_small.onnx')
    torch.onnx.export(
        model,
        (dummy['pixel_values'],),
        out_path,
        input_names=['pixel_values'],
        output_names=['depth_map'],
        opset_version=11,
        dynamic_axes={'pixel_values': {0: 'batch'}},
    )
    m = onnx.load(out_path)
    m.ir_version = 7
    onnx.save(m, out_path)
    print(f'  ✓ ONNX FP32 saved ({os.path.getsize(out_path)//1024//1024} MB)')
    print('  NOTE: 99 MB exceeds 56 MB budget — convert to TFLite FP16 for M1.')


# ── Main ──────────────────────────────────────────────────────────────────────

if __name__ == '__main__':
    os.makedirs(MODELS_DIR, exist_ok=True)
    steps = {
        'superpoint':   export_superpoint,
        'lightglue':    export_lightglue,
        'mixvpr':       export_mixvpr,
        'depth':        export_depth,
    }

    targets = sys.argv[1:] or list(steps.keys())
    for t in targets:
        if t not in steps:
            print(f'Unknown model: {t}. Choose from {list(steps.keys())}')
            continue
        print(f'\n── {t.upper()} ──')
        steps[t]()

    print('\nDone. Run the M0 model validation screen on device to verify.')
