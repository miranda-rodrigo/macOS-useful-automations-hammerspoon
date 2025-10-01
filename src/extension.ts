import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { spawn } from 'child_process';

/**
 * Logs messages with a consistent prefix for easier filtering.
 * Keeps logging minimal as requested.
 */
function log(message: string): void {
  console.log(`[Explorer Tools] ${message}`);
}

/**
 * Extract a local filesystem path from a VS Code resource URI.
 * - Accepts standard file URIs used by the Explorer.
 * - Provides friendly errors when the URI scheme is unsupported.
 *
 * @param resource The resource URI from the Explorer context menu.
 * @returns The local filesystem path for the resource.
 * @throws When the URI scheme is not 'file'.
 */
function getFsPathFromResource(resource: vscode.Uri): string {
  if (resource.scheme !== 'file') {
    const message = 'Only local file system resources are supported.';
    vscode.window.showErrorMessage(message);
    throw new Error(message);
  }
  return resource.fsPath;
}

/**
 * Determine whether the given filesystem path points to a directory.
 * - Follows symlinks using fs.stat (not lstat).
 * - Returns false for non-existent paths and on stat errors.
 *
 * @param targetPath The absolute path to check.
 * @returns Promise resolving to true if a directory, else false.
 */
async function isDirectory(targetPath: string): Promise<boolean> {
  try {
    const stats = await fs.promises.stat(targetPath);
    return stats.isDirectory();
  } catch (error) {
    return false;
  }
}

/**
 * Compute the directory to operate on given a resource URI.
 * - If the resource is a directory, returns it.
 * - If the resource is a file, returns its parent directory.
 *
 * @param resource The resource URI from the Explorer.
 * @returns Object containing the directory path and its base name.
 */
async function dirFor(resource: vscode.Uri): Promise<{ dirPath: string; baseName: string }>
{
  const fsPath = getFsPathFromResource(resource);
  const directory = (await isDirectory(fsPath)) ? fsPath : path.dirname(fsPath);
  return { dirPath: directory, baseName: path.basename(directory) };
}

/**
 * Open the given resource in the OS file manager.
 * - macOS: `open <path>`
 * - Windows: `explorer.exe <path>`
 * - Linux: `xdg-open <path>` (shows a friendly error if unavailable)
 *
 * For files, opens the file itself; for folders, opens the folder.
 *
 * @param resource The resource URI selected in the Explorer.
 */
async function openInFileManager(resource: vscode.Uri): Promise<void> {
  const target = getFsPathFromResource(resource);

  const platform = process.platform;
  let command: string;
  let args: string[] = [];

  if (platform === 'darwin') {
    command = 'open';
    args = [target];
  } else if (platform === 'win32') {
    command = 'explorer.exe';
    args = [target];
  } else {
    command = 'xdg-open';
    args = [target];
  }

  log(`Opening in file manager using: ${command} ${JSON.stringify(args)}`);

  try {
    await new Promise<void>((resolve, reject) => {
      const child = spawn(command, args, { stdio: 'ignore' });
      child.on('error', (err) => reject(err));
      child.on('close', () => resolve());
    });
  } catch (error: unknown) {
    const err = error as NodeJS.ErrnoException;
    if (process.platform !== 'win32' && err.code === 'ENOENT' && command === 'xdg-open') {
      vscode.window.showErrorMessage(
        'Could not open file manager: "xdg-open" not found. Please install xdg-utils (e.g., sudo apt install xdg-utils).'
      );
      return;
    }
    vscode.window.showErrorMessage(`Failed to open in file manager: ${(err && err.message) || error}`);
  }
}

/**
 * Open a new dedicated terminal at the directory for the selected item.
 * - Always creates a new terminal and does not reuse existing ones.
 * - Terminal name format: "Dedicated: <basename>".
 * - Uses the parent directory when a file is selected.
 *
 * @param resource The resource URI selected in the Explorer.
 */
async function openDedicatedTerminalHere(resource: vscode.Uri): Promise<void> {
  const { dirPath, baseName } = await dirFor(resource);
  const terminalName = `Dedicated: ${baseName}`;
  log(`Creating terminal "${terminalName}" at cwd: ${dirPath}`);

  const terminal = vscode.window.createTerminal({ name: terminalName, cwd: dirPath });
  terminal.show();
}

/**
 * Open a new VS Code window focused on the directory for the selected item.
 * - Uses parent directory when a file is selected.
 * - Forces a new window via vscode.openFolder API.
 *
 * @param resource The resource URI selected in the Explorer.
 */
async function openNewWindowHere(resource: vscode.Uri): Promise<void> {
  const { dirPath } = await dirFor(resource);
  log(`Opening new VS Code window at: ${dirPath}`);
  const targetUri = vscode.Uri.file(dirPath);
  try {
    await vscode.commands.executeCommand('vscode.openFolder', targetUri, { forceNewWindow: true });
  } catch (error) {
    vscode.window.showErrorMessage(`Failed to open new window: ${error}`);
  }
}

/**
 * Activate the extension and register the Explorer context menu commands.
 * - Commands are registered with IDs under the explorerTools.* namespace.
 * - Implementations are fully cross-platform and handle files/folders.
 */
export function activate(context: vscode.ExtensionContext): void {
  log('Activating extension');

  const openInFileManagerCmd = vscode.commands.registerCommand(
    'explorerTools.openInFileManager',
    async (resource: vscode.Uri) => openInFileManager(resource)
  );

  // Platform-specific command IDs for clearer menu titles
  const openInFinderCmd = vscode.commands.registerCommand(
    'explorerTools.openInFinder',
    async (resource: vscode.Uri) => openInFileManager(resource)
  );

  const openInExplorerCmd = vscode.commands.registerCommand(
    'explorerTools.openInExplorer',
    async (resource: vscode.Uri) => openInFileManager(resource)
  );

  const openInFileManagerLinuxCmd = vscode.commands.registerCommand(
    'explorerTools.openInFileManagerLinux',
    async (resource: vscode.Uri) => openInFileManager(resource)
  );

  const openDedicatedTerminalCmd = vscode.commands.registerCommand(
    'explorerTools.openDedicatedTerminal',
    async (resource: vscode.Uri) => openDedicatedTerminalHere(resource)
  );

  const openNewWindowHereCmd = vscode.commands.registerCommand(
    'explorerTools.openNewWindowHere',
    async (resource: vscode.Uri) => openNewWindowHere(resource)
  );

  context.subscriptions.push(
    openInFileManagerCmd,
    openInFinderCmd,
    openInExplorerCmd,
    openInFileManagerLinuxCmd,
    openDedicatedTerminalCmd,
    openNewWindowHereCmd
  );
}

/**
 * Deactivate hook for the extension lifecycle. No-op in this extension.
 */
export function deactivate(): void {
  log('Deactivating extension');
}

// Export helpers for testing if needed
export const __test__ = { getFsPathFromResource, isDirectory, dirFor };

