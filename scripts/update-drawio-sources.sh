#!/bin/bash
set -euo pipefail

# Refresh the draw.io sources used only for reference when updating the WebJar.
# Usage: ./scripts/update-drawio-sources.sh [git_url] [git_ref]
# If no git_url is provided, the official jgraph/drawio repository is used.
# Optionally a git_ref (tag, branch or commit) can be specified to check out a
# particular version.

REPO_URL="${1:-https://github.com/jgraph/drawio.git}"
GIT_REF="${2:-}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="${SCRIPT_DIR}/../drawio_sources/drawio"

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

echo "Cloning $REPO_URL..."
if [ -n "$GIT_REF" ]; then
    git clone --depth 1 --branch "$GIT_REF" "$REPO_URL" "$WORK_DIR/drawio"
else
    git clone --depth 1 "$REPO_URL" "$WORK_DIR/drawio"
fi

# Sync the sources while removing previously deleted files
rsync -a --delete "$WORK_DIR/drawio/" "$TARGET_DIR/"

# Drop pre-built JARs produced by the draw.io build
LIB_DIR="$TARGET_DIR/src/main/webapp/WEB-INF/lib"
if [ -d "$LIB_DIR" ]; then
    echo "Removing jars from $LIB_DIR"
    rm -f "$LIB_DIR"/*.jar
fi

echo "Sources refreshed in $TARGET_DIR"
