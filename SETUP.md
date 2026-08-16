# Segundo cerebro para Claude Code + Codex — instalación

Memoria persistente compartida entre Claude Code y Codex, guardada como markdown plano en un vault de Obsidian, navegable como un grafo. La idea: no volver a re-explicarle a un agente el estado de un proyecto — se lo lee del vault.

## Instalación de un comando (lo automatizable)

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/Tinch004/second-brain-starter/main/install.ps1 | iex
```

**Mac / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Tinch004/second-brain-starter/main/install.sh | bash
```

Esto instala git y Obsidian si faltan, clona este starter como tu vault, e instala la skill `update-project-memory` en `~/.agents/skills/` y `~/.codex/skills/` (Claude Code y Codex la leen de ahí).

## Lo que NO se puede automatizar (y por qué)

Obsidian, por seguridad, no permite instalar/activar plugins community sin que un humano lo confirme al menos una vez por click — no hay bandera de línea de comandos ni API que lo salte. Esto no es una limitación del script, es una barrera intencional de la app. Son 5 minutos, una sola vez:

### 1. Abrir el vault
Abrí Obsidian → "Open folder as vault" → elegí la carpeta donde se clonó (por default `~/Documents/SecondBrain` en Windows, `~/SecondBrain` en Mac/Linux).

### 2. Habilitar plugins de la comunidad
Configuración (engranaje) → `Community plugins` → si dice "Restricted mode", desactivalo.

### 3. Instalar plugins (Browse → buscar → Install → Enable)

| Plugin | Autor | Para qué |
|---|---|---|
| **Local REST API** | coddingtonbear | El puente MCP real — sin esto, Claude Code/Codex no pueden leer ni escribir el vault. **No es opcional.** |
| **Claudian** | Yishen Tu | Chat con Claude Code/Codex desde adentro de Obsidian, sin terminal. Opcional pero recomendado. |
| **Mini Tray** | Damon | Minimiza a la bandeja del sistema en vez de cerrar del todo. Opcional. |
| **Git** | Vinzent03 | Botones de commit/pull/push desde la UI, en vez de terminal. Opcional pero recomendado si el vault es un repo git. |
| **Dataview** | blacksmithgu | Consultas dinámicas sobre tus propias notas. Opcional. |

### 4. Conseguir la API key
Configuración → plugin `Local REST API` (ya instalado) → copiá la API key que genera solo (no la escribas vos, ya viene generada).

### 5. Conectar el MCP a Claude Code y Codex
En la carpeta del vault clonado, con la key del paso 4:

```powershell
# Windows
.\connect-mcp.ps1 -ApiKey "TU_KEY" -VaultPath "C:\ruta\a\tu\vault"
```
```bash
# Mac/Linux
./connect-mcp.sh "TU_KEY" "/ruta/a/tu/vault"
```

### 6. Probar
Sesión nueva de Claude Code o Codex, en cualquier proyecto: *"Leé el Home del vault de Obsidian y contame qué encontrás."* Si responde con la estructura real del vault, quedó conectado.

## Cómo se usa día a día

- **No hay comandos que memorizar.** Al terminar una sesión de trabajo real, el agente actualiza el vault solo (skill `update-project-memory` — lee `skill/update-project-memory/SKILL.md` en este repo para el detalle completo de reglas).
- Cada proyecto que trackees necesita, en su propio repo, un `AGENTS.md` (con `CLAUDE.md` como symlink al mismo archivo) que diga "la memoria vive en el vault, leer `<VAULT_PATH>/01-Projects/<proyecto>/<proyecto>-status.md` antes de tocar nada".
- El vault mismo puede ser (recomendado) su propio repo git — así lo tenés en más de una máquina y con backup real. `git init`, creá un repo privado en tu cuenta, `git remote add origin ...`, primer commit. La skill ya trae las reglas de pull-antes-de-leer y commit+push-al-guardar.

## Estructura de este starter

```
Home.md                  — hub, punto de entrada
00-Inbox/                — captura rápida sin clasificar
01-Projects/              — tus proyectos, cada uno con su -status.md/-decisions.md/-context.md
02-Skills/                — agent skills reales, agrupadas por dominio
03-Resources/             — referencias, técnicas reutilizables del agente
04-Archive/               — proyectos cerrados
_templates/                — plantillas para proyecto nuevo
_raw/                      — fuente cruda antes de compilar en una nota
AGENTS.md / CLAUDE.md      — contexto de agente para el vault mismo
skill/update-project-memory/SKILL.md  — la skill a instalar en tus agentes
```

Todo vacío a propósito — se llena con tu primer proyecto real, no con datos de ejemplo.
