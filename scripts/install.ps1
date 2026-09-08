# install.ps1 — Interactive skill installer for ai-agent-skills
# Usage: irm https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.ps1 | iex
#        or run directly: .\scripts\install.ps1 [-Skill "skills/web/production-web-app-launch"]

param(
    [string]$Skill = ""
)

$ErrorActionPreference = "Stop"

$Repo   = "carthworks/ai-agent-skills"
$Branch = "main"
$ArchiveUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
$TmpDir = Join-Path $env:TEMP "ai-agent-skills-$(Get-Random)"
$Dest   = ".agents\skills"

# --- skill catalogue ---
$Skills = @{
    1 = @{ Path = "skills/web/production-web-app-launch";          Label = "[web]        production-web-app-launch   — Production readiness audit" }
    2 = @{ Path = "skills/web/nextjs-performance";                  Label = "[web]        nextjs-performance          — Core Web Vitals & bundle optimisation" }
    3 = @{ Path = "skills/web/api-design-rest";                     Label = "[web]        api-design-rest             — REST API naming, status codes, pagination" }
    4 = @{ Path = "skills/typescript/typescript-strict-mode";       Label = "[typescript] typescript-strict-mode      — Strict types, no any, discriminated unions" }
    5 = @{ Path = "skills/testing/test-coverage-guidance";          Label = "[testing]    test-coverage-guidance      — Unit/integration/E2E strategy & patterns" }
    6 = @{ Path = "skills/devops/git-commit-quality";               Label = "[devops]     git-commit-quality          — Conventional Commits enforcement" }
    7 = @{ Path = "skills/devops/code-review-checklist";            Label = "[devops]     code-review-checklist       — BLOCKER/MAJOR/MINOR PR review" }
    8 = @{ Path = "skills/devops/dockerfile-best-practices";        Label = "[devops]     dockerfile-best-practices   — Multi-stage, non-root, minimal images" }
    9 = @{ Path = "skills/safety/env-secret-safety";                Label = "[safety]     env-secret-safety           — No hardcoded secrets, .env hygiene" }
}

function Write-Header { Write-Host "`n$args" -ForegroundColor Cyan }
function Write-Ok     { Write-Host "  ✅ $args" -ForegroundColor Green }
function Write-Warn   { Write-Host "  ⚠️  $args" -ForegroundColor Yellow }
function Write-Dim    { Write-Host "  $args" -ForegroundColor DarkGray }

try {
    Write-Header "📦 Fetching ai-agent-skills catalogue..."

    # Download archive
    $ZipPath = Join-Path $env:TEMP "ai-agent-skills.zip"
    Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ZipPath -UseBasicParsing
    Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force
    Remove-Item $ZipPath

    # The zip extracts into a subfolder like "ai-agent-skills-main"
    $ExtractedRoot = Get-ChildItem $TmpDir | Select-Object -First 1 -ExpandProperty FullName

    # Direct install if -Skill was passed
    if ($Skill -ne "") {
        $SkillName = Split-Path $Skill -Leaf
        $SkillSrc  = Join-Path $ExtractedRoot ($Skill -replace "/", "\")
        $SkillDest = Join-Path $Dest $SkillName
        New-Item -ItemType Directory -Force -Path $Dest | Out-Null
        Copy-Item -Recurse -Force $SkillSrc $SkillDest
        Write-Ok "Installed: $SkillName → $SkillDest"
        return
    }

    # Interactive menu
    Write-Host ""
    Write-Host "Available skills:" -ForegroundColor Cyan
    Write-Host ""
    foreach ($k in $Skills.Keys | Sort-Object) {
        Write-Host "  $k) $($Skills[$k].Label)"
    }
    Write-Host ""
    Write-Host "  a) Install all skills"
    Write-Host "  q) Quit"
    Write-Host ""
    $Selection = Read-Host "Select skills to install (comma-separated numbers, or a/q)"

    if ($Selection -eq "q") {
        Write-Dim "Aborted."
        return
    }

    New-Item -ItemType Directory -Force -Path $Dest | Out-Null

    if ($Selection -eq "a") {
        $Keys = $Skills.Keys | Sort-Object
    } else {
        $Keys = $Selection -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    }

    foreach ($key in $Keys) {
        $keyInt = [int]$key
        if (-not $Skills.ContainsKey($keyInt)) {
            Write-Warn "Unknown selection: $key — skipping"
            continue
        }
        $SkillPath = $Skills[$keyInt].Path
        $SkillName = Split-Path $SkillPath -Leaf
        $SkillSrc  = Join-Path $ExtractedRoot ($SkillPath -replace "/", "\")
        $SkillDest = Join-Path $Dest $SkillName
        Copy-Item -Recurse -Force $SkillSrc $SkillDest
        Write-Ok "Installed: $SkillName → $SkillDest"
    }

    Write-Host ""
    Write-Host "Done! Skills are in .agents\skills\" -ForegroundColor Cyan
    Write-Dim "Commit the .agents\ folder to share skills with your team."

} finally {
    if (Test-Path $TmpDir) { Remove-Item -Recurse -Force $TmpDir }
}
