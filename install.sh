#!/bin/bash

#############################################
# Hammerspoon Custom Shortcuts - Installer
# Versão: 1.1.0
#############################################

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Emojis
ROCKET="🚀"
CHECK="✅"
WARN="⚠️"
INFO="ℹ️"
HAMMER="🔨"

echo ""
echo "${BLUE}${HAMMER}  Hammerspoon Custom Shortcuts - Installer${NC}"
echo "==========================================="
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "${RED}${WARN} Error: This installer only works on macOS${NC}"
    exit 1
fi

# Check if Hammerspoon is installed
echo "${INFO} Checking for Hammerspoon..."
if [ ! -d "/Applications/Hammerspoon.app" ]; then
    echo "${YELLOW}${WARN} Hammerspoon not found!${NC}"
    echo ""
    echo "Please install Hammerspoon first:"
    echo "  Option 1: brew install --cask hammerspoon"
    echo "  Option 2: https://www.hammerspoon.org/"
    echo ""
    exit 1
fi

echo "${GREEN}${CHECK} Hammerspoon found!${NC}"

# Create ~/.hammerspoon directory if doesn't exist
HAMMERSPOON_DIR="$HOME/.hammerspoon"
if [ ! -d "$HAMMERSPOON_DIR" ]; then
    echo "${INFO} Creating $HAMMERSPOON_DIR..."
    mkdir -p "$HAMMERSPOON_DIR"
fi

# Create Spoons directory
SPOONS_DIR="$HAMMERSPOON_DIR/Spoons"
if [ ! -d "$SPOONS_DIR" ]; then
    echo "${INFO} Creating $SPOONS_DIR..."
    mkdir -p "$SPOONS_DIR"
fi

# Determine if running from git repo or need to clone
if [ -d "./Spoons" ] && [ -f "./init.lua" ]; then
    echo "${INFO} Installing from local repository..."
    REPO_DIR="."
else
    echo "${INFO} Cloning repository..."
    TEMP_DIR=$(mktemp -d)
    git clone https://github.com/miranda-rodrigo/macOS-useful-automations-hammerspoon.git "$TEMP_DIR"
    REPO_DIR="$TEMP_DIR"
fi

# Backup existing Spoons if they exist
for spoon in "CustomShortcuts.spoon" "URLShortener.spoon"; do
    if [ -d "$SPOONS_DIR/$spoon" ]; then
        BACKUP_PATH="$SPOONS_DIR/${spoon}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "${WARN} Backing up existing $spoon to $BACKUP_PATH"
        mv "$SPOONS_DIR/$spoon" "$BACKUP_PATH"
    fi
done

# Install Spoons
echo "${INFO} Installing CustomShortcuts.spoon..."
cp -r "$REPO_DIR/Spoons/CustomShortcuts.spoon" "$SPOONS_DIR/"

echo "${INFO} Installing URLShortener.spoon..."
cp -r "$REPO_DIR/Spoons/URLShortener.spoon" "$SPOONS_DIR/"

echo "${GREEN}${CHECK} Spoons installed successfully!${NC}"

# Handle init.lua
INIT_FILE="$HAMMERSPOON_DIR/init.lua"
if [ -f "$INIT_FILE" ]; then
    echo ""
    echo "${YELLOW}${WARN} Existing init.lua found!${NC}"
    echo ""
    echo "Choose an option:"
    echo "  1) Backup and replace with example config (recommended for new users)"
    echo "  2) Show code to add manually (recommended for existing configs)"
    echo "  3) Skip init.lua setup"
    echo ""
    read -p "Enter choice [1-3]: " choice
    
    case $choice in
        1)
            BACKUP_INIT="$HAMMERSPOON_DIR/init.lua.backup.$(date +%Y%m%d_%H%M%S)"
            echo "${INFO} Backing up to $BACKUP_INIT"
            cp "$INIT_FILE" "$BACKUP_INIT"
            cp "$REPO_DIR/init.example.lua" "$INIT_FILE"
            echo "${GREEN}${CHECK} init.lua replaced! Backup saved.${NC}"
            ;;
        2)
            echo ""
            echo "${BLUE}Add these lines to your $INIT_FILE:${NC}"
            echo "---"
            cat << 'EOF'

-- Load CustomShortcuts (7 core shortcuts)
hs.loadSpoon("CustomShortcuts")
spoon.CustomShortcuts:start()

-- Load URLShortener (3 URL shortcuts - optional)
hs.loadSpoon("URLShortener")
spoon.URLShortener:start()

-- Optional: Bit.ly token for premium URL shortening
-- spoon.URLShortener:setBitlyToken("your_token_here")

EOF
            echo "---"
            echo ""
            echo "${INFO} Press Enter when you've added the code..."
            read
            ;;
        3)
            echo "${INFO} Skipping init.lua setup"
            ;;
        *)
            echo "${RED}Invalid choice. Skipping init.lua setup${NC}"
            ;;
    esac
else
    echo "${INFO} Creating new init.lua from example..."
    cp "$REPO_DIR/init.example.lua" "$INIT_FILE"
    echo "${GREEN}${CHECK} init.lua created!${NC}"
fi

# Copy documentation
echo ""
echo "${INFO} Installing documentation..."
for doc in "README.md" "QUICK_START.md" "TROUBLESHOOTING.md" "ARCHITECTURE.md" "CHANGELOG.md" "RESUMO_EXECUTIVO.md"; do
    if [ -f "$REPO_DIR/$doc" ]; then
        cp "$REPO_DIR/$doc" "$HAMMERSPOON_DIR/"
    fi
done
echo "${GREEN}${CHECK} Documentation installed!${NC}"

# Cleanup temp directory if used
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

# Reload Hammerspoon
echo ""
echo "${INFO} Reloading Hammerspoon..."
osascript -e 'tell application "Hammerspoon" to reload' 2>/dev/null || true

# Check permissions
echo ""
echo "${BLUE}${INFO} Checking permissions...${NC}"

# Function to check accessibility permission
check_accessibility() {
    local status=$(osascript -e 'tell application "System Events" to return enabled of accessibility' 2>/dev/null || echo "false")
    if [ "$status" = "false" ]; then
        echo "${YELLOW}${WARN} Accessibility permission needed!${NC}"
        echo ""
        echo "To enable:"
        echo "  1. System Settings → Privacy & Security"
        echo "  2. Accessibility"
        echo "  3. Enable ☑️ Hammerspoon"
        echo ""
        return 1
    else
        echo "${GREEN}${CHECK} Accessibility permission OK${NC}"
        return 0
    fi
}

check_accessibility

echo ""
echo "${GREEN}${ROCKET} Installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. ${BLUE}Open Hammerspoon${NC} (click 🔨 icon in menu bar)"
echo "  2. ${BLUE}Grant permissions${NC} if prompted"
echo "  3. ${BLUE}Test shortcuts:${NC}"
echo "     • ⌘ ⌥ ⌃ A → Activity Monitor"
echo "     • ⌘ J → Mission Control"
echo ""
echo "Documentation installed to:"
echo "  ${BLUE}$HAMMERSPOON_DIR/${NC}"
echo ""
echo "Quick reference:"
echo "  ${BLUE}cat ~/.hammerspoon/QUICK_START.md${NC}"
echo ""
echo "${GREEN}Enjoy your new shortcuts! ${HAMMER}${NC}"
echo ""
