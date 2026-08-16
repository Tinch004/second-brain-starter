#Requires -Version 5.1
<#
  Corre esto DESPUES de instalar y activar el plugin "Local REST API" en Obsidian,
  con la API key que ese plugin genera en su configuracion.
#>
param(
  [Parameter(Mandatory = $true)][string]$ApiKey,
  [string]$VaultPath = "$HOME\Documents\SecondBrain",
  [int]$Port = 27123
)

$ErrorActionPreference = "Stop"
$mcpUrl = "http://127.0.0.1:$Port/mcp"

Write-Host "== Conectando MCP del vault a Claude Code y Codex ==" -ForegroundColor Cyan

# Claude Code
if (Get-Command claude -ErrorAction SilentlyContinue) {
  try { claude mcp remove obsidian-vault } catch {}
  claude mcp add --scope user --transport http obsidian-vault $mcpUrl --header "Authorization: Bearer $ApiKey"
  Write-Host "Claude Code: conectado." -ForegroundColor Green
} else {
  Write-Host "Claude Code CLI no encontrado en PATH - salteado. Instalalo y volve a correr este script si lo necesitas." -ForegroundColor Yellow
}

# Codex
$codexConfig = "$HOME\.codex\config.toml"
if (Test-Path $codexConfig) {
  $content = Get-Content $codexConfig -Raw
  if ($content -match "\[mcp_servers\.obsidian-vault\]") {
    Write-Host "Codex: ya tenia una entrada 'obsidian-vault' en config.toml - no la piso. Edita $codexConfig a mano si haces falta cambiar la key." -ForegroundColor Yellow
  } else {
    Add-Content $codexConfig "`n[mcp_servers.obsidian-vault]`nurl = `"$mcpUrl`"`nhttp_headers = { `"Authorization`" = `"Bearer $ApiKey`" }`n"
    Write-Host "Codex: conectado ($codexConfig actualizado)." -ForegroundColor Green
  }
} else {
  Write-Host "No existe $codexConfig todavia - Codex no esta instalado/inicializado en esta maquina. Salteado." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Listo. Abri una sesion nueva de Claude Code o Codex apuntando a un proyecto, y proba: 'lee el Home del vault y decime que hay'." -ForegroundColor Cyan
