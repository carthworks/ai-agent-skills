#!/usr/bin/env bash
# install.sh — Universal installer for ai-agent-skills (Skills, Plugins, Agents, Rules)
# Usage:
#   Interactive:
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash
#   Direct Single Item (checks and creates .agents/* automatically):
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- plugins/fullstack-launch
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- skills/web/web-trust-and-compliance
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- agents/pr-reviewer.agent.json
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- rules/git-safety.md
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- all

set -euo pipefail

REPO="carthworks/ai-agent-skills"
BRANCH="main"
BASE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"
TMP_DIR=$(mktemp -d)

# --- helpers ---
red()   { echo -e "\033[0;31m$*\033[0m"; }
green() { echo -e "\033[0;32m$*\033[0m"; }
bold()  { echo -e "\033[1m$*\033[0m"; }
dim()   { echo -e "\033[2m$*\033[0m"; }

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# --- download repo archive ---
bold "📦 Fetching developer-agent-stack catalogue..."
curl -sL "$BASE_URL" | tar -xz -C "$TMP_DIR" --strip-components=1

# --- helper to install an item into destination ---
install_item() {
  local target="$1"
  local found_path=""
  local item_type=""
  local dest_dir=""

  # 1. Exact path match in tmp dir
  if [[ -e "$TMP_DIR/$target" ]]; then
    found_path="$TMP_DIR/$target"
  # 2. Search in plugins
  elif [[ -d "$TMP_DIR/plugins/$target" ]]; then
    found_path="$TMP_DIR/plugins/$target"
  # 3. Search in rules
  elif [[ -f "$TMP_DIR/rules/$target" ]]; then
    found_path="$TMP_DIR/rules/$target"
  elif [[ -f "$TMP_DIR/rules/${target}.md" ]]; then
    found_path="$TMP_DIR/rules/${target}.md"
  # 4. Search in agents
  elif [[ -f "$TMP_DIR/agents/$target" ]]; then
    found_path="$TMP_DIR/agents/$target"
  elif [[ -f "$TMP_DIR/agents/${target}.agent.json" ]]; then
    found_path="$TMP_DIR/agents/${target}.agent.json"
  # 5. Search in skills (recursive search by folder name)
  else
    local skill_match
    skill_match=$(find "$TMP_DIR/skills" -maxdepth 2 -type d -name "$target" 2>/dev/null | head -n 1)
    if [[ -n "$skill_match" ]]; then
      found_path="$skill_match"
    fi
  fi

  if [[ -z "$found_path" ]]; then
    red "  ❌ Not found: '$target'"
    return 1
  fi

  # Determine destination directory based on path
  local rel_path="${found_path#$TMP_DIR/}"
  local base_name
  base_name=$(basename "$found_path")

  if [[ "$rel_path" == plugins/* ]]; then
    dest_dir=".agents/plugins"
    item_type="Plugin"
  elif [[ "$rel_path" == agents/* ]]; then
    dest_dir=".agents/agents"
    item_type="Agent"
  elif [[ "$rel_path" == rules/* ]]; then
    dest_dir=".agents/rules"
    item_type="Rule"
  elif [[ "$rel_path" == skills/* ]]; then
    dest_dir=".agents/skills"
    item_type="Skill"
  else
    dest_dir=".agents/custom"
    item_type="Custom"
  fi

  # Ensure target .agents directory exists
  mkdir -p "$dest_dir"

  # Copy file or directory
  cp -r "$found_path" "$dest_dir/"
  green "  ✅ Installed [$item_type]: $base_name → $dest_dir/$base_name"
}

# --- Direct argument installation ---
if [[ $# -gt 0 ]]; then
  TARGET="$1"

  if [[ "$TARGET" == "all" ]]; then
    bold "🚀 Installing full Developer Agent Stack into .agents/..."
    mkdir -p .agents/skills .agents/plugins .agents/agents .agents/rules
    if [[ -d "$TMP_DIR/skills" ]]; then
      find "$TMP_DIR/skills" -mindepth 2 -maxdepth 2 -type d -exec cp -r {} .agents/skills/ \;
    fi
    if [[ -d "$TMP_DIR/plugins" ]]; then
      find "$TMP_DIR/plugins" -mindepth 1 -maxdepth 1 -type d -exec cp -r {} .agents/plugins/ \;
    fi
    if [[ -d "$TMP_DIR/agents" ]]; then
      find "$TMP_DIR/agents" -mindepth 1 -maxdepth 1 -type f -exec cp -r {} .agents/agents/ \;
    fi
    if [[ -d "$TMP_DIR/rules" ]]; then
      find "$TMP_DIR/rules" -mindepth 1 -maxdepth 1 -type f -exec cp -r {} .agents/rules/ \;
    fi
    green "✅ Full stack installed to .agents/ (Skills, Plugins, Agents, Rules)"
    exit 0
  fi

  # Install single or multiple arguments
  for item in "$@"; do
    install_item "$item"
  done
  exit 0
fi

# --- interactive menu ---
echo ""
bold "Available Plugins & Skills:"
echo ""

declare -A CATALOGUE=(
  [1]="plugins/fullstack-launch"
  [2]="plugins/secure-delivery"
  [3]="plugins/quality-core"
  [4]="skills/web/production-web-app-launch"
  [5]="skills/web/web-trust-and-compliance"
  [6]="skills/web/nextjs-performance"
  [7]="skills/web/api-design-rest"
  [8]="skills/typescript/typescript-strict-mode"
  [9]="skills/testing/test-coverage-guidance"
  [10]="skills/safety/env-secret-safety"
  [11]="skills/devops/git-commit-quality"
  [12]="skills/devops/code-review-checklist"
  [13]="skills/devops/dockerfile-best-practices"
  [14]="agents/pr-reviewer.agent.json"
  [15]="agents/security-auditor.agent.json"
  [16]="agents/qa-tester.agent.json"
  [17]="rules/git-safety.md"
  [18]="rules/typescript-strict.md"
  [19]="rules/web-compliance.md"
  [20]="rules/secret-hygiene.md"
)

declare -A LABELS=(
  [1]="📦 [Plugin]  fullstack-launch          — Web launch, trust, QA & commit stack"
  [2]="📦 [Plugin]  secure-delivery           — Secret hygiene, security audit & Docker"
  [3]="📦 [Plugin]  quality-core              — TypeScript strict, PR review & tests"
  [4]="🧠 [Skill]   production-web-app-launch — Production readiness audit"
  [5]="🧠 [Skill]   web-trust-and-compliance  — Legal, privacy, consent & trust audit"
  [6]="🧠 [Skill]   nextjs-performance        — Core Web Vitals & bundle optimisation"
  [7]="🧠 [Skill]   api-design-rest           — REST API standards & pagination"
  [8]="🧠 [Skill]   typescript-strict-mode    — Type safety & strict mode enforcement"
  [9]="🧠 [Skill]   test-coverage-guidance    — Unit, integration & E2E strategies"
  [10]="🧠 [Skill]  env-secret-safety         — Zero hardcoded secrets & .env hygiene"
  [11]="🧠 [Skill]  git-commit-quality        — Conventional Commits enforcement"
  [12]="🧠 [Skill]  code-review-checklist     — BLOCKER/MAJOR/MINOR PR review"
  [13]="🧠 [Skill]  dockerfile-best-practices — Secure, minimal container images"
  [14]="🤖 [Agent]  pr-reviewer               — PR code review specialist"
  [15]="🤖 [Agent]  security-auditor          — AppSec & vulnerability scanner"
  [16]="🤖 [Agent]  qa-tester                 — Test plan & edge case generator"
  [17]="📜 [Rule]   git-safety                — Protected branches & clean history"
  [18]="📜 [Rule]   typescript-strict         — No 'any', exhaustive types"
  [19]="📜 [Rule]   web-compliance            — Mandatory trust anchors & legal"
  [20]="📜 [Rule]   secret-hygiene            — Mandatory .env checks & scan"
)

for i in $(seq 1 ${#CATALOGUE[@]}); do
  echo "  $i) ${LABELS[$i]}"
done

echo ""
echo "  a) Install everything (Full 5-Pillar Stack)"
echo "  q) Quit"
echo ""

SELECTION=""
if [ -t 0 ]; then
  read -rp "$(bold 'Select items to install (comma-separated numbers, or a/q): ')" SELECTION || true
elif [ -r /dev/tty ]; then
  read -rp "$(bold 'Select items to install (comma-separated numbers, or a/q): ')" SELECTION </dev/tty 2>/dev/null || true
elif [ -r /dev/conin ]; then
  read -rp "$(bold 'Select items to install (comma-separated numbers, or a/q): ')" SELECTION </dev/conin 2>/dev/null || true
fi

if [[ -z "${SELECTION:-}" || "$SELECTION" == "q" ]]; then
  dim "No selection made or aborted. Exiting."
  exit 0
fi

if [[ "$SELECTION" == "a" ]]; then
  for key in "${!CATALOGUE[@]}"; do
    install_item "${CATALOGUE[$key]}"
  done
else
  IFS=',' read -ra KEYS <<< "$SELECTION"
  for key in "${KEYS[@]}"; do
    key=$(echo "$key" | tr -d ' ')
    if [[ -z "${CATALOGUE[$key]+x}" ]]; then
      red "  ⚠️  Unknown selection: $key — skipping"
      continue
    fi
    install_item "${CATALOGUE[$key]}"
  done
fi

echo ""
bold "Done! All selected items are installed under .agents/"
dim "Commit the .agents/ directory to share with your team."

