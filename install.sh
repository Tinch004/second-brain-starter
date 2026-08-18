#!/usr/bin/env bash
# Segundo cerebro para Claude Code + Codex, via Obsidian.
# Instala lo que se puede automatizar. Lo que Obsidian obliga a hacer a mano
# (por seguridad de la propia app) queda impreso al final con los pasos exactos.
set -euo pipefail

VAULT_PATH="${1:-$HOME/SecondBrain}"
REPO_URL="https://github.com/Tinch004/second-brain-starter.git"

echo "== Segundo cerebro: instalacion =="

# 1) git
if ! command -v git >/dev/null 2>&1; then
  echo "Instalando git..."
  if command -v brew >/dev/null 2>&1; then brew install git
  elif command -v apt >/dev/null 2>&1; then sudo apt update && sudo apt install -y git
  else echo "No pude instalar git automaticamente — instalalo a mano y volve a correr este script."; exit 1
  fi
else
  echo "git ya esta instalado."
fi

# 2) Obsidian
if command -v brew >/dev/null 2>&1 && ! [ -d "/Applications/Obsidian.app" ]; then
  echo "Instalando Obsidian..."
  brew install --cask obsidian
elif ! command -v obsidian >/dev/null 2>&1 && ! [ -d "/Applications/Obsidian.app" ]; then
  echo "No pude instalar Obsidian automaticamente en esta plataforma — bajalo de https://obsidian.md y segui manual."
fi

# 3) Clonar (o pull si ya existe)
if [ -d "$VAULT_PATH" ]; then
  echo "Ya existe $VAULT_PATH — hago git pull en vez de clonar."
  git -C "$VAULT_PATH" pull
else
  echo "Clonando vault starter en $VAULT_PATH..."
  git clone "$REPO_URL" "$VAULT_PATH"
fi

# 4) Instalar la skill en Claude Code y Codex (mirroreada)
SKILL_SRC="$VAULT_PATH/skill/update-project-memory"
mkdir -p "$HOME/.agents/skills/update-project-memory" "$HOME/.codex/skills/update-project-memory"
cp "$SKILL_SRC/SKILL.md" "$HOME/.agents/skills/update-project-memory/SKILL.md"
cp "$SKILL_SRC/SKILL.md" "$HOME/.codex/skills/update-project-memory/SKILL.md"
cp "$SKILL_SRC/reglas-aprendidas.md" "$HOME/.agents/skills/update-project-memory/reglas-aprendidas.md"
cp "$SKILL_SRC/reglas-aprendidas.md" "$HOME/.codex/skills/update-project-memory/reglas-aprendidas.md"
echo "Skill 'update-project-memory' instalada en Claude Code y Codex."

cat <<EOF

== Automatico listo. Ahora los pasos manuales (Obsidian no deja saltearlos) ==

1. Abri Obsidian -> "Open folder as vault" -> elegi: $VAULT_PATH

2. Configuracion -> Community plugins -> desactiva "Restricted mode" si esta activo.

3. Community plugins -> Browse -> instalar y activar, uno por uno:
   - "Local REST API" (autor: coddingtonbear) -- el MCP que conecta Claude Code/Codex al vault
   - "Claudian" (autor: Yishen Tu) -- chat con Claude Code/Codex desde dentro de Obsidian
   - "Mini Tray" (autor: Damon) -- opcional
   - "Git" (autor: Vinzent03) -- opcional
   - "Dataview" -- opcional

4. Configuracion del plugin "Local REST API" -> copia la API key que genera solo.

5. En este mismo directorio, corre (con la key del paso 4):
   ./connect-mcp.sh "TU_API_KEY_ACA" "$VAULT_PATH"

Con eso, Claude Code y Codex ya leen y escriben tu vault. Documentacion completa: SETUP.md
EOF
