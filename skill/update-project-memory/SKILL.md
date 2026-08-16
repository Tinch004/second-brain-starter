---
name: update-project-memory
description: Use at the end of a work session with real progress on a project, or when the user explicitly asks to save/remember the current state ("guardá esto", "anotá el estado", "dejá una nota de dónde quedamos"), or when the user hands over raw material (docs, specs, pasted text) to be organized into the vault. Writes the session log and current status into the project's folder in the Obsidian vault — the vault is the single source of truth for project memory, never the repo. Do not trigger for trivial sessions with no real progress, and never run automatically without a clear session-end, explicit save request, or explicit hand-off of material — this is not a background observer.
---

# Update Project Memory

All project memory (session continuity, current status, architecture decisions) lives in the Obsidian vault at `<VAULT_PATH>` (reemplazá por la ruta real de tu vault — se define una vez al instalar, después queda fija), centralizada y buscable entre proyectos — nunca duplicada en un archivo del repo. Los repos solo tienen `AGENTS.md`/`CLAUDE.md` (orientación estable: stack, estructura, reglas duras) apuntando al vault; nunca crecen su propio doc de handoff.

## When to use

- End of a session where real work happened (features, fixes, architecture decisions) — in **any** tracked project, not just the one you use most. Do this without being asked; it's the default at a real work boundary, not something that waits for "guardá esto".
- The user explicitly asks to save/note the current state.
- The user hands over raw material (a doc, a spec, pasted text, a folder of files) and asks to have it organized into the vault.

Do **not** use this for trivial sessions (a single file read, a quick question) — an unchanged status note is more useful than a noisy one.

## Cuándo actuar solo vs. cuándo preguntar

El objetivo es que el usuario no tenga que dictar rutas ni aclarar qué es cada cosa. Regla de decisión:

- **Patrón ya cubierto por una regla de abajo o por un precedente claro en el vault** (ej: "esto es un módulo nuevo de un proyecto existente", "esto es una decisión de arquitectura", "esto es una actualización de estado") → actuar directo, sin preguntar. Al terminar, avisar en una línea qué se guardó y dónde (path real, no descripción vaga).
- **Genuinamente ambiguo o sin precedente** (ej: no está claro si algo es un proyecto nuevo, un módulo, o solo una nota suelta; o el material tocaría una convención que no existe todavía) → hacer **una** pregunta corta y puntual, no un cuestionario. En cuanto el usuario responde, la resolución se agrega a "Reglas aprendidas" abajo — la pregunta no debería volver a hacerse.
- Nunca preguntar por cosas que ya están resueltas en este archivo o en `Home.md` / los `-status.md` existentes — leerlos primero.

## Material crudo entregado por el usuario (sin GraphRAG ni pipeline aparte)

Si el usuario entrega documentación cruda (specs, PDFs de texto, notas pegadas) para un proyecto ya trackeado:

1. **Guardar la fuente tal cual primero**, sin editar, en `_raw/<proyecto>/<archivo-original>` — antes de compilar nada. Si es texto pegado sin archivo de origen, guardarlo igual como `.md`/`.txt` ahí. No se pierde el original una vez compilado, queda disponible para re-verificar o re-compilar distinto más adelante sin depender de esta sesión.
2. Leerla directamente, extraer lo que corresponda a `-status.md` / `-context.md` / `-decisions.md` / notas de módulo según el contenido, y escribir siguiendo las mismas reglas de nombre y estructura que el resto del vault — no hace falta ninguna herramienta de extracción automática para esto, es lectura + criterio.
3. La nota compilada referencia de vuelta al archivo en `_raw/` (ej: "Fuente: `_raw/<proyecto>/<archivo>`"), para que quede trazable de dónde salió.

Esto deja de alcanzar cuando el volumen es tan grande (decenas/cientos de documentos de una sola vez) que no entra en una lectura directa — evaluar herramienta de indexado en ese momento, no antes.

## File naming (hard rule)

Every project's files live in `<VAULT_PATH>/01-Projects/<project>/` and are named **`<project>-status.md`**, **`<project>-context.md`**, **`<project>-decisions.md`** — never the bare template names (`_status.md`, `context.md`, `decisions.md`). The project-prefixed name is what makes each note identifiable on its own in Graph View, the quick switcher, and short `[[links]]` — without it, notes with the same bare name across projects become ambiguous the moment there's more than one project. Module notes live in `<VAULT_PATH>/01-Projects/<project>/modules/` and are named `<project>-<module>.md`.

## Steps

0. **`git -C "<VAULT_PATH>" pull` primero, siempre** — antes de leer o escribir cualquier nota, si el vault es un repo git. Sin este paso se puede estar leyendo una versión vieja si otra sesión/máquina ya pusheó cambios.

1. **Find the project's vault folder**: `<VAULT_PATH>/01-Projects/<project>/`. If it doesn't exist yet: create it, copy `<VAULT_PATH>/_templates/status-template.md` → `<project>-status.md` and `decision-entry-template.md` → `<project>-decisions.md`, and make sure the repo's `AGENTS.md` (symlinked from `CLAUDE.md`) points to this folder. Head every note with `[[Home]] ·` at the top.

2. **Update `<project>-context.md`** (create it from scratch, same naming rule, if the project doesn't have one yet): append the session log at the top (most recent first — never rewrite history), same level of detail the project already used in previous entries. This is the full continuity doc — if the repo still has its own `CONTEXT_CLAUDE.md`/`HANDOFF.md`-style file, that's a leftover from before the vault existed; flag it to the user instead of silently maintaining two copies.

3. **Update `<project>-status.md`**: refresh "Foco actual", "Bloqueado en", "Próximos pasos", and the "Actualizado" date. Keep it short — this is the quick-glance index, `context.md` has the detail.

4. **If a real architectural decision was made** (not just a task completed), append an entry to `<project>-decisions.md`. Skip this step if nothing decision-worthy happened — most sessions don't need a new entry.

5. **Link any skill used** from `<project>-status.md` directo a su nota en `02-Skills/<grupo>/<skill>.md` (ej: `[[code-review|code-review]]`) — no hay una carpeta de "areas" intermedia. Si la skill usada todavía no tiene nota en `02-Skills/`, crearla en el grupo que corresponda (ver regla de agrupación por dominio más abajo) antes de linkearla. Add the project to the list in `Home.md` if it's new.

6. **Auto-audit before finishing**: if an MCP for the vault is available (ej. `obsidian-local-rest-api`), run `search_query` for notes with an empty `backlinks` array (orphans) and check that every `[[link]]` written this session resolves (no `unresolvedLinks`) — fix inline before reporting done. Sin MCP, correr el audit manual: comparar nombres de nota contra links extraídos (`comm -23`/`comm -13`). Don't wait for the user to notice disconnected notes.

7. Si el proyecto usa alguna herramienta de indexado de código (tipo Graphify u otra), su output vive en el repo del proyecto, no en el vault — no tocarlo desde acá.

8. **Commit y push del vault mismo**, si el vault es su propio repo git: cerrar con `git -C "<VAULT_PATH>" add -A`, commit con mensaje corto describiendo qué proyecto/nota cambió, y `push`. No hace falta preguntar — es el mismo tipo de acción de "guardar" que ya dispara este skill. Nunca force-push acá. Si el `git status` muestra algo raro no relacionado a esta sesión, avisar antes de commitear en vez de incluirlo sin mirar.

9. **Si el push del paso 8 es rechazado** (otra sesión/máquina pusheó primero — normal con 2+ agentes trabajando en paralelo): `git pull` (merge normal, no rebase) antes de reintentar el push.
   - Si el merge es automático (git no reporta conflicto): listo, push de nuevo.
   - Si hay conflicto real (`<<<<<<<` en algún archivo): para logs append-only (`-context.md`, `-decisions.md`, la sección "Reglas aprendidas" de esta skill) — **conservar las dos entradas**, la del otro lado no se descarta, ambas son agregados válidos al historial. Para archivos que se reescriben (`-status.md`) — mirar la fecha en "Actualizado" de cada lado y priorizar el más reciente, pero si el contenido real difiere de forma no trivial no elegir a ciegas: avisar al usuario qué dice cada versión y preguntar.
   - Nunca force-push para "resolver" un conflicto — siempre mergear localmente primero.

## Reglas aprendidas

Cada vez que se resuelve algo genuinamente nuevo (una pregunta que no tenía precedente en este archivo), se agrega acá como regla corta, para no volver a preguntarlo. Formato: fecha, regla, por qué. Estas son las reglas de ejemplo con las que arranca este template — a medida que uses tu propio vault, vas a ir agregando las tuyas, específicas de tu contexto:

- **Ejemplo** — Los módulos/componentes reales de un proyecto (código que existe en el repo) son sub-nodos del grafo, no una lista en texto dentro del `-status.md`. Cada módulo real tiene su propia nota en `<project>/modules/<project>-<modulo>.md`, linkeada desde el `-status.md` del proyecto. Por qué: tratarlos como texto plano los deja invisibles en Graph View y pierde la relación de dependencia entre ellos.
- **Ejemplo** — Cuando un proyecto tiene sub-variantes con estados distintos (ej: un componente "en producción" vs. "en desarrollo"), esa distinción va como etiqueta explícita en la nota del módulo, verificada contra el estado real del repo/carpeta — nunca asumida a partir de la prosa de un README.
- **Ejemplo** — Ningún índice de carpeta se llama `README.md`. Se llama `<Carpeta>-index.md` (ej: `Skills-index.md`, `Projects-index.md`) — un nombre único en todo el vault, igual que las notas de proyecto. Por qué: con `README.md` repetido en cada carpeta, el nombre deja de ser único en el grafo/buscador de Obsidian.
- **Ejemplo** — Las skills en `02-Skills/` se agrupan por dominio en subcarpetas (`02-Skills/<grupo>/`), no en lista plana — cada grupo tiene su propio `Skills-<Grupo>-index.md`, linkeado desde `Skills-index.md`. Cuando se instala una skill nueva: decidir a qué grupo pertenece o si amerita un grupo nuevo — nunca agregarla suelta en el índice general.
- **Ejemplo** — Los índices de carpeta nunca hardcodean cuántos elementos hay ("9 skills", "3 proyectos") — esos números quedan desactualizados apenas se agrega uno más. Se cuenta con la lista real, nunca se escribe un número fijo en el texto.
- **Ejemplo** — Cuando el agente descubre una técnica/capacidad reutilizable en la máquina (no memoria de un proyecto, no una skill formal instalada) se anota en `03-Resources/Tecnicas-agente.md`, no se pierde en el chat.
- **Ejemplo** — El vault tiene su propio repo git (privado) para poder clonarlo en otra máquina. Cada vez que este skill escribe algo real, termina con commit + push automático (paso 8). `.gitignore` excluye `.obsidian/plugins/*/data.json` (API keys/claves privadas por-máquina) — si se agrega un plugin nuevo que guarde secretos en otro archivo, agregarlo a mano al `.gitignore`.
- **Ejemplo** — `git pull` va **primero**, siempre, antes de leer o escribir cualquier nota (paso 0) — no solo al guardar. Esto también se agrega al `AGENTS.md` de cada proyecto y al `AGENTS.md` del vault mismo, como paso 0.
- **Ejemplo** — Se sumó `_raw/` (carpeta a nivel vault, mismo tier que `_templates/`): guarda la fuente cruda inmutable antes de compilarla, la nota compilada referencia de vuelta.

## What this skill deliberately does not do

No background monitoring, no capturing of raw conversation transcripts, no automatic triggering outside a real work boundary, explicit save request, or explicit material hand-off. It writes short, human-readable Markdown, and it only asks the user something when there's genuine ambiguity with no precedent recorded above.
