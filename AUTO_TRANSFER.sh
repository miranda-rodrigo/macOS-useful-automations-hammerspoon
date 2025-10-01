#!/bin/bash

###############################################################################
# AUTOMATIC FILE TRANSFER SCRIPT
# 
# This script AUTOMATICALLY copies all Explorer Tools extension files
# to the target directory. No matter what happens, files will be copied.
#
# Usage: 
#   1. Download this script to your Mac
#   2. Open Terminal
#   3. Run: bash AUTO_TRANSFER.sh
#
# The script will handle everything automatically!
###############################################################################

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║     EXPLORER TOOLS - AUTOMATIC FILE TRANSFER SCRIPT            ║"
echo "║                                                                ║"
echo "║     This script will AUTOMATICALLY copy all files             ║"
echo "║     No user interaction needed!                               ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# Configuration
SOURCE_DIR="/workspace"
TARGET_DIR="/Users/rodrigomiranda/useful-repos/cursor-vscode-utils"

# Check if we're running in the right context
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${YELLOW}⚠️  Source directory $SOURCE_DIR not found.${NC}"
    echo -e "${YELLOW}   This script should be run where /workspace is accessible.${NC}"
    echo -e "${YELLOW}   Attempting to use current directory as source...${NC}\n"
    SOURCE_DIR="$(pwd)"
fi

echo -e "${BLUE}📂 Source:${NC} $SOURCE_DIR"
echo -e "${BLUE}📂 Target:${NC} $TARGET_DIR\n"

# Step 1: Create target directory
echo -e "${YELLOW}[1/5]${NC} Creating target directory..."
mkdir -p "$TARGET_DIR" 2>/dev/null || {
    echo -e "${RED}❌ Failed to create directory. Trying with sudo...${NC}"
    sudo mkdir -p "$TARGET_DIR"
}
echo -e "${GREEN}✅ Target directory ready${NC}\n"

# Step 2: Copy directories
echo -e "${YELLOW}[2/5]${NC} Copying directories..."

DIRS=("src" ".vscode" "media")
for dir in "${DIRS[@]}"; do
    if [ -d "$SOURCE_DIR/$dir" ]; then
        echo -e "  ${CYAN}→${NC} Copying $dir/..."
        cp -r "$SOURCE_DIR/$dir" "$TARGET_DIR/" 2>/dev/null || sudo cp -r "$SOURCE_DIR/$dir" "$TARGET_DIR/"
        echo -e "  ${GREEN}✓${NC} $dir/ copied"
    else
        echo -e "  ${YELLOW}⚠${NC}  $dir/ not found (skipping)"
    fi
done
echo -e "${GREEN}✅ Directories copied${NC}\n"

# Step 3: Copy configuration files
echo -e "${YELLOW}[3/5]${NC} Copying configuration files..."

CONFIG_FILES=(
    "package.json"
    "tsconfig.json"
    ".eslintrc.json"
    ".gitignore"
    ".vscodeignore"
    ".editorconfig"
    ".npmrc"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        cp "$SOURCE_DIR/$file" "$TARGET_DIR/" 2>/dev/null || sudo cp "$SOURCE_DIR/$file" "$TARGET_DIR/"
        echo -e "  ${GREEN}✓${NC} $file"
    fi
done
echo -e "${GREEN}✅ Configuration files copied${NC}\n"

# Step 4: Copy documentation files
echo -e "${YELLOW}[4/5]${NC} Copying documentation files..."

DOC_FILES=(
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
    "COMO_TRANSFERIR.md"
    "INSTRUÇÕES_TRANSFERÊNCIA.md"
    "COPIAR_ARQUIVOS.txt"
    "TRANSFER_FILES.sh"
)

for file in "${DOC_FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        cp "$SOURCE_DIR/$file" "$TARGET_DIR/" 2>/dev/null || sudo cp "$SOURCE_DIR/$file" "$TARGET_DIR/"
        echo -e "  ${GREEN}✓${NC} $file"
    fi
done
echo -e "${GREEN}✅ Documentation files copied${NC}\n"

# Step 5: Verify and show results
echo -e "${YELLOW}[5/5]${NC} Verifying installation..."

cd "$TARGET_DIR" || exit 1

echo -e "\n${CYAN}📁 Files in target directory:${NC}"
ls -lah "$TARGET_DIR" | head -20

echo -e "\n${CYAN}📊 Statistics:${NC}"
FILE_COUNT=$(find "$TARGET_DIR" -type f | wc -l | tr -d ' ')
DIR_COUNT=$(find "$TARGET_DIR" -type d | wc -l | tr -d ' ')
echo -e "  Files: ${GREEN}$FILE_COUNT${NC}"
echo -e "  Directories: ${GREEN}$DIR_COUNT${NC}"

# Check essential files
echo -e "\n${CYAN}🔍 Essential files check:${NC}"
ESSENTIAL=("package.json" "src/extension.ts" "tsconfig.json" "README.md")
ALL_GOOD=true
for file in "${ESSENTIAL[@]}"; do
    if [ -f "$TARGET_DIR/$file" ] || [ -d "$TARGET_DIR/$(dirname "$file")" ]; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file ${RED}(MISSING!)${NC}"
        ALL_GOOD=false
    fi
done

# Final message
echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
if [ "$ALL_GOOD" = true ]; then
    echo -e "${CYAN}║${NC}  ${GREEN}✅ SUCCESS! All files copied successfully!${NC}                  ${CYAN}║${NC}"
else
    echo -e "${CYAN}║${NC}  ${YELLOW}⚠️  WARNING! Some files may be missing.${NC}                    ${CYAN}║${NC}"
fi
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}\n"

# Next steps
echo -e "${BLUE}📝 NEXT STEPS:${NC}\n"
echo -e "  ${CYAN}1.${NC} cd $TARGET_DIR"
echo -e "  ${CYAN}2.${NC} npm install"
echo -e "  ${CYAN}3.${NC} npm run compile"
echo -e "  ${CYAN}4.${NC} code ."
echo -e "  ${CYAN}5.${NC} Press F5 to test the extension!\n"

# Optional: Run npm install automatically
echo -e "${YELLOW}Would you like to run 'npm install' now? (y/n)${NC}"
read -t 10 -n 1 -r REPLY || REPLY="y"
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}Installing dependencies...${NC}"
    npm install
    echo -e "${GREEN}✅ Dependencies installed!${NC}\n"
    
    echo -e "${YELLOW}Compile TypeScript now? (y/n)${NC}"
    read -t 10 -n 1 -r REPLY2 || REPLY2="y"
    echo
    if [[ $REPLY2 =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Compiling TypeScript...${NC}"
        npm run compile
        echo -e "${GREEN}✅ Compilation complete!${NC}\n"
        
        echo -e "${BLUE}Opening in VS Code...${NC}"
        code .
        echo -e "${GREEN}✅ VS Code opened! Press F5 to test!${NC}\n"
    fi
fi

echo -e "${GREEN}🎉 Transfer complete! Your extension is ready!${NC}\n"

exit 0
