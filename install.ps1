#Requires -Version 5.1
<#
  Segundo cerebro para Claude Code + Codex, via Obsidian.
  Instala lo que se puede automatizar. Lo que Obsidian obliga a hacer a mano
  (por seguridad de la propia app) queda impreso al final con los pasos exactos.
#>
param(
  [string]$VaultPath = "$HOME\Documents\SecondBrain"
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/Tinch004/second-brain-starter.git"

function Test-Cmd($name) { return [bool](Get-Command $name -ErrorAction SilentlyContinue) }

Write-Host "== Segundo cerebro: instalacion ==" -ForegroundColor Cyan

# 1) git
if (-not (Test-Cmd git)) {
  Write-Host "Instalando git..." -ForegroundColor Yellow
  winget install --id Git.Git -e --silent
} else {
  Write-Host "git ya esta instalado." -ForegroundColor Green
}

# 2) Obsidian
$obsidianExe = Get-ChildItem "$env:LOCALAPPDATA\Programs\Obsidian\Obsidian.exe" -ErrorAction SilentlyContinue
if (-not $obsidianExe) {
  Write-Host "Instalando Obsidian..." -ForegroundColor Yellow
  winget install --id Obsidian.Obsidian -e --silent
} else {
  Write-Host "Obsidian ya esta instalado." -ForegroundColor Green
}

# 3) Clonar (o pull si ya existe) el vault starter
if (Test-Path $VaultPath) {
  Write-Host "Ya existe $VaultPath - hago git pull en vez de clonar." -ForegroundColor Yellow
  git -C $VaultPath pull
} else {
  Write-Host "Clonando vault starter en $VaultPath..." -ForegroundColor Yellow
  git clone $RepoUrl $VaultPath
}

# 4) Instalar la skill en Claude Code y Codex (mirroreada)
$skillSrc = Join-Path $VaultPath "skill\update-project-memory"
$claudeSkills = "$HOME\.agents\skills\update-project-memory"
$codexSkills = "$HOME\.codex\skills\update-project-memory"
New-Item -ItemType Directory -Force -Path $claudeSkills | Out-Null
New-Item -ItemType Directory -Force -Path $codexSkills | Out-Null
Copy-Item "$skillSrc\SKILL.md" -Destination $claudeSkills -Force
Copy-Item "$skillSrc\SKILL.md" -Destination $codexSkills -Force
Write-Host "Skill 'update-project-memory' instalada en Claude Code y Codex." -ForegroundColor Green

Write-Host ""
Write-Host "== Automatico listo. Ahora los pasos manuales (Obsidian no deja saltearlos) ==" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Abri Obsidian -> 'Open folder as vault' -> elegi: $VaultPath"
Write-Host ""
Write-Host "2. Configuracion -> Community plugins -> desactiva 'Restricted mode' si esta activo."
Write-Host ""
Write-Host "3. Community plugins -> Browse -> instalar y activar, uno por uno:"
Write-Host "   - 'Local REST API' (autor: coddingtonbear) -- el MCP que conecta Claude Code/Codex al vault"
Write-Host "   - 'Claudian' (autor: Yishen Tu) -- chat con Claude Code/Codex desde dentro de Obsidian"
Write-Host "   - 'Mini Tray' (autor: Damon) -- opcional, minimiza a la bandeja en vez de cerrar"
Write-Host "   - 'Git' (autor: Vinzent03) -- opcional, botones de commit/pull/push desde la UI"
Write-Host "   - 'Dataview' -- opcional, consultas dinamicas sobre tus notas"
Write-Host ""
Write-Host "4. Configuracion del plugin 'Local REST API' -> copia la API key que genera solo."
Write-Host ""
Write-Host "5. En este mismo directorio, corre (con la key del paso 4):"
Write-Host "   .\connect-mcp.ps1 -ApiKey 'TU_API_KEY_ACA' -VaultPath '$VaultPath'"
Write-Host ""
Write-Host "Con eso, Claude Code y Codex ya leen y escriben tu vault. Documentacion completa: SETUP.md"
