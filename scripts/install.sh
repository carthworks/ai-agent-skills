#!/usr/bin/env bash
# install.sh — Interactive skill installer for ai-agent-skills
# Usage: curl -fsSL https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.sh | bash
#        or run directly: ./scripts/install.sh [skill-folder-path]

set -euo pipefail

REPO="carthworks/ai-agent-skills"
BRANCH="main"
BASE_URL="https://github.com/${REPO}/archive/refs/heads/${BRANCH}.tar.gz"
TMP_DIR=$(mktemp -d)
DEST=".agents/skills"

# --- helpers ---
red()   { echo -e "\033[0;31m$*\033[0m"; }
green() { echo -e "\033[0;32m$*\033[0m"; }
bold()  { echo -e "\033[1m$*\033[0m"; }
dim()   { echo -e "\033[2m$*\033[0m"; }

cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# --- skill catalogue (auto-discovered from repo) ---
declare -A SKILLS=(
  [1]="skills/web/production-web-app-launch"
  [2]="skills/web/nextjs-performance"
  [3]="skills/web/api-design-rest"
  [4]="skills/typescript/typescript-strict-mode"
  [5]="skills/testing/test-coverage-guidance"
  [6]="skills/devops/git-commit-quality"
  [7]="skills/devops/code-review-checklist"
  [8]="skills/devops/dockerfile-best-practices"
  [9]="skills/safety/env-secret-safety"
)
declare -A SKILL_LABELS=(
  [1]="[web]        production-web-app-launch   — Production readiness audit"
  [2]="[web]        nextjs-performance          — Core Web Vitals & bundle optimisation"
  [3]="[web]        api-design-rest             — REST API naming, status codes, pagination"
  [4]="[typescript] typescript-strict-mode      — Strict types, no any, discriminated unions"
  [5]="[testing]    test-coverage-guidance      — Unit/integration/E2E strategy & patterns"
  [6]="[devops]     git-commit-quality          — Conventional Commits enforcement"
  [7]="[devops]     code-review-checklist       — BLOCKER/MAJOR/MINOR PR review"
  [8]="[devops]     dockerfile-best-practices   — Multi-stage, non-root, minimal images"
  [9]="[safety]     env-secret-safety           — No hardcoded secrets, .env hygiene"
)

# --- download repo archive ---
bold "📦 Fetching ai-agent-skills catalogue..."
curl -sL "$BASE_URL" | tar -xz -C "$TMP_DIR" --strip-components=1

# --- if a skill path was passed as argument, install it directly ---
if [[ $# -gt 0 ]]; then
  SKILL_PATH="$1"
  SKILL_NAME=$(basename "$SKILL_PATH")
  mkdir -p "$DEST"
  cp -r "$TMP_DIR/$SKILL_PATH" "$DEST/"
  green "✅ Installed: $SKILL_NAME → $DEST/$SKILL_NAME"
  exit 0
fi

# --- interactive menu ---
echo ""
bold "Available skills:"
echo ""
for key in "${!SKILL_LABELS[@]}"; do
  echo "  $key) ${SKILL_LABELS[$key]}"
done
echo ""
echo "  a) Install all skills"
echo "  q) Quit"
echo ""
read -rp "$(bold 'Select skills to install (comma-separated numbers, or a/q): ')" SELECTION

if [[ "$SELECTION" == "q" ]]; then
  dim "Aborted."
  exit 0
fi

mkdir -p "$DEST"

if [[ "$SELECTION" == "a" ]]; then
  KEYS=("${!SKILLS[@]}")
else
  IFS=',' read -ra KEYS <<< "$SELECTION"
fi

for key in "${KEYS[@]}"; do
  key=$(echo "$key" | tr -d ' ')
  if [[ -z "${SKILLS[$key]+x}" ]]; then
    red "  ⚠️  Unknown selection: $key — skipping"
    continue
  fi
  SKILL_PATH="${SKILLS[$key]}"
  SKILL_NAME=$(basename "$SKILL_PATH")
  cp -r "$TMP_DIR/$SKILL_PATH" "$DEST/"
  green "  ✅ Installed: $SKILL_NAME → $DEST/$SKILL_NAME"
done

echo ""
bold "Done! Skills are in .agents/skills/"
dim "Commit the .agents/ folder to share skills with your team."
