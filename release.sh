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

cd "$SVN_DIR"

echo "→ Updating SVN..."
svn update

echo "→ Copying files to trunk..."
cp -r "$SOURCE_DIR"/* trunk/

echo "→ Adding new files..."
svn add trunk/* --force

echo "→ Creating tag..."
svn cp trunk tags/$VERSION

echo "→ Committing..."
svn ci -m "Releases version $VERSION"

echo "✓ Done! Released version $VERSION"
