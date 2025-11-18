#!/bin/bash

# Simple WP Plugin SVN Release Script
# Usage: ./release.sh <version> [source-dir] [svn-dir]

set -e

# Default values - EDIT THESE
DEFAULT_SOURCE_DIR="./builds"
DEFAULT_SVN_DIR="./svn"

VERSION=$1
SOURCE_DIR=${2:-$DEFAULT_SOURCE_DIR}
SVN_DIR=${3:-$DEFAULT_SVN_DIR}

if [ -z "$VERSION" ]; then
    echo "Error: Version is required"
    echo "Usage: $0 <version> [source-dir] [svn-dir]"
    echo "Example: $0 1.2.1  (uses defaults: $DEFAULT_SOURCE_DIR, $DEFAULT_SVN_DIR)"
    echo "Example: $0 1.2.1 ./my-plugin ./my-plugin-svn"
    exit 1
fi

# Convert to absolute path before changing directory
SOURCE_DIR=$(cd "$SOURCE_DIR" && pwd)

cd "$SVN_DIR"

echo "→ Updating SVN..."
svn update

# Check if tag already exists
if svn info "tags/$VERSION" >/dev/null 2>&1; then
    echo "Error: Tag $VERSION already exists!"
    exit 1
fi

echo "→ Copying files to trunk..."
rsync -av --delete "$SOURCE_DIR/" trunk/

echo "→ Adding new files..."
svn status trunk | grep '^?' | awk '{print $2}' | xargs -r svn add

echo "→ Removing deleted files..."
svn status trunk | grep '^!' | awk '{print $2}' | xargs -r svn rm

echo "→ Creating tag..."
svn cp trunk "tags/$VERSION"

echo "→ Committing..."
svn ci -m "Release version $VERSION"

echo "✓ Done! Released version $VERSION"