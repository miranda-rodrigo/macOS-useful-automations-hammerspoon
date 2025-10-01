# Development Guide

This document provides detailed instructions for developing the Explorer Tools extension.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      VS Code Extension Host                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │           extension.ts (Main Entry Point)          │    │
│  │                                                     │    │
│  │  activate()                                         │    │
│  │    └─> Register Commands:                          │    │
│  │         ├─> explorerTools.openInFileManager        │    │
│  │         ├─> explorerTools.openDedicatedTerminal    │    │
│  │         └─> explorerTools.openNewWindowHere        │    │
│  └────────────────────────────────────────────────────┘    │
│                        │                                     │
│                        │ User Right-Clicks in Explorer       │
│                        ▼                                     │
│  ┌────────────────────────────────────────────────────┐    │
│  │           Context Menu (contributes.menus)         │    │
│  │                                                     │    │
│  │  • Open in File Manager                            │    │
│  │  • Open Dedicated Terminal Here                    │    │
│  │  • Open New VS Code Window Here                    │    │
│  └────────────────────────────────────────────────────┘    │
│                        │                                     │
│                        │ Command Executed                    │
│                        ▼                                     │
│  ┌────────────────────────────────────────────────────┐    │
│  │              Command Handlers                       │    │
│  │                                                     │    │
│  │  Platform Detection (process.platform)             │    │
│  │    ├─> macOS: open command                         │    │
│  │    ├─> Windows: explorer command                   │    │
│  │    └─> Linux: xdg-open command                     │    │
│  │                                                     │    │
│  │  URI Handling (vscode.Uri → fsPath)                │    │
│  │  Path Resolution (file → dirname)                  │    │
│  │  Shell Escaping (spaces, special chars)            │    │
│  └────────────────────────────────────────────────────┘    │
│                        │                                     │
│                        ▼                                     │
│  ┌────────────────────────────────────────────────────┐    │
│  │           System Integration                        │    │
│  │                                                     │    │
│  │  • File Manager (child_process.exec)               │    │
│  │  • Terminal (vscode.window.createTerminal)         │    │
│  │  • New Window (vscode.commands.executeCommand)     │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Code Structure

### Main Components

1. **extension.ts** - Main extension file
   - `activate()`: Registers all commands
   - `deactivate()`: Cleanup (handled automatically)
   - Command handlers: `openInFileManager()`, `openDedicatedTerminal()`, `openNewWindowHere()`
   - Utility functions: Path handling, platform detection, shell escaping

2. **package.json** - Extension manifest
   - Metadata: name, version, description
   - Contribution points: commands, menus
   - Dependencies and scripts
   - Activation events

3. **Test Suite** - Validation
   - `runTest.ts`: Test runner
   - `suite/index.ts`: Mocha configuration
   - `suite/extension.test.ts`: Test cases

## Development Workflow

### Initial Setup

```bash
# Install dependencies
npm install

# Compile TypeScript
npm run compile

# Watch mode (auto-compile on changes)
npm run watch
```

### Running the Extension

1. Open VS Code in the extension directory
2. Press `F5` (or Run → Start Debugging)
3. A new "Extension Development Host" window opens
4. Test the extension in this window
5. Console output appears in the main window's Debug Console

### Testing Changes

```bash
# Run linter
npm run lint

# Fix linting issues automatically
npm run lint -- --fix

# Run tests
npm test
```

### Debugging

- Set breakpoints in `src/extension.ts`
- Press `F5` to start debugging
- Breakpoints will hit when commands are executed
- Use Debug Console for `console.log` output
- Use Debug Toolbar to step through code

## Key Functions Explained

### getFsPathFromResource()

Converts VS Code URI to filesystem path:
```typescript
vscode.Uri → string (filesystem path)
```

### getDirForResource()

Gets directory for file or folder:
```typescript
/path/to/file.txt → /path/to/
/path/to/folder → /path/to/folder
```

### escapeShellArg()

Escapes shell arguments for safe execution:
```typescript
"path with spaces" → "'path with spaces'" (Unix)
"path with spaces" → '"path with spaces"' (Windows)
```

### Platform Detection

```typescript
process.platform
├─ 'darwin' → macOS
├─ 'win32' → Windows
└─ 'linux' → Linux
```

## Testing Strategy

### Unit Tests

Located in `src/test/suite/extension.test.ts`:

1. **Extension Presence**: Verifies extension is installed
2. **Activation**: Ensures extension activates correctly
3. **Command Registration**: Validates all commands are registered
4. **Platform Detection**: Checks platform detection works
5. **Error Handling**: Tests commands with invalid input

### Manual Testing Checklist

- [ ] Right-click on file shows all 3 commands
- [ ] Right-click on folder shows all 3 commands
- [ ] **Open in File Manager**:
  - [ ] Opens file manager on macOS
  - [ ] Opens Explorer on Windows
  - [ ] Opens file manager on Linux
  - [ ] Handles paths with spaces
  - [ ] Handles symbolic links
- [ ] **Open Dedicated Terminal**:
  - [ ] Creates new terminal (doesn't reuse)
  - [ ] Terminal has correct name
  - [ ] Terminal has correct cwd
  - [ ] Works for files (uses parent dir)
  - [ ] Works for folders
- [ ] **Open New Window**:
  - [ ] Opens new window (not tab)
  - [ ] Opens correct directory
  - [ ] Works for files (uses parent dir)
  - [ ] Works for folders

## Building & Packaging

### Create VSIX Package

```bash
# Install vsce globally (if not installed)
npm install -g @vscode/vsce

# Package extension
npm run package

# This creates: explorer-tools-0.0.1.vsix
```

### Install VSIX Locally

```bash
code --install-extension explorer-tools-0.0.1.vsix
```

### Publishing to Marketplace

```bash
# Create publisher account at https://marketplace.visualstudio.com/manage

# Login to vsce
vsce login your-publisher-name

# Publish (bump version first!)
vsce publish
```

## Common Issues & Solutions

### Issue: "Command not found: tsc"

**Solution**: Install dependencies
```bash
npm install
```

### Issue: "Cannot find module 'vscode'"

**Solution**: Install @types/vscode
```bash
npm install --save-dev @types/vscode
```

### Issue: Tests fail with "Extension not found"

**Solution**: Update publisher name in tests to match package.json

### Issue: Extension doesn't activate

**Solution**: Check `activationEvents` in package.json

### Issue: Commands don't appear in context menu

**Solution**: 
- Verify `contributes.menus` in package.json
- Reload VS Code window
- Check command IDs match exactly

## Code Style Guidelines

### TypeScript

- Use strict mode
- Add JSDoc comments for all functions
- Prefer `const` over `let`
- Use async/await over promises
- Handle errors explicitly

### Naming Conventions

- **Functions**: camelCase (e.g., `openInFileManager`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `LOG_PREFIX`)
- **Interfaces**: PascalCase (e.g., `PlatformFileManager`)
- **Files**: kebab-case (e.g., `extension.ts`)

### Comments

```typescript
/**
 * Brief description
 * 
 * Detailed explanation of what the function does.
 * Include edge cases and important notes.
 * 
 * @param paramName - Description
 * @returns Description of return value
 */
```

## Performance Considerations

1. **Lazy Activation**: Use `onStartupFinished` to avoid slowing startup
2. **Async Operations**: All file system and shell operations are async
3. **Error Handling**: Fast-fail with user-friendly messages
4. **No Heavy Dependencies**: Keep extension lightweight

## Security Considerations

1. **Shell Escaping**: Always escape user paths before shell execution
2. **Path Validation**: Check if paths exist before executing commands
3. **URI Handling**: Use VS Code's URI API for proper path handling
4. **Error Messages**: Don't expose sensitive system information

## Extension Size Optimization

- Use `.vscodeignore` to exclude unnecessary files
- Don't bundle test files
- Exclude source TypeScript files (only include compiled JS)
- Minimize dependencies

## Future Enhancement Ideas

- [ ] Add keyboard shortcuts
- [ ] Add configuration options (custom terminal names, etc.)
- [ ] Support for remote workspaces
- [ ] Copy path to clipboard command
- [ ] Open in external editor command
- [ ] Batch operations (select multiple files)

## Resources

- [VS Code Extension API](https://code.visualstudio.com/api)
- [VS Code Extension Samples](https://github.com/microsoft/vscode-extension-samples)
- [Publishing Extensions](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

## Support

For questions or issues:
1. Check this guide
2. Review VS Code Extension API docs
3. Search GitHub issues
4. Create new issue with reproduction steps

---

Happy coding! 🚀
