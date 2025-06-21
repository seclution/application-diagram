#!/bin/bash
set -euo pipefail
REPO_URL="${1:-https://github.com/jgraph/drawio.git}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
TARGET_DIR="${REPO_ROOT}/drawio_sources/drawio"
RELATIVE_DIR="drawio_sources/drawio"


if git submodule status "${TARGET_DIR}" >/dev/null 2>&1; then
    if [ ! -d "${TARGET_DIR}/.git" ]; then
        git submodule update --init "${TARGET_DIR}"
    fi
    git -C "${TARGET_DIR}" remote set-url origin "$REPO_URL"
else
    git submodule add "$REPO_URL" "$TARGET_DIR"
fi

git submodule update --init --remote "$RELATIVE_DIR"
echo "draw.io sources updated"
