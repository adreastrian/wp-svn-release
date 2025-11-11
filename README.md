# WordPress Plugin SVN Release Script

A simple bash script to fully automate WordPress plugin releases to the WordPress.org SVN repository.

## Overview

This script streamlines and automates the entire process of releasing WordPress plugin versions by:
- Updating the SVN repository
- Copying built files to the trunk
- Creating version tags
- Automatically committing to WordPress.org plugin directory

## Prerequisites

- SVN command line tools installed
- Access to your WordPress plugin's SVN repository on WordPress.org
- Built plugin files ready for release

## Installation

1. Download the `release.sh` script to your plugin directory
2. Make it executable:
   ```bash
   chmod +x release.sh
   ```

## Usage

### Basic Usage
```bash
./release.sh <version>
```

### Advanced Usage
```bash
./release.sh <version> [source-dir] [svn-dir]
```

### Examples

```bash
# Release version 1.2.5 using default directories
./release.sh 1.2.5

# Release with custom source directory
./release.sh 1.2.5 ./dist

# Release with custom source and SVN directories
./release.sh 1.2.5 ./dist ./my-plugin-svn
```

## Configuration

### Default Directories

The script uses these default directories (modify these variables in the script):

```bash
DEFAULT_SOURCE_DIR="./builds"    # Where built plugin files are located
DEFAULT_SVN_DIR="./svn"         # Local SVN repository checkout
```

### Directory Structure Expected

```
project-root/
├── builds/                 # Built plugin files
│   ├── my-plugin.php
│   ├── assets/
│   └── ...
├── svn/                   # SVN repository checkout
│   ├── trunk/
│   ├── tags/
│   └── assets/
└── release.sh            # This script
```

## Workflow Integration

### Complete Release Process

1. **Build your plugin:**
   ```bash
   # Build your plugin files (varies by project)
   npm run build
   # or
   composer build
   # or manually prepare files
   ```

2. **Run the release script:**
   ```bash
   ./release.sh 1.2.5
   ```

That's it! The script will automatically handle the rest including the final commit to WordPress.org.

## What the Script Does

1. **Updates SVN** - Pulls latest changes from WordPress.org repository
2. **Copies Files** - Transfers built plugin files from source directory to SVN trunk
3. **Adds Files** - Stages new/modified files for SVN commit
4. **Creates Tag** - Creates a version tag from the current trunk
5. **Commits** - Automatically commits and pushes changes to WordPress.org

## Safety Features

- **Validation**: Requires version parameter
- **Error Handling**: Exits on any command failure (`set -e`)
- **Automated Process**: Handles the entire release workflow in one command

## Customization

### Modify Default Directories

Edit these variables in the script:

```bash
DEFAULT_SOURCE_DIR="./your-build-dir"
DEFAULT_SVN_DIR="./your-svn-dir"
```

### Custom Commit Messages

The script uses a standard commit message format: `"Releases version $VERSION"`

To customize, edit this line in the script:
```bash
svn ci -m "Releases version $VERSION"
```

## Troubleshooting

### Common Issues

1. **SVN not found**: Install SVN command line tools
2. **Permission denied**: Make script executable with `chmod +x release.sh`
3. **Directory not found**: Ensure source and SVN directories exist
4. **SVN conflicts**: Resolve conflicts before running the script
5. **Authentication failed**: Ensure you have commit access to the WordPress.org SVN repository

### Verification Steps

Before running the script:
- [ ] Built files exist in source directory
- [ ] SVN directory is properly checked out from WordPress.org
- [ ] Version number follows semantic versioning
- [ ] No uncommitted changes in SVN working directory
- [ ] You have tested the plugin thoroughly

### Pre-Release Checklist

1. **Test thoroughly** - Ensure your plugin works correctly
2. **Update version numbers** - Update plugin headers, readme.txt, etc.
3. **Build assets** - Run your build process to generate production files
4. **Backup** - Consider backing up your current state
5. **Run the script** - Execute the release script

## Setting Up SVN Repository

If you haven't set up your local SVN checkout yet:

```bash
# Checkout your plugin's SVN repository
svn checkout https://plugins.svn.wordpress.org/your-plugin-name svn
cd svn
```

Replace `your-plugin-name` with your actual WordPress.org plugin slug.

## Best Practices

- **Always test** your plugin before releasing
- **Use semantic versioning** (e.g., 1.2.3)
- **Keep builds clean** - Only include necessary files in your build directory
- **Version control** - Tag your releases in your main git repository as well
- **Communication** - Update your plugin's changelog and readme.txt

## License

This script is released under MIT License. Feel free to modify and distribute.

---

**⚠️ Important**: This script automatically commits to WordPress.org. Make sure you're ready to release before running it. There's no undo once the commit is pushed!
