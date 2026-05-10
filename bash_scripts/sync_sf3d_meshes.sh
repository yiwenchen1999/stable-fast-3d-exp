#!/usr/bin/env bash
# Pull remote input_view into local output/, then push output/ to Northeastern file transfer.
#
# Usage (repo root):
#   chmod +x sync_sf3d_meshes.sh
#   ./sync_sf3d_meshes.sh
#
# Optional env:
#   PULL_ONLY=1   only rsync from PULL_HOST (skip push)
#   PUSH_ONLY=1   only rsync to PUSH_HOST (skip pull)
#   PULL_HOST     default: yiwen@204.12.169.196
#   PULL_REMOTE   default: /home/yiwen/stable-fast-3d-exp/input_view/
#   PUSH_HOST     default: northeastern-fileTransfer
#   PUSH_REMOTE   default: /projects/vig/Datasets/objaverse/hf-objaverse-v1/sf3d_meshes/
#   LOCAL_DIR     default: <repo>/output
#   RSYNC_OPTS    extra rsync words (shell word-split), e.g. --dry-run
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PULL_HOST="${PULL_HOST:-yiwen@204.12.169.196}"
PULL_REMOTE="${PULL_REMOTE:-/home/yiwen/stable-fast-3d-exp/input_view/}"
PUSH_HOST="${PUSH_HOST:-northeastern-fileTransfer}"
PUSH_REMOTE="${PUSH_REMOTE:-/projects/vig/Datasets/objaverse/hf-objaverse-v1/sf3d_meshes/}"
LOCAL_DIR="${LOCAL_DIR:-$SCRIPT_DIR/output}"
RSYNC_OPTS="${RSYNC_OPTS:-}"

PULL_ONLY="${PULL_ONLY:-0}"
PUSH_ONLY="${PUSH_ONLY:-0}"

if [[ "$PULL_ONLY" == "1" && "$PUSH_ONLY" == "1" ]]; then
  echo "error: set at most one of PULL_ONLY=1 or PUSH_ONLY=1" >&2
  exit 1
fi

RSYNC_BASE=(rsync -avz --progress)

do_pull() {
  echo "[sync] pull: ${PULL_HOST}:${PULL_REMOTE} -> ${LOCAL_DIR}/"
  mkdir -p "$LOCAL_DIR"
  # shellcheck disable=SC2086
  "${RSYNC_BASE[@]}" $RSYNC_OPTS \
    "${PULL_HOST}:${PULL_REMOTE}" \
    "${LOCAL_DIR}/"
}

do_push() {
  echo "[sync] push: ${LOCAL_DIR}/ -> ${PUSH_HOST}:${PUSH_REMOTE}"
  if [[ ! -d "$LOCAL_DIR" ]]; then
    echo "error: local dir missing: $LOCAL_DIR" >&2
    exit 1
  fi
  # shellcheck disable=SC2086
  "${RSYNC_BASE[@]}" $RSYNC_OPTS \
    "${LOCAL_DIR}/" \
    "${PUSH_HOST}:${PUSH_REMOTE}"
}

if [[ "$PUSH_ONLY" == "1" ]]; then
  do_push
elif [[ "$PULL_ONLY" == "1" ]]; then
  do_pull
else
  do_pull
  do_push
fi

echo "[sync] done."
