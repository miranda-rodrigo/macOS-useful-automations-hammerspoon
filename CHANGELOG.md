# Changelog

All notable changes to the "Explorer Tools" extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.0.1] - 2025-10-01

### Added
- Initial release of Explorer Tools
- **Open in File Manager** command
  - macOS: Opens in Finder using `open` command
  - Windows: Opens in Explorer using `explorer` command (selects files)
  - Linux: Opens in default file manager using `xdg-open`
- **Open Dedicated Terminal Here** command
  - Creates new terminal with custom name format `Dedicated: <folder-name>`
  - Sets terminal `cwd` to selected folder or file's parent directory
  - Does not reuse existing terminals
- **Open New VS Code Window Here** command
  - Opens new VS Code window focused on selected directory
  - For files, opens parent directory
  - Uses `forceNewWindow: true` option
- Full support for:
  - Files and folders
  - Paths with spaces
  - Symbolic links
  - Multi-root workspaces
  - Platform-specific implementations (macOS, Windows, Linux)
- Comprehensive error handling with user-friendly messages
- Detailed logging with `[Explorer Tools]` prefix
- Complete test suite with command registration validation
- Full documentation and troubleshooting guide

### Technical Details
- Built with TypeScript 5.3+
- VS Code API 1.90.0+
- ESLint for code quality
- Proper URI handling with `vscode.Uri`
- Cross-platform shell escaping for special characters

[unreleased]: https://github.com/your-username/explorer-tools/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/your-username/explorer-tools/releases/tag/v0.0.1
