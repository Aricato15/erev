<#
.SYNOPSIS
  Create a new project in the workspace root (the parent of _scripts\) from _templates\project.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File _scripts\new-project.ps1 -Name my-app -Description "Todo app" -Stack "Python (uv)"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [string]$Description = "TODO: one-paragraph description of what this project is and who it is for.",

    [string]$Stack = "TODO: languages, frameworks, package manager, runtime versions.",

    [switch]$NoCommit
)

$ErrorActionPreference = 'Stop'

$root     = Split-Path -Parent $PSScriptRoot
$template = Join-Path $root '_templates\project'
$dest     = Join-Path $root $Name
$index    = Join-Path $root 'PROJECTS.md'

# --- validate ---------------------------------------------------------------
if ($Name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    throw "Invalid name '$Name'. Use kebab-case: lowercase letters, digits and single hyphens (e.g. my-app)."
}
if (-not (Test-Path $template)) { throw "Template not found: $template" }
if (Test-Path $dest)            { throw "Already exists: $dest" }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git is not installed or not on PATH." }

# --- copy template ----------------------------------------------------------
Copy-Item -Path $template -Destination $dest -Recurse

# --- fill placeholders (UTF-8 without BOM) ----------------------------------
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$today     = Get-Date -Format 'yyyy-MM-dd'
$tokens    = @{
    '{{PROJECT_NAME}}' = $Name
    '{{DESCRIPTION}}'  = $Description
    '{{STACK}}'        = $Stack
    '{{DATE}}'         = $today
}
Get-ChildItem -Path $dest -Recurse -File -Force |
    Where-Object { $_.Extension -in '.md', '.json', '.txt', '.toml', '.yaml', '.yml' } |
    ForEach-Object {
        $text = [System.IO.File]::ReadAllText($_.FullName)
        $orig = $text
        foreach ($k in $tokens.Keys) { $text = $text.Replace($k, $tokens[$k]) }
        if ($text -ne $orig) { [System.IO.File]::WriteAllText($_.FullName, $text, $utf8NoBom) }
    }

# --- git init (each project is its own repo) --------------------------------
Push-Location $dest
try {
    git init -q -b main
    if ($LASTEXITCODE -ne 0) { throw "git init failed" }
    if (-not $NoCommit) {
        git add -A
        git commit -q -m "Initial project scaffold from workspace template"
        if ($LASTEXITCODE -ne 0) { Write-Warning "Initial commit failed (is git user.name/user.email set?). Repo was created without a commit." }
    }
}
finally {
    Pop-Location
}

# --- register in PROJECTS.md ------------------------------------------------
$desc = ($Description -replace '\r?\n', ' ') -replace '\|', '/'
$stk  = ($Stack -replace '\r?\n', ' ') -replace '\|', '/'
$row  = "| [$Name]($Name/) | $desc | $stk | active | $today |"
$existing = ''
if (Test-Path $index) { $existing = [System.IO.File]::ReadAllText($index) }
if ($existing -and -not $existing.EndsWith("`n")) { $existing += "`r`n" }
[System.IO.File]::WriteAllText($index, $existing + $row + "`r`n", $utf8NoBom)

Write-Host "Created $dest"
Write-Host "Next: cd `"$dest`"; claude   (then fill in CLAUDE.md > Commands)"
