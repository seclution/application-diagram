#!/bin/bash
set -euo pipefail
REPO_URL="${1:-https://github.com/jgraph/drawio.git}"
# Optional git reference (tag or commit) to checkout
REF="${2-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
TARGET_DIR="${REPO_ROOT}/drawio_sources/drawio"


if git submodule status "${TARGET_DIR}" >/dev/null 2>&1; then
    if [ ! -d "${TARGET_DIR}/.git" ]; then
        git submodule update --init "${TARGET_DIR}"
    fi
    git -C "${TARGET_DIR}" remote set-url origin "$REPO_URL"
else
    git submodule add "$REPO_URL" "$TARGET_DIR"
fi

git submodule update --init --remote "${TARGET_DIR}"

if [ -n "${REF}" ]; then
    git -C "${TARGET_DIR}" fetch
    git -C "${TARGET_DIR}" checkout "${REF}"
fi
TARGET_LIB_DIR="${TARGET_DIR}/src/main/webapp/WEB-INF/lib"
if [ -d "${TARGET_LIB_DIR}" ]; then
    find "${TARGET_LIB_DIR}" -name '*.jar' -delete
fi
echo "draw.io sources updated"
