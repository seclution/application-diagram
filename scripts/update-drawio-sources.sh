#!/bin/bash
set -euo pipefail
REPO_URL="${1:-https://github.com/jgraph/drawio.git}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${SCRIPT_DIR}/../drawio_sources/drawio"

if [ ! -d "${TARGET_DIR}/.git" ]; then
    git submodule add "$REPO_URL" "$TARGET_DIR"
else
    git -C "${TARGET_DIR}" remote set-url origin "$REPO_URL"
fi

git submodule update --init --remote "${TARGET_DIR}"
echo "draw.io sources updated"
