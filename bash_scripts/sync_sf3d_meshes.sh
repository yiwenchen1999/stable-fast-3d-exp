#!/usr/bin/env bash
# Run SF3D mesh rsync workflow in three steps:
#   (1) bash_scripts/sync_sf3d_local_to_gpu.sh — local dir -> GPU input_view/
#   (2) bash_scripts/sync_sf3d_gpu_to_local.sh — GPU input_view/ -> local
#   (3) bash_scripts/sync_sf3d_local_to_northeastern.sh — local -> NE dataset dir
#
# Usage (repository root typical):
#   bash_scripts/sync_sf3d_meshes.sh
#
# Optional env: same as sync_sf3d_env.inc (REMOTE_GPU, REMOTE_INPUT_VIEW, NE_HOST,
# NE_REMOTE, LOCAL_DIR, RSYNC_OPTS).
#
# To run only one step, execute that script directly.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STEP1="$SCRIPT_DIR/sync_sf3d_local_to_gpu.sh"
STEP2="$SCRIPT_DIR/sync_sf3d_gpu_to_local.sh"
STEP3="$SCRIPT_DIR/sync_sf3d_local_to_northeastern.sh"

"$STEP1"
"$STEP2"
"$STEP3"

echo "[sync_sf3d_meshes] all steps done."
