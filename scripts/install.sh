#!/usr/bin/env bash
# install.sh — Universal installer for ai-agent-skills (Skills, Plugins, Agents, Rules)
# Usage:
#   Interactive:
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash
#   Direct Single Item (checks and creates .agents/* automatically):
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- plugins/fullstack-quality-pack
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- skills/web/web-trust-and-compliance
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- agents/code-reviewer
#     curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash -s -- rules/typescript-strict-guardrails.md
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

  # Legacy aliases & normalization
  case "$target" in
    "plugins/quality-core"|"quality-core")
      target="plugins/fullstack-quality-pack" ;;
    "plugins/fullstack-launch"|"fullstack-launch")
      target="plugins/production-launch-pack" ;;
    "plugins/secure-delivery"|"secure-delivery")
      target="plugins/web-security-pack" ;;
    "agents/pr-reviewer"|"agents/pr-reviewer.agent.json"|"pr-reviewer"|"pr-reviewer.agent.json")
      target="agents/code-reviewer" ;;
    "agents/qa-tester"|"agents/qa-tester.agent.json"|"qa-tester"|"qa-tester.agent.json")
      target="agents/qa-engineer" ;;
    "agents/security-auditor.agent.json")
      target="agents/security-auditor" ;;
    "agents/code-reviewer.agent.json")
      target="agents/code-reviewer" ;;
    "agents/qa-engineer.agent.json")
      target="agents/qa-engineer" ;;
    "rules/git-safety"|"rules/git-safety.md"|"git-safety"|"git-safety.md")
      target="rules/token-efficiency.md" ;;
    "rules/typescript-strict"|"rules/typescript-strict.md"|"typescript-strict"|"typescript-strict.md")
      target="rules/typescript-strict-guardrails.md" ;;
    "rules/web-compliance"|"rules/web-compliance.md"|"web-compliance"|"web-compliance.md")
      target="rules/clean-architecture-boundaries.md" ;;
    "rules/secret-hygiene"|"rules/secret-hygiene.md"|"secret-hygiene"|"secret-hygiene.md")
      target="rules/security-and-secret-hygiene.md" ;;
  esac

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
  # 4. Search in agents (specialist subagent folders)
  elif [[ -d "$TMP_DIR/agents/$target" ]]; then
    found_path="$TMP_DIR/agents/$target"
  elif [[ -f "$TMP_DIR/agents/$target" ]]; then
    found_path="$TMP_DIR/agents/$target"
  elif [[ -d "$TMP_DIR/agents/${target%.agent.json}" ]]; then
    found_path="$TMP_DIR/agents/${target%.agent.json}"
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
      find "$TMP_DIR/agents" -mindepth 1 -maxdepth 1 -type d -exec cp -r {} .agents/agents/ \;
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
  [1]="plugins/web-security-pack"
  [2]="plugins/production-launch-pack"
  [3]="plugins/fullstack-quality-pack"
  [4]="skills/web/production-web-app-launch"
  [5]="skills/web/web-trust-and-compliance"
  [6]="skills/web/developer-console-signature"
  [7]="skills/web/nextjs-performance"
  [8]="skills/web/api-design-rest"
  [9]="skills/typescript/typescript-strict-mode"
  [10]="skills/testing/test-coverage-guidance"
  [11]="skills/safety/env-secret-safety"
  [12]="skills/devops/git-commit-quality"
  [13]="skills/devops/code-review-checklist"
  [14]="skills/devops/dockerfile-best-practices"
  [15]="agents/security-auditor"
  [16]="agents/code-reviewer"
  [17]="agents/qa-engineer"
  [18]="rules/token-efficiency.md"
  [19]="rules/typescript-strict-guardrails.md"
  [20]="rules/clean-architecture-boundaries.md"
  [21]="rules/security-and-secret-hygiene.md"
)

declare -A LABELS=(
  [1]="📦 [Plugin]  web-security-pack         — Web trust, secret hygiene, auditor & rules"
  [2]="📦 [Plugin]  production-launch-pack    — Launch audit, Next.js perf & QA tester"
  [3]="📦 [Plugin]  fullstack-quality-pack    — TypeScript strict, coverage & PR reviewer"
  [4]="🧠 [Skill]   production-web-app-launch — Production readiness audit"
  [5]="🧠 [Skill]   web-trust-and-compliance  — Legal, privacy, consent & trust audit"
  [6]="🧠 [Skill]   developer-console-signature — Styled author branding & DevTools helpers"
  [7]="🧠 [Skill]   nextjs-performance        — Core Web Vitals & bundle optimisation"
  [8]="🧠 [Skill]   api-design-rest           — REST API standards & pagination"
  [9]="🧠 [Skill]   typescript-strict-mode    — Type safety & strict mode enforcement"
  [10]="🧠 [Skill]  test-coverage-guidance    — Unit, integration & E2E strategies"
  [11]="🧠 [Skill]  env-secret-safety         — Zero hardcoded secrets & .env hygiene"
  [12]="🧠 [Skill]  git-commit-quality        — Conventional Commits enforcement"
  [13]="🧠 [Skill]  code-review-checklist     — BLOCKER/MAJOR/MINOR PR review"
  [14]="🧠 [Skill]  dockerfile-best-practices — Secure, minimal container images"
  [15]="🤖 [Agent]  security-auditor          — AppSec & vulnerability scanner"
  [16]="🤖 [Agent]  code-reviewer             — Principal PR code reviewer"
  [17]="🤖 [Agent]  qa-engineer               — Test plan & regression generator"
  [18]="📜 [Rule]   token-efficiency          — Minimal diffs & token optimization"
  [19]="📜 [Rule]   typescript-strict         — Zero 'any', runtime Zod validation"
  [20]="📜 [Rule]   clean-architecture        — Layered architecture & separation"
  [21]="📜 [Rule]   secret-hygiene            — Mandatory .env checks & no secrets"
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

