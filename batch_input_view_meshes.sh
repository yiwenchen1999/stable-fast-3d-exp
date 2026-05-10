#!/usr/bin/env bash
# Batch SF3D mesh generation for scenes under input_view/.
# For each immediate subdirectory of input_view/, finds input512_view_00.png /
# input512_view_01.png (latest by sort -V if several iter_* trees exist) and writes
# mesh_00.glb / mesh_01.glb in that scene root.
#
# Usage (repo root; activate your SF3D venv first):
#   chmod +x batch_input_view_meshes.sh
#   ./batch_input_view_meshes.sh
#
# Optional env:
#   INPUT_ROOT  path to scenes (default: <repo>/input_view)
#   DEVICE      e.g. cuda / cuda:0 (passed to run.py if set)
#   TEXTURE     atlas size (default 1024)
#   PRETRAINED  HF id or local model dir (default stabilityai/stable-fast-3d)
#   PYTHON      interpreter (default python)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

INPUT_ROOT="${INPUT_ROOT:-$SCRIPT_DIR/input_view}"
DEVICE="${DEVICE:-}"
TEXTURE="${TEXTURE:-1024}"
PRETRAINED="${PRETRAINED:-stabilityai/stable-fast-3d}"
PYTHON="${PYTHON:-python}"

if [[ ! -d "$INPUT_ROOT" ]]; then
  echo "error: input dir not found: $INPUT_ROOT" >&2
  exit 1
fi

run_one() {
  local img_path="$1"
  local out_glb="$2"
  local tmp
  tmp="$(mktemp -d)"
  local -a extra=()
  if [[ -n "$DEVICE" ]]; then
    extra+=(--device "$DEVICE")
  fi
  if ! "$PYTHON" run.py "$img_path" \
    --output-dir "$tmp" \
    --pretrained-model "$PRETRAINED" \
    --texture-resolution "$TEXTURE" \
    "${extra[@]}"; then
    rm -rf "$tmp"
    echo "error: run.py failed for $img_path" >&2
    return 1
  fi
  if [[ ! -f "$tmp/0/mesh.glb" ]]; then
    rm -rf "$tmp"
    echo "error: missing $tmp/0/mesh.glb after run.py" >&2
    return 1
  fi
  mv "$tmp/0/mesh.glb" "$out_glb"
  rm -rf "$tmp"
  echo "wrote $out_glb"
}

for scene in "$INPUT_ROOT"/*/; do
  [[ -d "$scene" ]] || continue

  # sort -V + tail: prefer last iter_* if multiple matches (e.g. iter_00000100, iter_00000297)
  v00="$(find "$scene" -name 'input512_view_00.png' -type f | sort -V | tail -n 1 || true)"
  v01="$(find "$scene" -name 'input512_view_01.png' -type f | sort -V | tail -n 1 || true)"

  if [[ -z "$v00" ]]; then
    echo "skip (no input512_view_00.png): $scene" >&2
    continue
  fi
  if [[ -z "$v01" ]]; then
    echo "skip (no input512_view_01.png): $scene" >&2
    continue
  fi

  echo "== scene: $scene"
  echo "   view_00: $v00"
  echo "   view_01: $v01"

  run_one "$v00" "${scene}mesh_00.glb"
  run_one "$v01" "${scene}mesh_01.glb"
done

echo "done."
