#!/usr/bin/env node
/**
 * generate-catalogue.js
 * Reads all SKILL.md files and outputs docs/skills.json for the marketplace page.
 * Run: node scripts/generate-catalogue.js
 */

const fs   = require('fs');
const path = require('path');
const matter = require('gray-matter');

const ROOT      = path.resolve(__dirname, '..');
const OUT_FILE  = path.join(ROOT, 'docs', 'skills.json');
const SKILL_DIR = path.join(ROOT, 'skills');

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

function extractCategory(filePath) {
  // skills/<category>/<name>/SKILL.md  →  category
  const rel = path.relative(SKILL_DIR, filePath);
  const parts = rel.split(path.sep);
  return parts.length >= 2 ? parts[0] : 'general';
}

function truncate(str, max = 160) {
  if (!str) return '';
  const flat = str.replace(/\n/g, ' ').trim();
  return flat.length > max ? flat.slice(0, max - 1) + '…' : flat;
}

const skillFiles = findSkillFiles(SKILL_DIR);
const skills = [];

for (const filePath of skillFiles) {
  try {
    const raw = fs.readFileSync(filePath, 'utf8');
    const { data: fm } = matter(raw);
    const category = extractCategory(filePath);
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

// Sort: by category, then by name
skills.sort((a, b) => {
  if (a.category < b.category) return -1;
  if (a.category > b.category) return 1;
  return a.name.localeCompare(b.name);
});

fs.mkdirSync(path.dirname(OUT_FILE), { recursive: true });
fs.writeFileSync(OUT_FILE, JSON.stringify({ generated: new Date().toISOString(), skills }, null, 2));

// Also sync INITIAL_SKILLS in docs/index.html so it works without server / on file://
const INDEX_HTML_PATH = path.join(ROOT, 'docs', 'index.html');
if (fs.existsSync(INDEX_HTML_PATH)) {
  let html = fs.readFileSync(INDEX_HTML_PATH, 'utf8');
  const startMarker = '// __INITIAL_SKILLS_START__';
  const endMarker = '// __INITIAL_SKILLS_END__';
  const startIndex = html.indexOf(startMarker);
  const endIndex = html.indexOf(endMarker);
  if (startIndex !== -1 && endIndex !== -1) {
    const formattedJson = JSON.stringify(skills, null, 4)
      .split('\n')
      .map((line, i) => i === 0 ? line : '  ' + line)
      .join('\n');
    const replacement = `${startMarker}\n  const INITIAL_SKILLS = ${formattedJson};\n  ${endMarker}`;
    html = html.slice(0, startIndex) + replacement + html.slice(endIndex + endMarker.length);
    fs.writeFileSync(INDEX_HTML_PATH, html, 'utf8');
  }
}

console.log(`✅ Generated docs/skills.json and synced docs/index.html with ${skills.length} skills.`);
