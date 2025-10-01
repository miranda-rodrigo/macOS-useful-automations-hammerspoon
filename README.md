# Explorer Tools for VS Code

**Explorer Tools** is a powerful VS Code extension that enhances the File Explorer context menu with essential file and folder operations.

![Explorer Tools Demo](./media/demo.gif)

## Features

This extension adds three powerful commands to your Explorer context menu:

### 🗂️ Open in File Manager

Opens the selected file or folder in your system's default file manager:
- **macOS**: Opens in Finder
- **Windows**: Opens in Explorer (files are selected/highlighted)
- **Linux**: Opens in your default File Manager (via `xdg-open`)

### 💻 Open Dedicated Terminal Here

Creates a new terminal with its working directory set to the selected location:
- Creates a **new terminal** (doesn't reuse existing ones)
- Terminal is named `Dedicated: <folder-name>` for easy identification
- For files: opens terminal in the parent directory
- For folders: opens terminal in the folder itself

### 🪟 Open New VS Code Window Here

Opens a new VS Code window focused on the selected directory:
- Always opens in a **new window** (not a tab)
- For files: opens the parent directory
- For folders: opens the folder itself
- Works seamlessly with multi-root workspaces

## How It Works

```
┌─────────────────────────────────────────┐
│  Right-click file/folder in Explorer    │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Context Menu appears with 3 options:   │
│  • Open in File Manager                 │
│  • Open Dedicated Terminal Here         │
│  • Open New VS Code Window Here         │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│  Click an option → Action executes      │
└─────────────────────────────────────────┘
```

## Installation

### From VSIX (Manual)

1. Download the `.vsix` file from releases
2. Open VS Code
3. Go to Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
4. Click `...` (More Actions) → `Install from VSIX...`
5. Select the downloaded file

### From Marketplace (When Published)

1. Open VS Code
2. Go to Extensions view (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for "Explorer Tools"
4. Click **Install**

## Usage

1. Open the **Explorer** view in VS Code (left sidebar)
2. **Right-click** on any file or folder
3. Select one of the new commands:
   - **Open in File Manager**
   - **Open Dedicated Terminal Here**
   - **Open New VS Code Window Here**

### Example Scenarios

**Scenario 1**: You're working on `src/components/Button.tsx` and want to see it in Finder/Explorer
- Right-click on `Button.tsx`
- Select **Open in File Manager**
- The file manager opens with `Button.tsx` selected

**Scenario 2**: You need a terminal in the `tests` folder
- Right-click on the `tests` folder
- Select **Open Dedicated Terminal Here**
- A new terminal named `Dedicated: tests` opens with `cwd` set to `/path/to/project/tests`

**Scenario 3**: You want to open a separate VS Code window for the `backend` folder
- Right-click on the `backend` folder
- Select **Open New VS Code Window Here**
- A new VS Code window opens with `backend` as the workspace root

## Platform Support

| Platform | File Manager Command | Terminal | New Window |
|----------|---------------------|----------|------------|
| macOS    | ✅ `open` (Finder)   | ✅       | ✅         |
| Windows  | ✅ `explorer`        | ✅       | ✅         |
| Linux    | ✅ `xdg-open`        | ✅       | ✅         |

## Edge Cases & Special Handling

✅ **Paths with spaces**: Properly escaped and quoted  
✅ **Symbolic links**: Resolved correctly  
✅ **Multi-root workspaces**: Full support  
✅ **Files vs Folders**: Intelligently handled (files use parent directory for terminal/window)  
✅ **URI handling**: Uses VS Code's `vscode.Uri` for proper path resolution

## Requirements

- **VS Code**: Version 1.90.0 or higher
- **Linux users**: Requires `xdg-utils` package for file manager functionality
  ```bash
  # Ubuntu/Debian
  sudo apt-get install xdg-utils
  
  # Fedora
  sudo dnf install xdg-utils
  
  # Arch
  sudo pacman -S xdg-utils
  ```

## Development

### Prerequisites

- Node.js 16.x or higher
- npm 8.x or higher

### Setup

```bash
# Clone the repository
git clone https://github.com/your-username/explorer-tools.git
cd explorer-tools

# Install dependencies
npm install

# Compile TypeScript
npm run compile
```

### Running & Debugging

1. Open the project in VS Code
2. Press `F5` to launch the Extension Development Host
3. In the new VS Code window, test the extension features
4. Use `npm run watch` to auto-compile on changes

### Building

```bash
# Compile TypeScript
npm run compile

# Run linter
npm run lint

# Run tests
npm test

# Package extension
npm run package
# This creates explorer-tools-0.0.1.vsix
```

### Project Structure

```
explorer-tools/
├── .vscode/              # VS Code workspace configuration
│   ├── launch.json       # Debugger configuration
│   ├── tasks.json        # Build tasks
│   └── extensions.json   # Recommended extensions
├── media/                # Images and GIFs
│   ├── demo.gif          # Demo animation
│   └── icon.png          # Extension icon
├── src/                  # Source code
│   ├── extension.ts      # Main extension file
│   └── test/             # Test files
│       ├── runTest.ts    # Test runner
│       └── suite/        # Test suites
│           └── extension.test.ts
├── out/                  # Compiled JavaScript (generated)
├── .eslintrc.json        # ESLint configuration
├── .gitignore            # Git ignore rules
├── CHANGELOG.md          # Version history
├── LICENSE               # MIT License
├── package.json          # Extension manifest
├── README.md             # This file
└── tsconfig.json         # TypeScript configuration
```

## Testing

Run the test suite:

```bash
npm test
```

The test suite validates:
- ✅ Extension activation
- ✅ Command registration
- ✅ Command execution without errors
- ✅ Platform detection

## Troubleshooting

### Linux: "xdg-open not found"

**Problem**: File manager command fails on Linux

**Solution**: Install `xdg-utils`
```bash
sudo apt-get install xdg-utils  # Debian/Ubuntu
sudo dnf install xdg-utils      # Fedora
sudo pacman -S xdg-utils        # Arch
```

### Terminal doesn't open with correct directory

**Problem**: Terminal opens in wrong location

**Solution**: 
- Ensure the file/folder exists and is accessible
- Check VS Code's integrated terminal settings
- Try reloading VS Code (`Developer: Reload Window`)

### New window doesn't open

**Problem**: "Open New VS Code Window Here" doesn't work

**Solution**:
- Ensure the directory exists and is readable
- Check if you have permission to read the directory
- Try with a different folder to isolate the issue

### Commands don't appear in context menu

**Problem**: Right-click menu doesn't show new options

**Solution**:
- Reload VS Code window (`Developer: Reload Window`)
- Ensure extension is enabled in Extensions view
- Check for conflicting extensions

## Checklist ✅

Before using or publishing this extension, verify:

- [x] Menus appear for both files and folders
- [x] macOS opens in Finder correctly
- [x] Windows opens in Explorer correctly
- [x] Linux opens via `xdg-open` correctly
- [x] Terminal opens with correct `cwd`
- [x] Terminal is properly named (`Dedicated: <name>`)
- [x] New VS Code window opens in correct directory
- [x] Paths with spaces are handled correctly
- [x] Works with multi-root workspaces
- [x] Build completes without errors (`npm run compile`)
- [x] Linting passes (`npm run lint`)
- [x] Tests pass (`npm test`)
- [x] Package builds successfully (`npm run package`)

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Coding Standards

- Use TypeScript
- Follow existing code style
- Add JSDoc comments for functions
- Include tests for new features
- Update README for user-facing changes

## License

This extension is licensed under the [MIT License](LICENSE).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Support

If you encounter issues or have suggestions:

1. Check the [Troubleshooting](#troubleshooting) section
2. Search existing [GitHub Issues](https://github.com/your-username/explorer-tools/issues)
3. Create a new issue with:
   - Your OS and version
   - VS Code version
   - Steps to reproduce
   - Expected vs actual behavior

## Credits

Created with ❤️ for the VS Code community.

---

**Enjoy enhanced Explorer functionality!** 🚀
