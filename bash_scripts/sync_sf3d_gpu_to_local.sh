#!/usr/bin/env bash
# Step (2): REMOTE_GPU:REMOTE_INPUT_VIEW -> local dir
#
# From repo root (or anywhere):
#   bash_scripts/sync_sf3d_gpu_to_local.sh
#
# See sync_sf3d_env.inc for REMOTE_GPU, REMOTE_INPUT_VIEW, LOCAL_DIR, RSYNC_OPTS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=sync_sf3d_env.inc
source "$SCRIPT_DIR/sync_sf3d_env.inc"

cd "$REPO_ROOT"

mkdir -p "$LOCAL_DIR"

echo "[sync step 2] ${REMOTE_GPU}:${REMOTE_INPUT_VIEW} -> ${LOCAL_DIR}/"
# shellcheck disable=SC2086
"${RSYNC_BASE[@]}" $RSYNC_OPTS \
  "${REMOTE_GPU}:${REMOTE_INPUT_VIEW}" \
  "${LOCAL_DIR}/"

echo "[sync step 2] done."
