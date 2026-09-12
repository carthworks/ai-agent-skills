# install.ps1 — Universal installer for ai-agent-skills (Skills, Plugins, Agents, Rules)
# Usage:
#   Interactive:
#     irm https://raw.githubusercontent.com/carthworks/ai-agent-skills/main/scripts/install.ps1 | iex
#   Direct Single Item (checks and creates .agents/* automatically):
#     .\scripts\install.ps1 -Target "plugins/fullstack-launch"
#     .\scripts\install.ps1 -Target "skills/web/web-trust-and-compliance"
#     .\scripts\install.ps1 -Target "agents/pr-reviewer.agent.json"
#     .\scripts\install.ps1 -Target "rules/git-safety.md"
#     .\scripts\install.ps1 -Target "all"

param(
    [string]$Target = ""
)

$ErrorActionPreference = "Stop"

$Repo   = "carthworks/ai-agent-skills"
$Branch = "main"
$ArchiveUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
$TmpDir = Join-Path $env:TEMP "ai-agent-skills-$(Get-Random)"

# --- catalogue ---
$Catalogue = @{
    1  = @{ Path = "plugins/web-security-pack";                Label = "📦 [Plugin]  web-security-pack         — Web trust, secret hygiene, auditor & rules" }
    2  = @{ Path = "plugins/production-launch-pack";          Label = "📦 [Plugin]  production-launch-pack    — Launch audit, Next.js perf & QA tester" }
    3  = @{ Path = "plugins/fullstack-quality-pack";          Label = "📦 [Plugin]  fullstack-quality-pack    — TypeScript strict, coverage & PR reviewer" }
    4  = @{ Path = "skills/web/production-web-app-launch";    Label = "🧠 [Skill]   production-web-app-launch — Production readiness audit" }
    5  = @{ Path = "skills/web/web-trust-and-compliance";      Label = "🧠 [Skill]   web-trust-and-compliance  — Legal, privacy, consent & trust audit" }
    6  = @{ Path = "skills/web/developer-console-signature";  Label = "🧠 [Skill]   developer-console-signature — Styled author branding & DevTools helpers" }
    7  = @{ Path = "skills/web/nextjs-performance";            Label = "🧠 [Skill]   nextjs-performance        — Core Web Vitals & bundle optimisation" }
    8  = @{ Path = "skills/web/api-design-rest";               Label = "🧠 [Skill]   api-design-rest           — REST API standards & pagination" }
    9  = @{ Path = "skills/typescript/typescript-strict-mode"; Label = "🧠 [Skill]   typescript-strict-mode    — Type safety & strict mode enforcement" }
    10 = @{ Path = "skills/testing/test-coverage-guidance";    Label = "🧠 [Skill]   test-coverage-guidance    — Unit, integration & E2E strategies" }
    11 = @{ Path = "skills/safety/env-secret-safety";          Label = "🧠 [Skill]   env-secret-safety         — Zero hardcoded secrets & .env hygiene" }
    12 = @{ Path = "skills/devops/git-commit-quality";         Label = "🧠 [Skill]   git-commit-quality        — Conventional Commits enforcement" }
    13 = @{ Path = "skills/devops/code-review-checklist";      Label = "🧠 [Skill]   code-review-checklist     — BLOCKER/MAJOR/MINOR PR review" }
    14 = @{ Path = "skills/devops/dockerfile-best-practices";  Label = "🧠 [Skill]   dockerfile-best-practices — Secure, minimal container images" }
    15 = @{ Path = "agents/security-auditor.agent.json";       Label = "🤖 [Agent]   security-auditor          — AppSec & vulnerability scanner" }
    16 = @{ Path = "agents/code-reviewer.agent.json";          Label = "🤖 [Agent]   code-reviewer             — Principal PR code reviewer" }
    17 = @{ Path = "agents/qa-engineer.agent.json";            Label = "🤖 [Agent]   qa-engineer               — Test plan & regression generator" }
    18 = @{ Path = "rules/token-efficiency.md";                Label = "📜 [Rule]    token-efficiency          — Minimal diffs & token optimization" }
    19 = @{ Path = "rules/typescript-strict-guardrails.md";    Label = "📜 [Rule]    typescript-strict         — Zero 'any', runtime Zod validation" }
    20 = @{ Path = "rules/clean-architecture-boundaries.md";   Label = "📜 [Rule]    clean-architecture        — Layered architecture & separation" }
    21 = @{ Path = "rules/security-and-secret-hygiene.md";     Label = "📜 [Rule]    secret-hygiene            — Mandatory .env checks & no secrets" }
}

function Write-Header { Write-Host "`n$args" -ForegroundColor Cyan }
function Write-Ok     { Write-Host "  ✅ $args" -ForegroundColor Green }
function Write-Warn   { Write-Host "  ⚠️  $args" -ForegroundColor Yellow }
function Write-Dim    { Write-Host "  $args" -ForegroundColor DarkGray }

function Install-Item-Path ($itemRel, $extractedRoot) {
    $normRel = $itemRel -replace "\\", "/"
    $targetPath = Join-Path $extractedRoot ($normRel -replace "/", "\")

    # If not found directly, try searching inside subdirectories
    if (-not (Test-Path $targetPath)) {
        if (Test-Path (Join-Path $extractedRoot "plugins\$normRel")) {
            $targetPath = Join-Path $extractedRoot "plugins\$normRel"
            $normRel = "plugins/$normRel"
        } elseif (Test-Path (Join-Path $extractedRoot "rules\$normRel")) {
            $targetPath = Join-Path $extractedRoot "rules\$normRel"
            $normRel = "rules/$normRel"
        } elseif (Test-Path (Join-Path $extractedRoot "rules\$normRel.md")) {
            $targetPath = Join-Path $extractedRoot "rules\$normRel.md"
            $normRel = "rules/$normRel.md"
        } elseif (Test-Path (Join-Path $extractedRoot "agents\$normRel")) {
            $targetPath = Join-Path $extractedRoot "agents\$normRel"
            $normRel = "agents/$normRel"
        } elseif (Test-Path (Join-Path $extractedRoot "agents\$normRel.agent.json")) {
            $targetPath = Join-Path $extractedRoot "agents\$normRel.agent.json"
            $normRel = "agents/$normRel.agent.json"
        } else {
            $match = Get-ChildItem -Path (Join-Path $extractedRoot "skills") -Directory -Recurse | Where-Object { $_.Name -eq $normRel } | Select-Object -First 1
            if ($match) {
                $targetPath = $match.FullName
                $normRel = "skills/$($match.Name)"
            }
        }
    }

    if (-not (Test-Path $targetPath)) {
        Write-Warn "Not found: $itemRel"
        return
    }

    $baseName = Split-Path $targetPath -Leaf
    $destSub = ".agents\skills"
    $typeLabel = "Skill"

    if ($normRel -like "plugins/*") {
        $destSub = ".agents\plugins"
        $typeLabel = "Plugin"
    } elseif ($normRel -like "agents/*") {
        $destSub = ".agents\agents"
        $typeLabel = "Agent"
    } elseif ($normRel -like "rules/*") {
        $destSub = ".agents\rules"
        $typeLabel = "Rule"
    }

    New-Item -ItemType Directory -Force -Path $destSub | Out-Null
    $finalDest = Join-Path $destSub $baseName
    Copy-Item -Recurse -Force $targetPath $finalDest
    Write-Ok "Installed [$typeLabel]: $baseName → $finalDest"
}

try {
    Write-Header "📦 Fetching developer-agent-stack catalogue..."

    # Download archive
    $ZipPath = Join-Path $env:TEMP "ai-agent-skills.zip"
    Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ZipPath -UseBasicParsing
    Expand-Archive -Path $ZipPath -DestinationPath $TmpDir -Force
    Remove-Item $ZipPath

    $ExtractedRoot = Get-ChildItem $TmpDir | Select-Object -First 1 -ExpandProperty FullName

    # Direct install if -Target was passed
    if ($Target -ne "") {
        if ($Target -eq "all") {
            Write-Host "🚀 Installing full Developer Agent Stack into .agents\..." -ForegroundColor Cyan
            New-Item -ItemType Directory -Force -Path ".agents\skills", ".agents\plugins", ".agents\agents", ".agents\rules" | Out-Null
            Get-ChildItem (Join-Path $ExtractedRoot "skills") -Directory -Recurse -Depth 1 | ForEach-Object {
                if (Test-Path (Join-Path $_.FullName "SKILL.md")) {
                    Copy-Item -Recurse -Force $_.FullName (Join-Path ".agents\skills" $_.Name)
                }
            }
            Get-ChildItem (Join-Path $ExtractedRoot "plugins") -Directory | ForEach-Object {
                Copy-Item -Recurse -Force $_.FullName (Join-Path ".agents\plugins" $_.Name)
            }
            Get-ChildItem (Join-Path $ExtractedRoot "agents") -File | ForEach-Object {
                Copy-Item -Force $_.FullName (Join-Path ".agents\agents" $_.Name)
            }
            Get-ChildItem (Join-Path $ExtractedRoot "rules") -File | ForEach-Object {
                Copy-Item -Force $_.FullName (Join-Path ".agents\rules" $_.Name)
            }
            Write-Ok "Full stack installed to .agents\ (Skills, Plugins, Agents, Rules)"
            return
        }

        Install-Item-Path $Target $ExtractedRoot
        return
    }

    # Interactive menu
    Write-Host ""
    Write-Host "Available Plugins, Skills, Agents & Rules:" -ForegroundColor Cyan
    Write-Host ""
    foreach ($k in $Catalogue.Keys | Sort-Object) {
        Write-Host "  $k) $($Catalogue[$k].Label)"
    }
    Write-Host ""
    Write-Host "  a) Install all items (Full Stack)"
    Write-Host "  q) Quit"
    Write-Host ""
    $Selection = Read-Host "Select items to install (comma-separated numbers, or a/q)"

    if ($Selection -eq "q" -or [string]::IsNullOrWhiteSpace($Selection)) {
        Write-Dim "Aborted."
        return
    }

    if ($Selection -eq "a") {
        foreach ($k in $Catalogue.Keys | Sort-Object) {
            Install-Item-Path $Catalogue[$k].Path $ExtractedRoot
        }
    } else {
        $Keys = $Selection -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
        foreach ($key in $Keys) {
            $parsed = 0
            if (-not [int]::TryParse($key, [ref]$parsed) -or -not $Catalogue.ContainsKey($parsed)) {
                Write-Warn "Unknown selection: $key — skipping"
                continue
            }
            Install-Item-Path $Catalogue[$parsed].Path $ExtractedRoot
        }
    }

    Write-Host ""
    Write-Host "Done! Items installed under .agents\" -ForegroundColor Cyan
    Write-Dim "Commit the .agents\ directory to share with your team."

} finally {
    if (Test-Path $TmpDir) { Remove-Item -Recurse -Force $TmpDir }
}

