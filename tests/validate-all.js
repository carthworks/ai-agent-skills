#!/usr/bin/env node
/**
 * validate-all.js
 * Runs all validation test suites across skills, mcps, agents, and plugins.
 */

const { execSync } = require('child_process');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');

const suites = [
  { name: 'Skills', script: 'tests/validate-skills.js' },
  { name: 'MCPs', script: 'tests/validate-mcps.js' },
  { name: 'Agents', script: 'tests/validate-agents.js' },
  { name: 'Plugins', script: 'tests/validate-plugins.js' }
];

let hasFailures = false;

for (const suite of suites) {
  try {
    execSync(`node ${path.join(ROOT, suite.script)}`, { stdio: 'inherit' });
  } catch (err) {
    hasFailures = true;
  }
}

if (hasFailures) {
  console.error('\n❌ One or more validation suites failed.\n');
  process.exit(1);
} else {
  console.log('\n🎉 ALL DEVELOPER AGENT STACK VALIDATIONS PASSED!\n');
  process.exit(0);
}
