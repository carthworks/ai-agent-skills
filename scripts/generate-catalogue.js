#!/usr/bin/env node
/**
 * generate-catalogue.js
 * Reads all SKILL.md and mcp.json files and outputs:
 * - docs/skills.json
 * - docs/mcps.json
 * - Synchronizes INITIAL_SKILLS & INITIAL_MCPS into docs/index.html
 */

const fs   = require('fs');
const path = require('path');
const matter = require('gray-matter');

const ROOT      = path.resolve(__dirname, '..');
const SKILLS_OUT_FILE = path.join(ROOT, 'docs', 'skills.json');
const MCPS_OUT_FILE   = path.join(ROOT, 'docs', 'mcps.json');
const SKILL_DIR = path.join(ROOT, 'skills');
const MCP_DIR   = path.join(ROOT, 'mcps');
const INDEX_HTML_PATH = path.join(ROOT, 'docs', 'index.html');

function findFiles(dir, filename) {
  const results = [];
  if (!fs.existsSync(dir)) return results;
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) results.push(...findFiles(full, filename));
    else if (entry.name === filename) results.push(full);
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
    console.error(`Warning: could not parse ${filePath}: ${e.message}`);
  }
}

skills.sort((a, b) => {
  if (a.category < b.category) return -1;
  if (a.category > b.category) return 1;
  return a.name.localeCompare(b.name);
});

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

mcps.sort((a, b) => {
  if (a.category < b.category) return -1;
  if (a.category > b.category) return 1;
  return a.name.localeCompare(b.name);
});

fs.writeFileSync(MCPS_OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), mcps }, null, 2));

// ── 3. Sync into docs/index.html ────────────────────────────────────────────
if (fs.existsSync(INDEX_HTML_PATH)) {
  let html = fs.readFileSync(INDEX_HTML_PATH, 'utf8');
  
  // Sync Skills
  const sStart = '// __INITIAL_SKILLS_START__';
  const sEnd = '// __INITIAL_SKILLS_END__';
  const sIdx1 = html.indexOf(sStart);
  const sIdx2 = html.indexOf(sEnd);
  if (sIdx1 !== -1 && sIdx2 !== -1) {
    const jsonFormatted = JSON.stringify(skills, null, 4).split('\n').map((l, i) => i === 0 ? l : '  ' + l).join('\n');
    html = html.slice(0, sIdx1) + `${sStart}\n  const INITIAL_SKILLS = ${jsonFormatted};\n  ${sEnd}` + html.slice(sIdx2 + sEnd.length);
  }

  // Sync MCPs
  const mStart = '// __INITIAL_MCPS_START__';
  const mEnd = '// __INITIAL_MCPS_END__';
  const mIdx1 = html.indexOf(mStart);
  const mIdx2 = html.indexOf(mEnd);
  if (mIdx1 !== -1 && mIdx2 !== -1) {
    const jsonFormatted = JSON.stringify(mcps, null, 4).split('\n').map((l, i) => i === 0 ? l : '  ' + l).join('\n');
    html = html.slice(0, mIdx1) + `${mStart}\n  const INITIAL_MCPS = ${jsonFormatted};\n  ${mEnd}` + html.slice(mIdx2 + mEnd.length);
  }

  fs.writeFileSync(INDEX_HTML_PATH, html, 'utf8');
}

console.log(`✅ Generated docs/skills.json (${skills.length} skills) & docs/mcps.json (${mcps.length} MCPs), synced docs/index.html.`);
