// verify.test.js — tooling check test
import assert from 'node:assert';
import { execSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

// Run verify.js and capture output
const output = execSync(`node "${join(__dirname, 'verify.js')}"`, {
  encoding: 'utf8',
  cwd: __dirname,
}).trim();

const lines = output.split('\n');

assert.strictEqual(lines[0], 'toolchain ok', 'verify.js should print "toolchain ok"');
assert(lines.includes('PASS'), 'verify.js should print "PASS"');

// Also assert node and npm are available
const nodeVersion = execSync('node -v', { encoding: 'utf8' }).trim();
const npmVersion = execSync('npm -v', { encoding: 'utf8' }).trim();

assert.match(nodeVersion, /^v2[0-9]/, `node -v should be v20+, got ${nodeVersion}`);
assert.match(npmVersion, /^[91]/, `npm -v should be 9+, got ${npmVersion}`);

console.log('All tooling checks passed');
