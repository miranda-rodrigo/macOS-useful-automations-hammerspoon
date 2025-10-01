/**
 * Test Runner for Explorer Tools Extension
 * 
 * This file is the entry point for running tests using @vscode/test-electron.
 * It downloads VS Code, installs the extension, and runs the test suite.
 */

import * as path from 'path';
import { runTests } from '@vscode/test-electron';

async function main() {
  try {
    // The folder containing the Extension Manifest package.json
    // Passed to `--extensionDevelopmentPath`
    const extensionDevelopmentPath = path.resolve(__dirname, '../../');

    // The path to the extension test script
    // Passed to --extensionTestsPath
    const extensionTestsPath = path.resolve(__dirname, './suite/index');

    // Download VS Code, unzip it and run the integration test
    console.log('[Test Runner] Starting tests...');
    console.log('[Test Runner] Extension path:', extensionDevelopmentPath);
    console.log('[Test Runner] Tests path:', extensionTestsPath);

    await runTests({
      extensionDevelopmentPath,
      extensionTestsPath
    });

    console.log('[Test Runner] All tests passed!');
  } catch (err) {
    console.error('[Test Runner] Failed to run tests:', err);
    process.exit(1);
  }
}

main();
