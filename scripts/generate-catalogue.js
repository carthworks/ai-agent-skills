#!/usr/bin/env node
/**
 * generate-catalogue.js
 * Reads all SKILL.md, mcp.json, agent.json, rules, and plugin.json files and outputs:
 * - docs/skills.json
 * - docs/mcps.json
 * - docs/agents.json
 * - docs/rules.json
 * - docs/plugins.json
 * - Synchronizes INITIAL constants into docs/index.html
 */

const fs   = require('fs');
const path = require('path');
const matter = require('gray-matter');

const ROOT            = path.resolve(__dirname, '..');
const SKILLS_OUT_FILE = path.join(ROOT, 'docs', 'skills.json');
const MCPS_OUT_FILE   = path.join(ROOT, 'docs', 'mcps.json');
const AGENTS_OUT_FILE = path.join(ROOT, 'docs', 'agents.json');
const RULES_OUT_FILE  = path.join(ROOT, 'docs', 'rules.json');
const PLUGINS_OUT_FILE= path.join(ROOT, 'docs', 'plugins.json');

const SKILL_DIR   = path.join(ROOT, 'skills');
const MCP_DIR     = path.join(ROOT, 'mcps');
const AGENT_DIR   = path.join(ROOT, 'agents');
const RULES_DIR   = path.join(ROOT, 'rules');
const PLUGINS_DIR = path.join(ROOT, 'plugins');
const INDEX_HTML_PATH = path.join(ROOT, 'docs', 'index.html');

function findFiles(dir, filenamePattern) {
  const results = [];
  if (!fs.existsSync(dir)) return results;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) results.push(...findFiles(full, filenamePattern));
    else if (typeof filenamePattern === 'string' && entry.name === filenamePattern) results.push(full);
    else if (filenamePattern instanceof RegExp && filenamePattern.test(entry.name)) results.push(full);
  }
  return results;
}

function extractCategory(baseDir, filePath) {
  const rel = path.relative(baseDir, filePath);
  const parts = rel.split(path.sep);
  return parts.length >= 2 ? parts[0] : 'general';
}

function truncate(str, max = 160) {
  if (!str) return '';
  const flat = str.replace(/\n/g, ' ').trim();
  return flat.length > max ? flat.slice(0, max - 1) + '…' : flat;
}

// ── 1. Process Skills ────────────────────────────────────────────────────────
const skillFiles = findFiles(SKILL_DIR, 'SKILL.md');
const skills = [];

for (const filePath of skillFiles) {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const { data: fm } = matter(raw);
    const category = extractCategory(SKILL_DIR, filePath);
    const rel = path.relative(ROOT, path.dirname(filePath)).replace(/\\/g, '/');

    skills.push({
      name:        fm.name        || path.basename(path.dirname(filePath)),
      description: truncate(fm.description),
      category,
      path:        rel,
      license:     fm.license     || 'Apache-2.0',
      version:     fm.metadata?.version   || 'v1',
      publisher:   fm.metadata?.publisher || 'carthworks',
      tags:        fm.metadata?.tags      || [],
    });
  } catch (e) {
    console.error(`Warning: could not parse skill ${filePath}: ${e.message}`);
  }
}

skills.sort((a, b) => a.category.localeCompare(b.category) || a.name.localeCompare(b.name));
fs.mkdirSync(path.dirname(SKILLS_OUT_FILE), { recursive: true });
fs.writeFileSync(SKILLS_OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), skills }, null, 2));

// ── 2. Process MCPs ──────────────────────────────────────────────────────────
const mcpFiles = findFiles(MCP_DIR, 'mcp.json');
const mcps = [];

for (const filePath of mcpFiles) {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(raw);
    const category = data.category || extractCategory(MCP_DIR, filePath);
    const rel = path.relative(ROOT, path.dirname(filePath)).replace(/\\/g, '/');

    mcps.push({
      name:        data.name        || path.basename(path.dirname(filePath)),
      description: truncate(data.description),
      category,
      path:        rel,
      license:     data.license     || 'MIT',
      command:     data.command     || 'npx',
      args:        data.args        || [],
      env:         data.env         || {},
      version:     data.metadata?.version   || 'v1',
      publisher:   data.metadata?.publisher || 'carthworks',
      tags:        data.metadata?.tags      || [],
      runtime:     data.metadata?.runtime   || 'node',
      officialUrl: data.metadata?.officialUrl || '',
    });
  } catch (e) {
    console.error(`Warning: could not parse MCP ${filePath}: ${e.message}`);
  }
}

mcps.sort((a, b) => a.category.localeCompare(b.category) || a.name.localeCompare(b.name));
fs.writeFileSync(MCPS_OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), mcps }, null, 2));

// ── 3. Process Subagents ─────────────────────────────────────────────────────
const agentFiles = findFiles(AGENT_DIR, 'agent.json');
const agents = [];

for (const filePath of agentFiles) {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(raw);
    const category = data.category || 'general';
    const rel = path.relative(ROOT, path.dirname(filePath)).replace(/\\/g, '/');

    agents.push({
      name:         data.name        || path.basename(path.dirname(filePath)),
      role:         data.role        || 'Specialist Subagent',
      description:  truncate(data.description),
      category,
      path:         rel,
      model:        data.model       || 'high-reasoning',
      toolsAllowed: data.toolsAllowed|| [],
      license:      data.license     || 'Apache-2.0',
      version:      data.metadata?.version   || 'v1',
      publisher:    data.metadata?.publisher || 'carthworks',
      tags:         data.metadata?.tags      || [],
    });
  } catch (e) {
    console.error(`Warning: could not parse Agent ${filePath}: ${e.message}`);
  }
}

agents.sort((a, b) => a.category.localeCompare(b.category) || a.name.localeCompare(b.name));
fs.writeFileSync(AGENTS_OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), agents }, null, 2));

// ── 4. Process Rules ─────────────────────────────────────────────────────────
const ruleFiles = findFiles(RULES_DIR, /\.md$/);
const rules = [];

for (const filePath of ruleFiles) {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const { data: fm } = matter(raw);
    const name = fm.name || path.basename(filePath, '.md');
    const rel = path.relative(ROOT, filePath).replace(/\\/g, '/');

    rules.push({
      name,
      description: truncate(fm.description || ''),
      category:    fm.category || 'general',
      path:        rel,
      version:     fm.metadata?.version   || 'v1',
      publisher:   fm.metadata?.publisher || 'carthworks',
      tags:        fm.metadata?.tags      || [],
    });
  } catch (e) {
    console.error(`Warning: could not parse Rule ${filePath}: ${e.message}`);
  }
}

rules.sort((a, b) => a.category.localeCompare(b.category) || a.name.localeCompare(b.name));
fs.writeFileSync(RULES_OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), rules }, null, 2));

// ── 5. Process Plugins ───────────────────────────────────────────────────────
const pluginFiles = findFiles(PLUGINS_DIR, 'plugin.json');
const plugins = [];

for (const filePath of pluginFiles) {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const data = JSON.parse(raw);
    const category = data.category || 'general';
    const rel = path.relative(ROOT, path.dirname(filePath)).replace(/\\/g, '/');

    plugins.push({
      name:        data.name        || path.basename(path.dirname(filePath)),
      description: truncate(data.description),
      category,
      path:        rel,
      components:  data.components  || {},
      license:     data.license     || 'Apache-2.0',
      version:     data.metadata?.version   || 'v1',
      publisher:   data.metadata?.publisher || 'carthworks',
      tags:        data.metadata?.tags      || [],
    });
  } catch (e) {
    console.error(`Warning: could not parse Plugin ${filePath}: ${e.message}`);
  }
}

plugins.sort((a, b) => a.category.localeCompare(b.category) || a.name.localeCompare(b.name));
fs.writeFileSync(PLUGINS_OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), plugins }, null, 2));

// ── 6. Sync into docs/index.html ────────────────────────────────────────────
if (fs.existsSync(INDEX_HTML_PATH)) {
  let html = fs.readFileSync(INDEX_HTML_PATH, 'utf8');

  function syncSection(startMarker, endMarker, varName, data) {
    const sIdx1 = html.indexOf(startMarker);
    const sIdx2 = html.indexOf(endMarker);
    if (sIdx1 !== -1 && sIdx2 !== -1) {
      const jsonFormatted = JSON.stringify(data, null, 4).split('\n').map((l, i) => i === 0 ? l : '  ' + l).join('\n');
      html = html.slice(0, sIdx1) + `${startMarker}\n  const ${varName} = ${jsonFormatted};\n  ${endMarker}` + html.slice(sIdx2 + endMarker.length);
    }
  }

  syncSection('// __INITIAL_SKILLS_START__', '// __INITIAL_SKILLS_END__', 'INITIAL_SKILLS', skills);
  syncSection('// __INITIAL_MCPS_START__', '// __INITIAL_MCPS_END__', 'INITIAL_MCPS', mcps);
  syncSection('// __INITIAL_AGENTS_START__', '// __INITIAL_AGENTS_END__', 'INITIAL_AGENTS', agents);
  syncSection('// __INITIAL_RULES_START__', '// __INITIAL_RULES_END__', 'INITIAL_RULES', rules);
  syncSection('// __INITIAL_PLUGINS_START__', '// __INITIAL_PLUGINS_END__', 'INITIAL_PLUGINS', plugins);

  fs.writeFileSync(INDEX_HTML_PATH, html, 'utf8');
}

console.log(`✅ Generated docs/skills.json (${skills.length} skills), docs/mcps.json (${mcps.length} MCPs), docs/agents.json (${agents.length} agents), docs/rules.json (${rules.length} rules), docs/plugins.json (${plugins.length} plugins).`);
