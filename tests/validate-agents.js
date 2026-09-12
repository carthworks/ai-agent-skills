#!/usr/bin/env node
/**
 * validate-agents.js
 * Validates every agent.json and AGENT.md in agents/ against agent.schema.json.
 * Exit 0 = all valid. Exit 1 = failures found.
 */

const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');

const ROOT = path.resolve(__dirname, '..');
const SCHEMA_PATH = path.join(ROOT, 'agent.schema.json');
const AGENTS_DIR = path.join(ROOT, 'agents');

const green  = (s) => `\x1b[32m${s}\x1b[0m`;
const red    = (s) => `\x1b[31m${s}\x1b[0m`;
const bold   = (s) => `\x1b[1m${s}\x1b[0m`;
const dim    = (s) => `\x1b[2m${s}\x1b[0m`;

if (!fs.existsSync(AGENTS_DIR)) {
  console.log(bold('\n🔍 No agents directory found.\n'));
  process.exit(0);
}

const schema = JSON.parse(fs.readFileSync(SCHEMA_PATH, 'utf8'));
const ajv = new Ajv({ allErrors: true });
addFormats(ajv);
const validate = ajv.compile(schema);

let totalFiles = 0;
let passCount  = 0;
let failCount  = 0;

console.log(bold('\n🔍 Validating agent.json & AGENT.md files against agent.schema.json\n'));

const agentDirs = fs.readdirSync(AGENTS_DIR, { withFileTypes: true })
  .filter(d => d.isDirectory())
  .map(d => path.join(AGENTS_DIR, d.name));

for (const dir of agentDirs) {
  const jsonPath = path.join(dir, 'agent.json');
  const mdPath = path.join(dir, 'AGENT.md');

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

  if (fs.existsSync(mdPath)) {
    totalFiles++;
    const rel = path.relative(ROOT, mdPath);
    try {
      const raw = fs.readFileSync(mdPath, 'utf8');
      const { data } = matter(raw);
      if (data && data.name) {
        passCount++;
        console.log(`  ${green('✓')} ${rel}`);
      } else {
        failCount++;
        console.log(`  ${red('✗')} ${rel} — Missing frontmatter with 'name'`);
      }
    } catch (e) {
      failCount++;
      console.log(`  ${red('✗')} ${rel} — Markdown/YAML error: ${e.message}`);
    }
  }
}

console.log('\n' + '─'.repeat(60));
console.log(bold(`\nResults: ${totalFiles} agent files checked`));
console.log(`  ${green(`✓ ${passCount} passed`)}`);
if (failCount > 0) {
  console.log(`  ${red(`✗ ${failCount} failed`)}`);
  process.exit(1);
} else {
  console.log('\n' + green(bold('✅ All subagents validated successfully!\n')));
  process.exit(0);
}
