/**
 * Explorer Tools Extension for VS Code
 * 
 * This extension adds context menu actions to the Explorer view:
 * 1. Open in File Manager (Finder/Explorer/File Manager)
 * 2. Open Dedicated Terminal Here
 * 3. Open New VS Code Window Here
 */

import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

// Logging prefix for consistency
const LOG_PREFIX = '[Explorer Tools]';

/**
 * Platform-specific file manager information
 */
interface PlatformFileManager {
  name: string;
  command: string;
}

/**
 * Get the file manager details for the current platform
 * 
 * @returns Platform-specific file manager configuration
 */
function getFileManagerInfo(): PlatformFileManager {
  const platform = process.platform;
  
  switch (platform) {
    case 'darwin':
      return { name: 'Finder', command: 'open' };
    case 'win32':
      return { name: 'Explorer', command: 'explorer' };
    default: // Linux and others
      return { name: 'File Manager', command: 'xdg-open' };
  }
}

/**
 * Extract the filesystem path from a VS Code URI or resource
 * 
 * Handles:
 * - Direct vscode.Uri objects
 * - undefined/null (returns empty string)
 * - Proper URI scheme validation
 * 
 * @param resource - The resource URI from VS Code
 * @returns Filesystem path as string
 */
function getFsPathFromResource(resource: vscode.Uri | undefined): string {
  if (!resource) {
    return '';
  }
  
  // VS Code URI objects have a fsPath property that handles platform-specific paths
  return resource.fsPath;
}

/**
 * Check if a path points to a directory
 * 
 * @param fsPath - Filesystem path to check
 * @returns true if path is a directory, false otherwise
 */
function isDirectory(fsPath: string): boolean {
  try {
    const stats = fs.statSync(fsPath);
    return stats.isDirectory();
  } catch (error) {
    console.error(`${LOG_PREFIX} Error checking if path is directory:`, error);
    return false;
  }
}

/**
 * Get the directory path for a given resource
 * 
 * If the resource is a file, returns its parent directory.
 * If it's already a directory, returns the directory itself.
 * 
 * @param fsPath - Filesystem path
 * @returns Directory path
 */
function getDirForResource(fsPath: string): string {
  if (!fsPath) {
    return '';
  }
  
  if (isDirectory(fsPath)) {
    return fsPath;
  }
  
  // It's a file, return parent directory
  return path.dirname(fsPath);
}

/**
 * Get a user-friendly name for a path (basename)
 * 
 * @param fsPath - Filesystem path
 * @returns Base name of the path
 */
function getBaseName(fsPath: string): string {
  return path.basename(fsPath);
}

/**
 * Escape shell arguments to handle spaces and special characters
 * 
 * @param arg - Argument to escape
 * @returns Escaped argument suitable for shell execution
 */
function escapeShellArg(arg: string): string {
  const platform = process.platform;
  
  if (platform === 'win32') {
    // Windows: wrap in quotes if contains spaces
    return arg.includes(' ') ? `"${arg}"` : arg;
  } else {
    // Unix-like: wrap in single quotes and escape existing single quotes
    return `'${arg.replace(/'/g, "'\\''")}'`;
  }
}

/**
 * Command: Open in File Manager (Finder/Explorer/File Manager)
 * 
 * Opens the system file manager at the location of the selected resource.
 * - macOS: Uses 'open' command to reveal in Finder
 * - Windows: Uses 'explorer' to open in Windows Explorer
 * - Linux: Uses 'xdg-open' to open default file manager
 * 
 * @param resource - The selected file or folder URI
 */
async function openInFileManager(resource: vscode.Uri | undefined): Promise<void> {
  console.log(`${LOG_PREFIX} Opening in file manager...`);
  
  const fsPath = getFsPathFromResource(resource);
  if (!fsPath) {
    vscode.window.showErrorMessage('No file or folder selected.');
    return;
  }
  
  // Check if path exists
  if (!fs.existsSync(fsPath)) {
    vscode.window.showErrorMessage(`Path does not exist: ${fsPath}`);
    return;
  }
  
  const fileManager = getFileManagerInfo();
  const platform = process.platform;
  
  try {
    let command: string;
    
    if (platform === 'darwin') {
      // macOS: 'open' reveals the item in Finder
      command = `open ${escapeShellArg(fsPath)}`;
    } else if (platform === 'win32') {
      // Windows: 'explorer' opens the folder or selects the file
      if (isDirectory(fsPath)) {
        command = `explorer ${escapeShellArg(fsPath)}`;
      } else {
        // Use /select to highlight the file in Explorer
        command = `explorer /select,${escapeShellArg(fsPath)}`;
      }
    } else {
      // Linux: 'xdg-open' opens the directory in default file manager
      const dirPath = getDirForResource(fsPath);
      command = `xdg-open ${escapeShellArg(dirPath)}`;
    }
    
    console.log(`${LOG_PREFIX} Executing command: ${command}`);
    await execAsync(command);
    console.log(`${LOG_PREFIX} Successfully opened in ${fileManager.name}`);
    
  } catch (error) {
    console.error(`${LOG_PREFIX} Error opening in file manager:`, error);
    
    if (platform === 'linux' && error instanceof Error && error.message.includes('xdg-open')) {
      vscode.window.showErrorMessage(
        'Could not open file manager. Please install xdg-utils package: sudo apt-get install xdg-utils'
      );
    } else {
      vscode.window.showErrorMessage(
        `Failed to open in ${fileManager.name}: ${error instanceof Error ? error.message : 'Unknown error'}`
      );
    }
  }
}

/**
 * Command: Open Dedicated Terminal Here
 * 
 * Creates a new terminal with its working directory set to the selected location.
 * - Does NOT reuse existing terminals
 * - Names the terminal based on the directory name
 * - For files, uses the parent directory
 * 
 * @param resource - The selected file or folder URI
 */
async function openDedicatedTerminal(resource: vscode.Uri | undefined): Promise<void> {
  console.log(`${LOG_PREFIX} Opening dedicated terminal...`);
  
  const fsPath = getFsPathFromResource(resource);
  if (!fsPath) {
    vscode.window.showErrorMessage('No file or folder selected.');
    return;
  }
  
  // Get the directory to open terminal in
  const dirPath = getDirForResource(fsPath);
  
  if (!dirPath || !fs.existsSync(dirPath)) {
    vscode.window.showErrorMessage(`Directory does not exist: ${dirPath}`);
    return;
  }
  
  try {
    // Get basename for terminal name
    const baseName = getBaseName(dirPath);
    const terminalName = `Dedicated: ${baseName}`;
    
    // Create new terminal with specific cwd
    const terminal = vscode.window.createTerminal({
      name: terminalName,
      cwd: dirPath
    });
    
    // Show the terminal
    terminal.show();
    
    console.log(`${LOG_PREFIX} Created terminal "${terminalName}" at ${dirPath}`);
    
  } catch (error) {
    console.error(`${LOG_PREFIX} Error creating terminal:`, error);
    vscode.window.showErrorMessage(
      `Failed to create terminal: ${error instanceof Error ? error.message : 'Unknown error'}`
    );
  }
}

/**
 * Command: Open New VS Code Window Here
 * 
 * Opens a new VS Code window focused on the selected directory.
 * - Always opens in a new window (forceNewWindow: true)
 * - For files, opens the parent directory
 * - Works with multi-root workspaces
 * 
 * @param resource - The selected file or folder URI
 */
async function openNewWindowHere(resource: vscode.Uri | undefined): Promise<void> {
  console.log(`${LOG_PREFIX} Opening new VS Code window...`);
  
  const fsPath = getFsPathFromResource(resource);
  if (!fsPath) {
    vscode.window.showErrorMessage('No file or folder selected.');
    return;
  }
  
  // Get the directory to open
  const dirPath = getDirForResource(fsPath);
  
  if (!dirPath || !fs.existsSync(dirPath)) {
    vscode.window.showErrorMessage(`Directory does not exist: ${dirPath}`);
    return;
  }
  
  try {
    // Convert back to URI for VS Code command
    const dirUri = vscode.Uri.file(dirPath);
    
    // Open in new window
    await vscode.commands.executeCommand('vscode.openFolder', dirUri, {
      forceNewWindow: true
    });
    
    console.log(`${LOG_PREFIX} Opened new window at ${dirPath}`);
    
  } catch (error) {
    console.error(`${LOG_PREFIX} Error opening new window:`, error);
    vscode.window.showErrorMessage(
      `Failed to open new window: ${error instanceof Error ? error.message : 'Unknown error'}`
    );
  }
}

/**
 * Extension activation
 * 
 * This function is called when the extension is activated.
 * Registers all commands with VS Code.
 * 
 * @param context - Extension context provided by VS Code
 */
export function activate(context: vscode.ExtensionContext): void {
  console.log(`${LOG_PREFIX} Extension activated`);
  
  // Log platform information
  const fileManager = getFileManagerInfo();
  console.log(`${LOG_PREFIX} Platform: ${process.platform}, File Manager: ${fileManager.name}`);
  
  // Register command: Open in File Manager
  const openInFileManagerCmd = vscode.commands.registerCommand(
    'explorerTools.openInFileManager',
    openInFileManager
  );
  
  // Register command: Open Dedicated Terminal
  const openDedicatedTerminalCmd = vscode.commands.registerCommand(
    'explorerTools.openDedicatedTerminal',
    openDedicatedTerminal
  );
  
  // Register command: Open New Window Here
  const openNewWindowCmd = vscode.commands.registerCommand(
    'explorerTools.openNewWindowHere',
    openNewWindowHere
  );
  
  // Add to subscriptions for proper cleanup
  context.subscriptions.push(
    openInFileManagerCmd,
    openDedicatedTerminalCmd,
    openNewWindowCmd
  );
  
  console.log(`${LOG_PREFIX} All commands registered successfully`);
}

/**
 * Extension deactivation
 * 
 * This function is called when the extension is deactivated.
 * Cleanup happens automatically via context.subscriptions.
 */
export function deactivate(): void {
  console.log(`${LOG_PREFIX} Extension deactivated`);
}
