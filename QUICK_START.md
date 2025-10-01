# Quick Start Guide

Get up and running with Explorer Tools development in 5 minutes!

## 📦 Installation

```bash
# Clone or navigate to the repository
cd explorer-tools

# Install dependencies
npm install
```

## 🚀 Run & Test

```bash
# Option 1: Watch mode (recommended for development)
npm run watch

# Then press F5 in VS Code to launch Extension Development Host

# Option 2: Single compile
npm run compile
```

## 🧪 Testing

```bash
# Run all tests
npm test

# Run linter
npm run lint

# Fix linting issues
npm run lint -- --fix
```

## 📦 Package

```bash
# Create VSIX file
npm run package

# Installs as: explorer-tools-0.0.1.vsix
```

## 🎯 Try It Out

1. Press `F5` in VS Code
2. In the new window, open any folder
3. In Explorer (sidebar), right-click any file/folder
4. See the new menu options:
   - **Open in File Manager**
   - **Open Dedicated Terminal Here**
   - **Open New VS Code Window Here**

## 📁 Project Structure

```
explorer-tools/
├── src/
│   ├── extension.ts              # Main extension code
│   └── test/                     # Test suite
│       ├── runTest.ts
│       └── suite/
│           ├── index.ts
│           └── extension.test.ts
├── .vscode/                      # VS Code config
│   ├── launch.json              # Debug config
│   ├── tasks.json               # Build tasks
│   └── extensions.json          # Recommended extensions
├── media/                        # Images
│   ├── demo.gif                 # Demo animation (placeholder)
│   └── icon.png                 # Extension icon (placeholder)
├── out/                          # Compiled JS (generated)
├── package.json                  # Extension manifest
├── tsconfig.json                # TypeScript config
├── .eslintrc.json               # ESLint rules
├── .gitignore                   # Git ignore
├── .vscodeignore                # VSIX package ignore
├── README.md                     # Main documentation
├── CHANGELOG.md                  # Version history
├── DEVELOPMENT.md                # Development guide
├── LICENSE                       # MIT License
└── QUICK_START.md               # This file
```

## 🔧 Common Commands

| Command | Description |
|---------|-------------|
| `npm install` | Install dependencies |
| `npm run compile` | Compile TypeScript |
| `npm run watch` | Auto-compile on changes |
| `npm run lint` | Check code quality |
| `npm test` | Run test suite |
| `npm run package` | Create VSIX package |
| `F5` in VS Code | Launch extension debugger |

## 🐛 Debug Mode

1. Open `src/extension.ts`
2. Set breakpoint (click left of line number)
3. Press `F5`
4. Execute command in Extension Development Host
5. Debugger pauses at breakpoint
6. Inspect variables, step through code

## ✅ Checklist Before Publishing

- [ ] Update version in `package.json`
- [ ] Update `CHANGELOG.md`
- [ ] Update publisher name in `package.json`
- [ ] Replace placeholder images in `media/`
- [ ] Run `npm test` - all tests pass
- [ ] Run `npm run lint` - no errors
- [ ] Run `npm run package` - builds successfully
- [ ] Test VSIX on clean VS Code install
- [ ] Test on all platforms (macOS, Windows, Linux)

## 🌟 Key Features to Test

### ✅ Open in File Manager
- macOS: Opens in Finder
- Windows: Opens in Explorer, file selected
- Linux: Opens in default file manager

### ✅ Open Dedicated Terminal Here
- New terminal created (name: `Dedicated: <folder>`)
- Correct working directory
- Works for files (uses parent dir)

### ✅ Open New VS Code Window Here
- New window opens (not tab)
- Correct directory loaded
- Works for files (uses parent dir)

## 📚 Next Steps

- Read [README.md](README.md) for full documentation
- Read [DEVELOPMENT.md](DEVELOPMENT.md) for architecture details
- Check [CHANGELOG.md](CHANGELOG.md) for version history

## 💡 Pro Tips

1. **Keep `npm run watch` running** while developing
2. **Use Debug Console** to see `console.log` output
3. **Reload Extension Host** with `Ctrl+R` / `Cmd+R` after changes
4. **Test with edge cases**: spaces in paths, symlinks, etc.
5. **Check console** for `[Explorer Tools]` log messages

## 🆘 Troubleshooting

### Extension doesn't appear in Extension Development Host

- Check terminal for compile errors
- Run `npm run compile` manually
- Reload VS Code window

### Commands don't appear in context menu

- Verify `package.json` contribution points
- Reload Extension Development Host (`Ctrl+R` / `Cmd+R`)
- Check for other extensions with conflicting commands

### Tests fail

- Ensure extension compiled: `npm run compile`
- Check publisher name matches in `package.json` and `extension.test.ts`
- Run with `npm test` (not through VS Code test runner initially)

### TypeScript errors

- Run `npm install` to ensure all types are installed
- Check `tsconfig.json` is correct
- Restart TypeScript server in VS Code

---

**Ready to build? Run `npm install && npm run watch` then press `F5`!** 🎉
