#!/usr/bin/env bash
# Step (1): local dir -> REMOTE_GPU:REMOTE_INPUT_VIEW
#
# From repo root (or anywhere):
#   bash_scripts/sync_sf3d_local_to_gpu.sh
#
# See sync_sf3d_env.inc for REMOTE_GPU, REMOTE_INPUT_VIEW, LOCAL_DIR, RSYNC_OPTS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=sync_sf3d_env.inc
source "$SCRIPT_DIR/sync_sf3d_env.inc"

cd "$REPO_ROOT"

if [[ ! -d "$LOCAL_DIR" ]]; then
  echo "error: LOCAL_DIR missing: $LOCAL_DIR" >&2
  exit 1
fi

echo "[sync step 1] ${LOCAL_DIR}/ -> ${REMOTE_GPU}:${REMOTE_INPUT_VIEW}"
# shellcheck disable=SC2086
"${RSYNC_BASE[@]}" $RSYNC_OPTS \
  "${LOCAL_DIR}/" \
  "${REMOTE_GPU}:${REMOTE_INPUT_VIEW}"

echo "[sync step 1] done."
