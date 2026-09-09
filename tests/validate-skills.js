#!/usr/bin/env node
/**
 * validate-skills.js
 * Validates every SKILL.md in skills/ and community/ against skill.schema.json.
 * Exit 0 = all valid. Exit 1 = failures found.
 */

const fs = require('fs');
const path = require('path');
const matter = require('gray-matter');
const Ajv = require('ajv');
const addFormats = require('ajv-formats');

// ── Config ─────────────────────────────────────────────────────────────────
const ROOT = path.resolve(__dirname, '..');
const SCHEMA_PATH = path.join(ROOT, 'skill.schema.json');
const SKILL_DIRS = ['skills', 'community'];

// ── Helpers ─────────────────────────────────────────────────────────────────
const green  = (s) => `\x1b[32m${s}\x1b[0m`;
const red    = (s) => `\x1b[31m${s}\x1b[0m`;
const yellow = (s) => `\x1b[33m${s}\x1b[0m`;
const bold   = (s) => `\x1b[1m${s}\x1b[0m`;
const dim    = (s) => `\x1b[2m${s}\x1b[0m`;

function findSkillFiles(dir) {
  const results = [];
  if (!fs.existsSync(dir)) return results;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) results.push(...findSkillFiles(full));
    else if (entry.name === 'SKILL.md') results.push(full);
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

console.log(bold('\n🔍 Validating SKILL.md files against skill.schema.json\n'));

for (const dir of SKILL_DIRS) {
  const skillFiles = findSkillFiles(path.join(ROOT, dir));
  for (const filePath of skillFiles) {
    totalFiles++;
    const rel = path.relative(ROOT, filePath);
    let raw;
    try {
      raw = fs.readFileSync(filePath, 'utf8');
    } catch (e) {
      failCount++;
      failures.push({ file: rel, errors: [`Could not read file: ${e.message}`] });
      console.log(`  ${red('✗')} ${rel}`);
      continue;
    }

    // Check frontmatter exists
    if (!raw.startsWith('---')) {
      failCount++;
      const msg = 'Missing YAML frontmatter (file must start with ---)';
      failures.push({ file: rel, errors: [msg] });
      console.log(`  ${red('✗')} ${rel}\n    ${dim(msg)}`);
      continue;
    }

    // Parse frontmatter
    let frontmatter;
    try {
      const parsed = matter(raw);
      frontmatter = parsed.data;
    } catch (e) {
      failCount++;
      const msg = `YAML parse error: ${e.message}`;
      failures.push({ file: rel, errors: [msg] });
      console.log(`  ${red('✗')} ${rel}\n    ${dim(msg)}`);
      continue;
    }

    // Validate name matches folder
    const expectedName = path.basename(path.dirname(filePath));
    if (frontmatter.name && frontmatter.name !== expectedName) {
      // Warn but don't fail — community skills may differ
      console.log(`  ${yellow('⚠')} ${rel} — name "${frontmatter.name}" doesn't match folder "${expectedName}"`);
    }

    // Validate against schema
    const valid = validate(frontmatter);
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
}

// ── Summary ─────────────────────────────────────────────────────────────────
console.log('\n' + '─'.repeat(60));
console.log(bold(`\nResults: ${totalFiles} files checked`));
console.log(`  ${green(`✓ ${passCount} passed`)}`);
if (failCount > 0) {
  console.log(`  ${red(`✗ ${failCount} failed`)}`);
  console.log('\n' + red(bold('Validation failed. Fix the errors above before merging.\n')));
  process.exit(1);
} else {
  console.log('\n' + green(bold('✅ All skills validated successfully!\n')));
  process.exit(0);
}
