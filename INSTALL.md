# Installation & Setup Guide

Complete guide to set up and use the Explorer Tools extension.

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ **Node.js** 16.x or higher ([Download](https://nodejs.org/))
- ✅ **npm** 8.x or higher (comes with Node.js)
- ✅ **VS Code** 1.90.0 or higher ([Download](https://code.visualstudio.com/))
- ✅ **Git** (optional, for cloning)

### Linux Users Only

If you're on Linux, install `xdg-utils` for file manager functionality:

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install xdg-utils

# Fedora
sudo dnf install xdg-utils

# Arch Linux
sudo pacman -S xdg-utils

# Verify installation
which xdg-open
# Should output: /usr/bin/xdg-open
```

## 🚀 Option 1: Install from VSIX (Pre-built Package)

If you have a `.vsix` file:

### Step 1: Download VSIX

Download `explorer-tools-0.0.1.vsix` from the releases or build it yourself (see Option 2).

### Step 2: Install in VS Code

**Method A: Via Command Line**
```bash
code --install-extension explorer-tools-0.0.1.vsix
```

**Method B: Via VS Code UI**
1. Open VS Code
2. Press `Ctrl+Shift+X` (Windows/Linux) or `Cmd+Shift+X` (macOS)
3. Click the `...` menu (top-right of Extensions panel)
4. Select **"Install from VSIX..."**
5. Navigate to and select the `.vsix` file
6. Click **Install**

### Step 3: Verify Installation

1. Open Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Search for "Explorer Tools"
3. You should see it listed as installed
4. Test it:
   - Open any folder in VS Code
   - Right-click a file/folder in Explorer
   - See the 3 new commands!

## 🛠️ Option 2: Build from Source (Development)

If you want to develop or customize the extension:

### Step 1: Clone/Download Repository

```bash
# If using Git
git clone https://github.com/your-username/explorer-tools.git
cd explorer-tools

# OR: Download and extract ZIP, then cd into directory
```

### Step 2: Install Dependencies

```bash
npm install
```

This installs:
- TypeScript compiler
- ESLint and TypeScript ESLint plugins
- VS Code extension testing tools
- Mocha test framework
- VSCE (VS Code Extension Manager)

**Note**: This may take 1-2 minutes depending on your connection.

### Step 3: Compile TypeScript

```bash
npm run compile
```

This compiles `src/**/*.ts` → `out/**/*.js`.

**Expected output:**
```
> explorer-tools@0.0.1 compile
> tsc -p ./

# No output means success!
```

### Step 4: Run in Development Mode

**Option A: Using VS Code Debugger (Recommended)**

1. Open the project in VS Code:
   ```bash
   code .
   ```

2. Press `F5` (or click Run → Start Debugging)

3. A new **"Extension Development Host"** window opens

4. In the new window:
   - Open any folder (`File → Open Folder`)
   - Navigate to Explorer (sidebar)
   - Right-click any file or folder
   - See the 3 new commands!

5. To see logs:
   - In the main VS Code window (not Extension Development Host)
   - Open Debug Console (View → Debug Console)
   - Look for `[Explorer Tools]` messages

**Option B: Using Watch Mode**

In a terminal:
```bash
npm run watch
```

This auto-compiles when you save files. Keep it running while developing.

Then press `F5` in VS Code to launch Extension Development Host.

### Step 5: Run Tests

```bash
npm test
```

**Expected output:**
```
[Test Runner] Starting tests...
[Test Runner] Extension path: /path/to/explorer-tools
[Test Runner] Tests path: /path/to/explorer-tools/out/test/suite

Explorer Tools Extension Test Suite
  ✓ Extension should be present
  ✓ Extension should activate
  ✓ Command explorerTools.openInFileManager should be registered
  ✓ Command explorerTools.openDedicatedTerminal should be registered
  ✓ Command explorerTools.openNewWindowHere should be registered
  ✓ All three commands should be registered
  ✓ Platform detection should work
  ✓ Commands should execute without errors (with undefined resource)

8 passing (2s)

[Test Runner] All tests passed!
```

### Step 6: Build VSIX Package

```bash
npm run package
```

This creates `explorer-tools-0.0.1.vsix` in the current directory.

**Expected output:**
```
Executing prepublish script 'npm run compile'...
> explorer-tools@0.0.1 compile
> tsc -p ./

DONE  Packaged: /path/to/explorer-tools/explorer-tools-0.0.1.vsix (X files, XXX KB)
```

### Step 7: Install Your Build

```bash
code --install-extension explorer-tools-0.0.1.vsix
```

## 🧪 Testing the Extension

### Quick Test

1. Open VS Code
2. Open any folder (File → Open Folder)
3. In the Explorer (left sidebar), right-click on:
   - A file
   - A folder
4. You should see 3 new options at the top of the context menu:
   - **Open in File Manager**
   - **Open Dedicated Terminal Here**
   - **Open New VS Code Window Here**

### Test: Open in File Manager

1. Right-click a file or folder
2. Click **"Open in File Manager"**
3. Your system file manager should open:
   - **macOS**: Finder opens showing the location
   - **Windows**: Explorer opens with the file/folder selected
   - **Linux**: Your default file manager opens

### Test: Open Dedicated Terminal Here

1. Right-click a folder named `my-project`
2. Click **"Open Dedicated Terminal Here"**
3. A new terminal should appear at the bottom
4. Terminal name: `Dedicated: my-project`
5. Working directory: `/path/to/my-project`
6. Test: Type `pwd` (Unix) or `cd` (Windows) to verify location

### Test: Open New VS Code Window Here

1. Right-click a folder
2. Click **"Open New VS Code Window Here"**
3. A **new VS Code window** should open (not a tab)
4. The new window should be focused on that folder
5. Verify in the window title and Explorer

### Test: Edge Cases

**Test with file (not folder):**
- Right-click a file `test.txt` in `/home/user/projects/`
- Click "Open Dedicated Terminal Here"
- Terminal should open in `/home/user/projects/` (parent directory)

**Test with spaces in path:**
- Create a folder named `My Test Folder`
- Right-click it
- Try all 3 commands
- All should work correctly (paths are properly escaped)

**Test with symbolic link:**
- Create a symlink to a folder
- Right-click the symlink
- Commands should work with the resolved path

## 🔧 Troubleshooting

### Problem: Extension doesn't appear in Extensions list

**Solution:**
```bash
# Check if installed
code --list-extensions | grep explorer-tools

# If not found, reinstall
code --install-extension explorer-tools-0.0.1.vsix --force
```

### Problem: Commands don't appear in context menu

**Solution:**
1. Reload VS Code window:
   - Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
   - Type "Reload Window"
   - Press Enter

2. Check if extension is enabled:
   - Open Extensions view
   - Search "Explorer Tools"
   - Ensure it's not disabled

3. Check for conflicting extensions:
   - Disable other extensions temporarily
   - Reload VS Code

### Problem: "xdg-open not found" on Linux

**Solution:**
```bash
sudo apt-get install xdg-utils  # Ubuntu/Debian
sudo dnf install xdg-utils      # Fedora
sudo pacman -S xdg-utils        # Arch
```

### Problem: npm install fails

**Solution:**
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and package-lock.json
rm -rf node_modules package-lock.json

# Reinstall
npm install
```

### Problem: TypeScript compile errors

**Solution:**
```bash
# Ensure correct Node.js version
node --version  # Should be 16.x or higher

# Reinstall TypeScript
npm install --save-dev typescript

# Compile with verbose output
npx tsc -p ./ --listFiles
```

### Problem: Tests fail

**Solution:**
1. Ensure compiled:
   ```bash
   npm run compile
   ```

2. Check publisher name:
   - In `package.json`: `"publisher": "your-publisher-name"`
   - In `src/test/suite/extension.test.ts`: Same publisher name

3. Run tests with verbose output:
   ```bash
   npm test 2>&1 | tee test-output.log
   ```

### Problem: Extension doesn't work in Extension Development Host

**Solution:**
1. Close Extension Development Host window
2. In main VS Code window:
   ```bash
   npm run compile
   ```
3. Check for compile errors in terminal
4. Press `F5` again

### Problem: VSCE package command fails

**Solution:**
```bash
# Install vsce globally
npm install -g @vscode/vsce

# Or run with npx
npx vsce package

# Check for missing files
npx vsce ls
```

## 📦 Uninstalling

### Via Command Line
```bash
code --uninstall-extension your-publisher-name.explorer-tools
```

### Via VS Code UI
1. Open Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
2. Search "Explorer Tools"
3. Click the gear icon
4. Select **"Uninstall"**
5. Reload VS Code

## 🔄 Updating

### From VSIX
1. Uninstall old version (see above)
2. Install new version:
   ```bash
   code --install-extension explorer-tools-0.0.2.vsix
   ```

### From Source
```bash
cd explorer-tools
git pull origin main  # If using Git
npm install           # Update dependencies
npm run compile       # Recompile
npm run package       # Rebuild VSIX
code --install-extension explorer-tools-0.0.2.vsix --force
```

## 🎯 Next Steps

After installation:

1. **Read the documentation**:
   - [README.md](README.md) - Full feature documentation
   - [QUICK_START.md](QUICK_START.md) - Quick reference

2. **Customize (optional)**:
   - Keyboard shortcuts: File → Preferences → Keyboard Shortcuts
   - Search for "explorerTools" to add keybindings

3. **Report issues**:
   - GitHub Issues: https://github.com/your-username/explorer-tools/issues

4. **Contribute**:
   - Read [DEVELOPMENT.md](DEVELOPMENT.md)
   - Fork, modify, submit PR

## ✅ Verification Checklist

After installation, verify everything works:

- [ ] Extension appears in Extensions list
- [ ] Right-click on file shows 3 new commands
- [ ] Right-click on folder shows 3 new commands
- [ ] "Open in File Manager" works
- [ ] "Open Dedicated Terminal Here" works (correct name & cwd)
- [ ] "Open New VS Code Window Here" works
- [ ] Works with paths containing spaces
- [ ] Works with symbolic links
- [ ] No error messages in Developer Console

## 🆘 Getting Help

If you encounter issues:

1. Check this document's Troubleshooting section
2. Check [README.md](README.md) Troubleshooting section
3. Search GitHub Issues
4. Create new issue with:
   - Your OS and version
   - VS Code version (`Help → About`)
   - Steps to reproduce
   - Error messages (from Developer Console: `Help → Toggle Developer Tools`)

## 📊 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| Node.js | 16.x | 20.x |
| npm | 8.x | 10.x |
| VS Code | 1.90.0 | Latest |
| RAM | 4 GB | 8 GB+ |
| Disk Space | 50 MB | 100 MB |

## 🌍 Platform-Specific Notes

### macOS
- Works on macOS 10.14 (Mojave) and later
- Uses native `open` command
- No additional software required

### Windows
- Works on Windows 10 and later
- Uses native `explorer` command
- No additional software required
- Paths with backslashes are handled automatically

### Linux
- Works on any modern Linux distribution
- **Requires `xdg-utils` package**
- Tested on: Ubuntu, Fedora, Arch, Debian
- File manager: Uses system default (Nautilus, Dolphin, Thunar, etc.)

---

**Installation complete! Enjoy your enhanced Explorer!** 🎉
