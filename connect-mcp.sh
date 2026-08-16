#!/usr/bin/env bash
# Corre esto DESPUES de instalar y activar el plugin "Local REST API" en Obsidian,
# con la API key que ese plugin genera en su configuracion.
set -euo pipefail

API_KEY="${1:?Uso: ./connect-mcp.sh TU_API_KEY [VAULT_PATH] [PORT]}"
VAULT_PATH="${2:-$HOME/SecondBrain}"
PORT="${3:-27123}"
MCP_URL="http://127.0.0.1:${PORT}/mcp"

echo "== Conectando MCP del vault a Claude Code y Codex =="

# Claude Code
if command -v claude >/dev/null 2>&1; then
  claude mcp remove obsidian-vault >/dev/null 2>&1 || true
  claude mcp add --scope user --transport http obsidian-vault "$MCP_URL" --header "Authorization: Bearer $API_KEY"
  echo "Claude Code: conectado."
else
  echo "Claude Code CLI no encontrado en PATH — salteado."
fi

# Codex
CODEX_CONFIG="$HOME/.codex/config.toml"
if [ -f "$CODEX_CONFIG" ]; then
  if grep -q "\[mcp_servers.obsidian-vault\]" "$CODEX_CONFIG"; then
    echo "Codex: ya tenia una entrada 'obsidian-vault' en config.toml — no la piso. Editala a mano si hace falta cambiar la key."
  else
    printf '\n[mcp_servers.obsidian-vault]\nurl = "%s"\nhttp_headers = { "Authorization" = "Bearer %s" }\n' "$MCP_URL" "$API_KEY" >> "$CODEX_CONFIG"
    echo "Codex: conectado ($CODEX_CONFIG actualizado)."
  fi
else
  echo "No existe $CODEX_CONFIG todavia — Codex no esta instalado/inicializado en esta maquina. Salteado."
fi

echo ""
echo "Listo. Abri una sesion nueva de Claude Code o Codex apuntando a un proyecto, y proba: 'lee el Home del vault y decime que hay'."
