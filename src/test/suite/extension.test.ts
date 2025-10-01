/**
 * Extension Test Suite
 * 
 * Tests for the Explorer Tools extension functionality.
 * Validates command registration and basic execution.
 */

import * as assert from 'assert';
import * as vscode from 'vscode';

suite('Explorer Tools Extension Test Suite', () => {
  vscode.window.showInformationMessage('Starting Explorer Tools tests...');

  test('Extension should be present', () => {
    const extension = vscode.extensions.getExtension('your-publisher-name.explorer-tools');
    assert.ok(extension, 'Extension should be installed');
  });

  test('Extension should activate', async () => {
    const extension = vscode.extensions.getExtension('your-publisher-name.explorer-tools');
    assert.ok(extension);
    
    await extension!.activate();
    assert.strictEqual(extension!.isActive, true, 'Extension should be active');
  });

  test('Command explorerTools.openInFileManager should be registered', async () => {
    const commands = await vscode.commands.getCommands(true);
    assert.ok(
      commands.includes('explorerTools.openInFileManager'),
      'openInFileManager command should be registered'
    );
  });

  test('Command explorerTools.openDedicatedTerminal should be registered', async () => {
    const commands = await vscode.commands.getCommands(true);
    assert.ok(
      commands.includes('explorerTools.openDedicatedTerminal'),
      'openDedicatedTerminal command should be registered'
    );
  });

  test('Command explorerTools.openNewWindowHere should be registered', async () => {
    const commands = await vscode.commands.getCommands(true);
    assert.ok(
      commands.includes('explorerTools.openNewWindowHere'),
      'openNewWindowHere command should be registered'
    );
  });

  test('All three commands should be registered', async () => {
    const commands = await vscode.commands.getCommands(true);
    const explorerToolsCommands = commands.filter(cmd => cmd.startsWith('explorerTools.'));
    
    assert.strictEqual(
      explorerToolsCommands.length,
      3,
      'Exactly 3 explorerTools commands should be registered'
    );
  });

  test('Platform detection should work', () => {
    const platform = process.platform;
    assert.ok(
      ['darwin', 'win32', 'linux'].includes(platform) || platform.length > 0,
      'Platform should be detected'
    );
  });

  test('Commands should execute without errors (with undefined resource)', async () => {
    // These will show error messages, but shouldn't throw exceptions
    try {
      await vscode.commands.executeCommand('explorerTools.openInFileManager', undefined);
      await vscode.commands.executeCommand('explorerTools.openDedicatedTerminal', undefined);
      await vscode.commands.executeCommand('explorerTools.openNewWindowHere', undefined);
      assert.ok(true, 'Commands executed without throwing errors');
    } catch (error) {
      assert.fail(`Commands should not throw errors: ${error}`);
    }
  });
});
