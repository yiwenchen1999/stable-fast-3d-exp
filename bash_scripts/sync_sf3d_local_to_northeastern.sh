#!/usr/bin/env bash
# Step (3): local dir -> NE_HOST:NE_REMOTE
#
# From repo root (or anywhere):
#   bash_scripts/sync_sf3d_local_to_northeastern.sh
#
# See sync_sf3d_env.inc for NE_HOST, NE_REMOTE, LOCAL_DIR, RSYNC_OPTS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=sync_sf3d_env.inc
source "$SCRIPT_DIR/sync_sf3d_env.inc"

cd "$REPO_ROOT"

if [[ ! -d "$LOCAL_DIR" ]]; then
  echo "error: LOCAL_DIR missing: $LOCAL_DIR" >&2
  exit 1
fi

echo "[sync step 3] ${LOCAL_DIR}/ -> ${NE_HOST}:${NE_REMOTE}"
# shellcheck disable=SC2086
"${RSYNC_BASE[@]}" $RSYNC_OPTS \
  "${LOCAL_DIR}/" \
  "${NE_HOST}:${NE_REMOTE}"

echo "[sync step 3] done."
