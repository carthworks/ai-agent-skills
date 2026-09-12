#!/usr/bin/env node
/**
 * validate-plugins.js
 * Validates every plugin.json in plugins/ against plugin.schema.json.
 * Exit 0 = all valid. Exit 1 = failures found.
 */

const fs = require('fs');
const path = require('path');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');

const ROOT = path.resolve(__dirname, '..');
const SCHEMA_PATH = path.join(ROOT, 'plugin.schema.json');
const PLUGINS_DIR = path.join(ROOT, 'plugins');

const green  = (s) => `\x1b[32m${s}\x1b[0m`;
const red    = (s) => `\x1b[31m${s}\x1b[0m`;
const bold   = (s) => `\x1b[1m${s}\x1b[0m`;
const dim    = (s) => `\x1b[2m${s}\x1b[0m`;

if (!fs.existsSync(PLUGINS_DIR)) {
  console.log(bold('\n🔍 No plugins directory found.\n'));
  process.exit(0);
}

const schema = JSON.parse(fs.readFileSync(SCHEMA_PATH, 'utf8'));
const ajv = new Ajv({ allErrors: true });
addFormats(ajv);
const validate = ajv.compile(schema);

let totalFiles = 0;
let passCount  = 0;
let failCount  = 0;

console.log(bold('\n🔍 Validating plugin.json files against plugin.schema.json\n'));

const pluginDirs = fs.readdirSync(PLUGINS_DIR, { withFileTypes: true })
  .filter(d => d.isDirectory())
  .map(d => path.join(PLUGINS_DIR, d.name));

for (const dir of pluginDirs) {
  const jsonPath = path.join(dir, 'plugin.json');
  if (fs.existsSync(jsonPath)) {
    totalFiles++;
    const rel = path.relative(ROOT, jsonPath);
    try {
      const data = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
      const valid = validate(data);
      if (valid) {
        passCount++;
        console.log(`  ${green('✓')} ${rel}`);
      } else {
        failCount++;
        console.log(`  ${red('✗')} ${rel}`);
        for (const err of validate.errors) {
          console.log(`    ${dim((err.instancePath || '(root)') + ': ' + err.message)}`);
        }
      }
    } catch (e) {
      failCount++;
      console.log(`  ${red('✗')} ${rel} — JSON parse error: ${e.message}`);
    }
  }
}

console.log('\n' + '─'.repeat(60));
console.log(bold(`\nResults: ${totalFiles} plugin files checked`));
console.log(`  ${green(`✓ ${passCount} passed`)}`);
if (failCount > 0) {
  console.log(`  ${red(`✗ ${failCount} failed`)}`);
  process.exit(1);
} else {
  console.log('\n' + green(bold('✅ All plugins validated successfully!\n')));
  process.exit(0);
}
