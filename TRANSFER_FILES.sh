#!/bin/bash

# Script to transfer Explorer Tools extension files to the target directory
# Usage: bash TRANSFER_FILES.sh

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Explorer Tools - File Transfer Script${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Source directory (current workspace)
SOURCE_DIR="/workspace"

# Target directory
TARGET_DIR="/Users/rodrigomiranda/useful-repos/cursor-vscode-utils"

# Create target directory if it doesn't exist
echo -e "${YELLOW}Creating target directory...${NC}"
mkdir -p "$TARGET_DIR"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Could not create target directory!${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Target directory ready: $TARGET_DIR${NC}\n"

# List of files to transfer (extension-related only)
FILES_TO_COPY=(
    # Root configuration files
    "package.json"
    "tsconfig.json"
    ".eslintrc.json"
    ".gitignore"
    ".vscodeignore"
    ".editorconfig"
    ".npmrc"
    
    # Documentation files
    "README.md"
    "QUICK_START.md"
    "DEVELOPMENT.md"
    "INSTALL.md"
    "CHANGELOG.md"
    "LICENSE"
    "REPOSITORY_SUMMARY.md"
    "FILE_INDEX.md"
    "PROJECT_STRUCTURE.txt"
    "EXECUTIVE_SUMMARY.md"
    "INDEX.md"
    "LEIA-ME.md"
)

# Directories to copy
DIRS_TO_COPY=(
    "src"
    ".vscode"
    "media"
)

echo -e "${YELLOW}Copying files...${NC}"

# Copy individual files
for file in "${FILES_TO_COPY[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        cp "$SOURCE_DIR/$file" "$TARGET_DIR/$file"
        echo -e "${GREEN}✓${NC} Copied: $file"
    else
        echo -e "${YELLOW}⚠${NC}  Skipped: $file (not found)"
    fi
done

echo ""

# Copy directories
for dir in "${DIRS_TO_COPY[@]}"; do
    if [ -d "$SOURCE_DIR/$dir" ]; then
        cp -r "$SOURCE_DIR/$dir" "$TARGET_DIR/$dir"
        echo -e "${GREEN}✓${NC} Copied directory: $dir/"
    else
        echo -e "${YELLOW}⚠${NC}  Skipped: $dir/ (not found)"
    fi
done

echo -e "\n${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Transfer complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "Files copied to: ${BLUE}$TARGET_DIR${NC}\n"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. cd $TARGET_DIR"
echo -e "  2. npm install"
echo -e "  3. npm run compile"
echo -e "  4. Press F5 in VS Code to test\n"

# Show directory contents
echo -e "${YELLOW}Directory contents:${NC}"
ls -la "$TARGET_DIR"

echo -e "\n${GREEN}Done!${NC}"
