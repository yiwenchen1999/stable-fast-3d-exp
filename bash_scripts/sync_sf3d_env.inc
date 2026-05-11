# Shared defaults for SF3D mesh rsync helpers.
# Shellcheck: sourced by sync_sf3d_*.sh (not runnable on its own).
#
# Optional env (exported before calling any sync script overrides these):
#   REMOTE_GPU         SSH target for GPU machine (default: yiwen@204.12.169.196)
#   REMOTE_INPUT_VIEW  Absolute path on GPU to input_view/ (must end with / for rsync semantics)
#   NE_HOST             SSH alias for Northeastern file transfer host
#   NE_REMOTE           Absolute path on NE to sf3d_meshes/ (trailing /)
#   LOCAL_DIR           Local mirror directory (default: <repo>/output)
#   RSYNC_OPTS           Extra rsync args (shell word-split), e.g. --dry-run
_SYNC_SCRIPTS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$_SYNC_SCRIPTS/.." && pwd)"

REMOTE_GPU="${REMOTE_GPU:-yiwen@204.12.169.196}"
REMOTE_INPUT_VIEW="${REMOTE_INPUT_VIEW:-/home/yiwen/stable-fast-3d-exp/input_view/}"
NE_HOST="${NE_HOST:-northeastern-fileTransfer}"
NE_REMOTE="${NE_REMOTE:-/projects/vig/Datasets/objaverse/hf-objaverse-v1/sf3d_meshes/}"
LOCAL_DIR="${LOCAL_DIR:-$REPO_ROOT/output}"
RSYNC_OPTS="${RSYNC_OPTS:-}"

RSYNC_BASE=(rsync -avz --progress)
