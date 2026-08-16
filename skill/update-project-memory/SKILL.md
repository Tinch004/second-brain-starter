---
name: update-project-memory
description: Use at the end of a work session with real progress on a project, or when the user explicitly asks to save/remember the current state ("guardá esto", "anotá el estado", "dejá una nota de dónde quedamos"), or when the user hands over raw material (docs, specs, pasted text) to be organized into the vault. Writes the session log and current status into the project's folder in the Obsidian vault — the vault is the single source of truth for project memory, never the repo. Do not trigger for trivial sessions with no real progress. "Never run automatically" means: this is not a background observer firing on every message/tool-call — it only fires at one of the three defined boundaries above (real-work session-end, explicit save request, explicit material hand-off), and at those boundaries it acts without waiting for the user to say the magic words.
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

1. **Guardar la fuente tal cual primero**, sin editar, en `_raw/<proyecto>/<archivo-original>` — antes de compilar nada. Si es texto pegado sin archivo de origen, guardarlo igual como `.md`/`.txt` ahí. No se pierde el original una vez compilado, queda disponible para re-verificar o re-compilar distinto más adelante sin depender de esta sesión. Excepción: si el material trae secretos reales, redactarlos antes de guardar — ni siquiera en `_raw/` (que se guarda tal cual, sin revisión) quedan secretos reales. El CI los bloquea igual, pero no depender de eso: redactar en el momento de guardar.
2. Leerla directamente, extraer lo que corresponda a `-status.md` / `-context.md` / `-decisions.md` / notas de módulo según el contenido, y escribir siguiendo las mismas reglas de nombre y estructura que el resto del vault — no hace falta ninguna herramienta de extracción automática para esto, es lectura + criterio.
3. La nota compilada referencia de vuelta al archivo en `_raw/` (ej: "Fuente: `_raw/<proyecto>/<archivo>`"), para que quede trazable de dónde salió.

Esto deja de alcanzar cuando el volumen es tan grande (decenas/cientos de documentos de una sola vez) que no entra en una lectura directa — evaluar herramienta de indexado en ese momento, no antes.

## File naming (hard rule)

Every project's files live in `<VAULT_PATH>/01-Projects/<project>/` and are named **`<project>-status.md`**, **`<project>-todos.md`**, **`<project>-context.md`**, **`<project>-decisions.md`** — never the bare template names (`_status.md`, `todos.md`, `context.md`, `decisions.md`). The project-prefixed name is what makes each note identifiable on its own in Graph View, the quick switcher, and short `[[links]]` — without it, notes with the same bare name across projects become ambiguous the moment there's more than one project. Module notes live in `<VAULT_PATH>/01-Projects/<project>/modules/` and are named `<project>-<module>.md`.

## Cómo orientarte en un proyecto (carga progresiva)

Al entrar a un proyecto ya trackeado, no cargues todo de una — en capas, solo lo que la tarea necesita:

1. Empezá por `<project>-status.md` + `<project>-todos.md` — barato, dan la foto actual en segundos.
2. Seguí los links desde ahí hacia adentro solo si la tarea lo exige: `-context.md` (continuidad de sesiones anteriores), `-decisions.md` (por qué se decidió algo), `modules/<project>-<module>.md` (detalle de un componente puntual).

No hay mecanismo nuevo acá — son los mismos archivos y `[[links]]` que ya existen. La regla es no cargar `-context.md` completo (crece indefinidamente) cuando el status de dos párrafos ya contesta la pregunta.

## Steps

0. **`git -C "<VAULT_PATH>" pull` primero, siempre** — antes de leer o escribir cualquier nota, si el vault es un repo git. Sin este paso se puede estar leyendo una versión vieja si otra sesión/máquina ya pusheó cambios.

1. **Find the project's vault folder**: `<VAULT_PATH>/01-Projects/<project>/`. If it doesn't exist yet: create it, copy `<VAULT_PATH>/_templates/status-template.md` → `<project>-status.md`, `decision-entry-template.md` → `<project>-decisions.md`, y `todos-template.md` → `<project>-todos.md`, y make sure the repo's `AGENTS.md` (symlinked from `CLAUDE.md`) points to this folder. Head every note with `[[Home]] ·` at the top. En `<project>-status.md`, setear el frontmatter `id: <project>` **una sola vez, al crear el proyecto** — ese id queda congelado para siempre, aunque el proyecto se renombre después (archivo, carpeta, título) el `id` no se toca. Es la identidad estable para cualquier referencia externa que necesite sobrevivir un rename; el nombre visible sigue siendo libre de cambiar.

2. **Antes de escribir el log**: si el proyecto es un repo git, correr en el repo del proyecto (nunca en el vault) `git status --short`, `git diff --stat`, `git log -1` para confirmar qué se tocó realmente esta sesión, en vez de confiar solo en el resumen de la conversación. Si no es un repo git (ej. una variante no-código de este patrón de vault), saltear este chequeo en silencio. Si lo que dice la conversación no coincide con git, priorizar la evidencia del repo y avisar la discrepancia en una línea antes de escribir la nota. **Update `<project>-context.md`** (create it from scratch, same naming rule, if the project doesn't have one yet): append the session log at the top (most recent first — never rewrite history), same level of detail the project already used in previous entries. This is the full continuity doc — if the repo still has its own `CONTEXT_CLAUDE.md`/`HANDOFF.md`-style file, that's a leftover from before the vault existed; flag it to the user instead of silently maintaining two copies.

3. **Update `<project>-status.md`**: refresh "Foco actual", "Bloqueado en", "Próximos pasos" (ahora un resumen de 2-3 ítems que apunta a `[[<project>-todos|<project>-todos]]`, no la lista completa), and the "Actualizado" date. Keep it short — this is the quick-glance index, `context.md` has the detail. Mismo chequeo de evidencia del paso anterior aplica acá: "Foco actual"/"Bloqueado en"/"Próximos pasos" reflejan lo que `git status`/`diff` confirma, no solo lo recordado.

4. **Update `<project>-todos.md`** (crear desde el template si no existe): reconciliar Activos/Bloqueado/Hecho contra lo que realmente pasó esta sesión. Podar ítems de "Hecho" que ya no aportan como referencia — borrar la línea, no archivarla en otro lado (el `git log` del archivo conserva el historial). Confirmar que el resumen de "Próximos pasos" en `-status.md` sigue apuntando acá.

5. **If a real architectural decision was made** (not just a task completed), append an entry to `<project>-decisions.md`. Skip this step if nothing decision-worthy happened — most sessions don't need a new entry. Cada entry lleva un campo `**Estado:**`, arranca en `vigente`. Cuando una decisión nueva reemplaza a una vieja: no reescribir ni reestructurar la entry vieja — editar in-place *solo* su línea `**Estado:**` a `superseded por [[<project>-decisions#{{fecha}} — {{título}}|{{fecha}} — {{título}}]]`. El resto de la entry (Decisión/Por qué/Afecta a) queda intacto. Si una entry vieja predata este campo (no tiene línea `**Estado:**`), agregarla igual al hacer el edit de superseding.

6. **Link any skill used** from `<project>-status.md` directo a su nota en `02-Skills/<grupo>/<skill>.md` (ej: `[[code-review|code-review]]`) — no hay una carpeta de "areas" intermedia. Si la skill usada todavía no tiene nota en `02-Skills/`, crearla en el grupo que corresponda (ver regla de agrupación por dominio más abajo) antes de linkearla. Add the project to the list in `Home.md` if it's new.

7. **Auto-audit before finishing**: if an MCP for the vault is available (ej. `obsidian-local-rest-api`), run `search_query` for notes with an empty `backlinks` array (orphans) and check that every `[[link]]` written this session resolves (no `unresolvedLinks`) — fix inline before reporting done. Sin MCP, correr el audit manual: comparar nombres de nota contra links extraídos (`comm -23`/`comm -13`). Don't wait for the user to notice disconnected notes.

8. Si el proyecto usa alguna herramienta de indexado de código (tipo Graphify u otra), su output vive en el repo del proyecto, no en el vault — no tocarlo desde acá.

9. **Commit y push del vault mismo**, si el vault es su propio repo git: cerrar con `git -C "<VAULT_PATH>" add <archivo1> <archivo2> ...` **listando exactamente los archivos que tocó esta sesión** — nunca `git add -A`/`add .` a ciegas, porque puede agarrar cambios ajenos hechos desde Obsidian directamente, o de otro agente corriendo en paralelo. Antes de commitear, correr `git status --short` y `git diff --stat` sobre esos archivos puntuales para confirmar que el contenido stageado es el esperado. Commit con mensaje corto describiendo qué proyecto/nota cambió, y `push`. No hace falta preguntar — es el mismo tipo de acción de "guardar" que ya dispara este skill. Nunca force-push acá. Si además de lo tocado por esta sesión el `git status` general muestra otros cambios sin explicar, no los incluyas en este commit — avisar al usuario y dejarlos para que se commiteen aparte.

10. **Si el push del paso 9 es rechazado** (otra sesión/máquina pusheó primero — normal con 2+ agentes trabajando en paralelo): `git pull` (merge normal, no rebase) antes de reintentar el push.
    - Si el merge es automático (git no reporta conflicto): listo, push de nuevo.
    - Si hay conflicto real (`<<<<<<<` en algún archivo): para logs append-only (`-context.md`, `-decisions.md`, la sección "Reglas aprendidas" de esta skill) — **conservar las dos entradas**, la del otro lado no se descarta, ambas son agregados válidos al historial. Para archivos que se reescriben (`-status.md`) — **comparar el diff real primero**, no solo la fecha en "Actualizado": la fecha es una heurística, no la prueba. Si el diff muestra que un lado es estrictamente una extensión del otro, priorizar ese; si el contenido diverge de forma no trivial, no elegir a ciegas: avisar al usuario qué dice cada versión y preguntar. `-todos.md` **no** es append-only como `-context.md`/`-decisions.md` (se edita/poda in-place) — ante un conflicto real tratarlo como `-status.md`: comparar el diff real, no asumir "quedarse con las dos versiones" a ciegas (podría resucitar una tarea que el otro lado ya podó).
    - Nunca force-push para "resolver" un conflicto — siempre mergear localmente primero.

## Reglas aprendidas

Cada vez que se resuelve algo genuinamente nuevo (una pregunta que no tenía precedente en este archivo), se agrega acá como regla corta, para no volver a preguntarlo. Formato: fecha, regla, por qué. Estas son las reglas de ejemplo con las que arranca este template — a medida que uses tu propio vault, vas a ir agregando las tuyas, específicas de tu contexto:

- **Ejemplo** — Los módulos/componentes reales de un proyecto (código que existe en el repo) son sub-nodos del grafo, no una lista en texto dentro del `-status.md`. Cada módulo real tiene su propia nota en `<project>/modules/<project>-<modulo>.md`, linkeada desde el `-status.md` del proyecto. Por qué: tratarlos como texto plano los deja invisibles en Graph View y pierde la relación de dependencia entre ellos.
- **Ejemplo** — Cuando un proyecto tiene sub-variantes con estados distintos (ej: un componente "en producción" vs. "en desarrollo"), esa distinción va como etiqueta explícita en la nota del módulo, verificada contra el estado real del repo/carpeta — nunca asumida a partir de la prosa de un README.
- **Ejemplo** — Ningún índice de carpeta se llama `README.md`. Se llama `<Carpeta>-index.md` (ej: `Skills-index.md`, `Projects-index.md`) — un nombre único en todo el vault, igual que las notas de proyecto. Por qué: con `README.md` repetido en cada carpeta, el nombre deja de ser único en el grafo/buscador de Obsidian.
- **Ejemplo** — Las skills en `02-Skills/` se agrupan por dominio en subcarpetas (`02-Skills/<grupo>/`), no en lista plana — cada grupo tiene su propio `Skills-<Grupo>-index.md`, linkeado desde `Skills-index.md`. Cuando se instala una skill nueva: decidir a qué grupo pertenece o si amerita un grupo nuevo — nunca agregarla suelta en el índice general.
- **Ejemplo** — Los índices de carpeta nunca hardcodean cuántos elementos hay ("9 skills", "3 proyectos") — esos números quedan desactualizados apenas se agrega uno más. Se cuenta con la lista real, nunca se escribe un número fijo en el texto.
- **Ejemplo** — Cuando el agente descubre una técnica/capacidad reutilizable en la máquina (no memoria de un proyecto, no una skill formal instalada) se anota en `03-Resources/Tecnicas-agente.md`, no se pierde en el chat.
- **Ejemplo** — El vault tiene su propio repo git (privado) para poder clonarlo en otra máquina. Cada vez que este skill escribe algo real, termina con commit + push automático (paso 9). `.gitignore` excluye `.obsidian/plugins/*/data.json` (API keys/claves privadas por-máquina) — si se agrega un plugin nuevo que guarde secretos en otro archivo, agregarlo a mano al `.gitignore`.
- **Ejemplo** — `git pull` va **primero**, siempre, antes de leer o escribir cualquier nota (paso 0) — no solo al guardar. Esto también se agrega al `AGENTS.md` de cada proyecto y al `AGENTS.md` del vault mismo, como paso 0.
- **Ejemplo** — Se sumó `_raw/` (carpeta a nivel vault, mismo tier que `_templates/`): guarda la fuente cruda inmutable antes de compilarla, la nota compilada referencia de vuelta.
- **Ejemplo** — Cada `<project>-status.md` tiene un frontmatter `id: <project>` congelado al crear el proyecto, que nunca cambia — pero el nombre visible (título, archivo, carpeta) sigue libre de cambiar. Resuelve que un rename rompa referencias externas, sin sacrificar legibilidad (nada de UUIDs visibles).
- **Ejemplo** — Además del audit manual (paso 7), un CI (`.github/workflows/vault-audit.yml`) corre el mismo chequeo de huérfanas/links rotos/nombres inválidos en cada push — cubre también un commit hecho a mano desde Obsidian, sin agente de por medio.
- **Ejemplo** — Pedirle una segunda opinión crítica a otro agente (ej. `codex exec` si usás Claude Code, o al revés) sobre una decisión de arquitectura del vault es una técnica válida antes de asentarla — no hace falta que la pida el usuario.
- **2026-08-16** — Cada proyecto suma `<project>-todos.md` (checkboxes Markdown estándar), separado de `-status.md`. Por qué: permite que Dataview consulte tareas abiertas entre proyectos sin infraestructura nueva; "Próximos pasos" pasa a ser un resumen de 2-3 ítems que apunta a la lista completa, para no inflar `-status.md`.
- **2026-08-16** — Orientarse en un proyecto es carga progresiva: `-status.md` + `-todos.md` primero, seguir a `-context.md`/`-decisions.md`/`modules/` solo si la tarea lo exige. Por qué: evita cargar el log completo de sesiones cuando una pregunta corta ya la contesta el status.
- **2026-08-16** — Las entries de `-decisions.md` llevan `**Estado:**` (arranca `vigente`); superseding es un edit in-place de esa sola línea en la entry vieja, nunca una reescritura. Por qué: sin esto no había forma de distinguir vigente de obsoleto sin leer todo el archivo y adivinar por fecha.
- **2026-08-16** — Antes de escribir `-context.md`/`-status.md`, si el proyecto es repo git, se verifica `git status`/`diff --stat`/`log -1` contra lo que dice la conversación (se salta en silencio si no es git). Por qué: el resumen de una sesión puede no coincidir con lo realmente tocado.
- **2026-08-16** — El CI suma detección de secretos de alta confianza (AWS/private keys/GitHub/Slack/Stripe/asignaciones genéricas) en todo `.md` incluyendo `_raw/`, sin allowlist en v1. Por qué: `_raw/` es la zona de mayor riesgo y un secreto commiteado queda en el historial git para siempre — mejor bloquear en CI que confiar en que no se pegue uno.

## What this skill deliberately does not do

No background monitoring, no capturing of raw conversation transcripts, no automatic triggering outside a real work boundary, explicit save request, or explicit material hand-off. It writes short, human-readable Markdown, and it only asks the user something when there's genuine ambiguity with no precedent recorded above.
