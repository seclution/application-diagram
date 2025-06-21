#!/bin/bash
set -euo pipefail

# This script edits pom.xml using xmlstarlet which must be installed.
if ! command -v xmlstarlet >/dev/null 2>&1; then
    echo "Error: xmlstarlet is required but was not found in PATH." >&2
    exit 1
fi

usage() {
    echo "Usage: $0 <path-to-draw.io-webjar> [--commit]" >&2
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

JAR_PATH="$1"
COMMIT="${2:-}"

if [ ! -f "$JAR_PATH" ]; then
    echo "File not found: $JAR_PATH" >&2
    exit 1
fi

JAR_FILE="$(basename "$JAR_PATH")"
VERSION="${JAR_FILE#draw.io-}"
VERSION="${VERSION%.jar}"

# Update pom.xml dependency version
xmlstarlet ed -L \
    -u "/_:project/_:dependencies/_:dependency[_:groupId='org.xwiki.contrib'][_:artifactId='draw.io']/_:version" \
    -v "$VERSION" pom.xml

echo "Updated pom.xml to use draw.io version $VERSION"

if [ "$COMMIT" = "--commit" ]; then
    if [ -n "$(git status --porcelain pom.xml)" ]; then
        git add pom.xml
        git commit -m "chore: update draw.io WebJar to $VERSION"
    else
        echo "No changes to commit"
    fi
fi
