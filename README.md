# Segundo cerebro para Claude Code + Codex

Memoria persistente, compartida entre agentes, guardada como markdown plano en un vault de Obsidian — navegable como un grafo, no como una pila de archivos sueltos.

## El problema que resuelve

Cada sesión nueva de un agente de código arranca en cero: o le reexplicás el proyecto de nuevo, o el agente se pone a explorar el repo entero para reconstruir contexto que ya tenía la sesión anterior. Las dos cuestan tiempo y tokens. Y si usás Claude Code un día y Codex al siguiente, ninguno de los dos sabe lo que hizo el otro.

Este starter resuelve eso con una idea simple: la memoria no vive en la conversación ni en un repo de código — vive en un vault de Obsidian, conectado por links reales (no carpetas sueltas), que ambos agentes leen y escriben a través del mismo MCP.

## Qué te da

- **Vault en PARA** (Proyectos / Skills / Recursos / Archivo / Inbox) — estructura chata, nombres únicos, pensada para que un agente encuentre algo sin tener que razonar de más, no para que se vea linda.
- **Una skill** (`update-project-memory`) que le dice al agente cuándo guardar memoria, cómo nombrar archivos, cuándo actuar solo y cuándo preguntar — y que se va agrandando sola con cada decisión nueva que tomes, en una sección "Reglas aprendidas" append-only.
- **Cross-agente de verdad**: la misma skill mirroreada para Claude Code y Codex, el mismo vault conectado por MCP a los dos — no hay que elegir uno.
- **Git incluido**: el vault es su propio repo, con las reglas de pull-antes-de-leer y commit+push-al-guardar ya escritas en la skill — para que dos agentes (o dos máquinas) trabajando en paralelo no se pisen.
- **`_raw/`**: guarda la fuente cruda antes de compilarla en una nota — nunca perdés el original.
- **Instalación de un comando** para todo lo que se puede automatizar; los 5 clicks que Obsidian obliga a hacer a mano (por seguridad de la propia app, no hay forma de saltearlos) quedan documentados paso a paso.

## Filosofía — en qué se diferencia de otros starters parecidos

Hay proyectos más grandes y con más funcionalidad para esto (comandos explícitos, wikis organizadas por tipo de entidad, boards Kanban). Este es deliberadamente más chico:

- **Implícito, no por comandos** — el agente reconoce cuándo guardar memoria por el contexto de la conversación, vos no tenés que acordarte de invocar nada.
- **PARA por función, no wiki por tipo de entidad** — menos elegante en el papel, más rápido de recorrer para un agente que tiene que decidir "¿esto es un proyecto, una skill, o un recurso?" en una sola pasada.
- **Pocas piezas móviles** — menos superficie para que algo quede inconsistente sin que nadie lo note.

No es "mejor" en abstracto — es la forma que funcionó bien iterando esto en la práctica, no la que suena más completa en una lista de features.

## Instalación

**Windows:**
```powershell
irm https://raw.githubusercontent.com/Tinch004/second-brain-starter/main/install.ps1 | iex
```

**Mac / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/Tinch004/second-brain-starter/main/install.sh | bash
```

Guía completa, con los pasos manuales de Obsidian explicados uno por uno: **[SETUP.md](./SETUP.md)**.

## Estructura

```
Home.md                                — hub, punto de entrada
00-Inbox/                              — captura rápida sin clasificar
01-Projects/                           — tus proyectos
02-Skills/                             — agent skills, agrupadas por dominio
03-Resources/                          — referencias y técnicas reutilizables
04-Archive/                            — proyectos cerrados
_templates/                            — plantillas para proyecto nuevo
_raw/                                  — fuente cruda antes de compilar
AGENTS.md / CLAUDE.md                  — contexto de agente del vault mismo
skill/update-project-memory/SKILL.md   — la skill a instalar en tus agentes
```

Todo arranca vacío — se llena con tu primer proyecto real, no con datos de ejemplo.

## Licencia

MIT — usalo, modificalo, pasáselo a quien quieras.
