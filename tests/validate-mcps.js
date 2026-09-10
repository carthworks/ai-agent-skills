#!/usr/bin/env node
/**
 * validate-mcps.js
 * Validates every mcp.json in mcps/ against mcp.schema.json.
 * Exit 0 = all valid. Exit 1 = failures found.
 */

const fs = require('fs');
const path = require('path');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');

// ── Config ─────────────────────────────────────────────────────────────────
const ROOT = path.resolve(__dirname, '..');
const SCHEMA_PATH = path.join(ROOT, 'mcp.schema.json');
const MCP_DIR = path.join(ROOT, 'mcps');

// ── Helpers ─────────────────────────────────────────────────────────────────
const green  = (s) => `\x1b[32m${s}\x1b[0m`;
const red    = (s) => `\x1b[31m${s}\x1b[0m`;
const yellow = (s) => `\x1b[33m${s}\x1b[0m`;
const bold   = (s) => `\x1b[1m${s}\x1b[0m`;
const dim    = (s) => `\x1b[2m${s}\x1b[0m`;

function findMcpFiles(dir) {
  const results = [];
  if (!fs.existsSync(dir)) return results;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) results.push(...findMcpFiles(full));
    else if (entry.name === 'mcp.json') results.push(full);
  }
  return results;
}

// ── Setup AJV ───────────────────────────────────────────────────────────────
const schema = JSON.parse(fs.readFileSync(SCHEMA_PATH, 'utf8'));
const ajv = new Ajv({ allErrors: true });
addFormats(ajv);
const validate = ajv.compile(schema);

// ── Main ────────────────────────────────────────────────────────────────────
let totalFiles = 0;
let passCount  = 0;
let failCount  = 0;
const failures = [];

console.log(bold('\n🔍 Validating mcp.json files against mcp.schema.json\n'));

const mcpFiles = findMcpFiles(MCP_DIR);
for (const filePath of mcpFiles) {
  totalFiles++;
  const rel = path.relative(ROOT, filePath);
  let data;
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    data = JSON.parse(raw);
  } catch (e) {
    failCount++;
    failures.push({ file: rel, errors: [`JSON parse error: ${e.message}`] });
    console.log(`  ${red('✗')} ${rel}\n    ${dim(e.message)}`);
    continue;
  }

  // Validate name matches folder
  const expectedName = path.basename(path.dirname(filePath));
  if (data.name && data.name !== expectedName) {
    console.log(`  ${yellow('⚠')} ${rel} — name "${data.name}" doesn't match folder "${expectedName}"`);
  }

  // Validate against schema
  const valid = validate(data);
  if (valid) {
    passCount++;
    console.log(`  ${green('✓')} ${rel}`);
  } else {
    failCount++;
    const errors = validate.errors.map(
      (e) => `  ${e.instancePath || '(root)'}: ${e.message}`
    );
    failures.push({ file: rel, errors });
    console.log(`  ${red('✗')} ${rel}`);
    for (const err of errors) {
      console.log(`    ${dim(err.trim())}`);
    }
  }
}

// ── Summary ─────────────────────────────────────────────────────────────────
console.log('\n' + '─'.repeat(60));
console.log(bold(`\nResults: ${totalFiles} MCP files checked`));
console.log(`  ${green(`✓ ${passCount} passed`)}`);
if (failCount > 0) {
  console.log(`  ${red(`✗ ${failCount} failed`)}`);
  console.log('\n' + red(bold('Validation failed. Fix the errors above before merging.\n')));
  process.exit(1);
} else {
  console.log('\n' + green(bold('✅ All MCP definitions validated successfully!\n')));
  process.exit(0);
}
