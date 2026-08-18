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
- **Genuinamente ambiguo o sin precedente** (ej: no está claro si algo es un proyecto nuevo, un módulo, o solo una nota suelta; o el material tocaría una convención que no existe todavía) → hacer **una** pregunta corta y puntual, no un cuestionario. En cuanto el usuario responde, la resolución se agrega a **[[reglas-aprendidas|reglas-aprendidas.md]]** (no acá — ver sección "Reglas aprendidas" más abajo) — la pregunta no debería volver a hacerse.
- Nunca preguntar por cosas que ya están resueltas en este archivo o en `Home.md` / los `-status.md` existentes — leerlos primero.

## Material crudo entregado por el usuario (sin GraphRAG ni pipeline aparte)

Si el usuario entrega documentación cruda (specs, PDFs de texto, notas pegadas) para un proyecto ya trackeado:

1. **Guardar la fuente tal cual primero**, sin editar, en `_raw/<proyecto>/<archivo-original>` — antes de compilar nada. Si es texto pegado sin archivo de origen, guardarlo igual como `.md`/`.txt` ahí. No se pierde el original una vez compilado, queda disponible para re-verificar o re-compilar distinto más adelante sin depender de esta sesión. Excepción: si el material trae secretos reales, redactarlos antes de guardar — ni siquiera en `_raw/` (que se guarda tal cual, sin revisión) quedan secretos reales. El CI los bloquea igual, pero no depender de eso: redactar en el momento de guardar.
2. Leerla directamente, extraer lo que corresponda a `-status.md` / `-context.md` / `-decisions.md` / notas de módulo según el contenido, y escribir siguiendo las mismas reglas de nombre y estructura que el resto del vault — no hace falta ninguna herramienta de extracción automática para esto, es lectura + criterio.
3. La nota compilada referencia de vuelta al archivo en `_raw/` (ej: "Fuente: `_raw/<proyecto>/<archivo>`"), para que quede trazable de dónde salió.

Esto deja de alcanzar cuando el volumen es tan grande (decenas/cientos de documentos de una sola vez) que no entra en una lectura directa — evaluar herramienta de indexado en ese momento, no antes.

## File naming (hard rule)

Every project's files live in `<VAULT_PATH>/01-Projects/<project>/` and are named **`<project>-status.md`**, **`<project>-todos.md`**, **`<project>-context.md`**, **`<project>-decisions.md`** — never the bare template names (`_status.md`, `todos.md`, `context.md`, `decisions.md`). The project-prefixed name is what makes each note identifiable on its own in Graph View, the quick switcher, and short `[[links]]` — without it, notes with the same bare name across projects become ambiguous the moment there's more than one project. Module notes live in `<VAULT_PATH>/01-Projects/<project>/modules/` and are named `<project>-<module>.md`.

## Unidad de trabajo y relaciones (Work Graph mínimo)

El core conoce trabajo, no oficios — no asume que toda unidad trackeada es un repo de código. Esto es preparación deliberada para que perfiles futuros (developer, agencia, producto, ops) puedan existir sin tocar esta skill; no implementa esos perfiles ahora.

**`type` (opcional, en el frontmatter de `<project>-status.md`)**: valor libre — `project` (default implícito si el campo no está, así que nada existente se rompe ni hace falta migrar en masa), o cualquier otro (`client`, `campaign`, `product`, `research`, etc.). La skill no necesita conocer de antemano qué significa cada valor; eso es trabajo de un profile futuro, no de esta.

**Relaciones (opcional, mismo frontmatter)**: cinco tipos — `parent`, `depends-on`, `blocked-by`, `related-to`, `supersedes`. Reglas duras:
- Se escriben como wikilinks **entre comillas**, ej. `depends-on: ["[[otro-proyecto-status]]"]` — nunca sin comillas (`[[x]]` sin comillas en YAML se parsea como una lista anidada, no como texto — rompe el campo). `parent` es un único wikilink entre comillas, no una lista (una unidad de trabajo tiene un solo padre).
- **Una sola dirección canónica por relación — nunca la inversa.** Si A `depends-on` B, solo A lo declara; B no declara "depended-on-by" ni nada equivalente de vuelta. Lo mismo para `parent`/`blocked-by`/`supersedes`. Los vecinos inversos se derivan por búsqueda (ver sección siguiente), nunca se duplican a mano — evita que las dos direcciones queden desincronizadas.
- `related-to` es conceptualmente simétrico, pero igual se escribe una sola vez, del lado que lo identificó primero — no hace falta que ambos lados lo declaren. Si dos sesiones en paralelo terminan declarándolo cada una del suyo, es redundante pero inofensivo (no rompe nada, el CI no lo marca) — no hace falta ir a limpiarlo, pero tampoco hace falta duplicarlo a propósito.
- `supersedes` acá es a nivel de unidad de trabajo entera (un proyecto reemplaza a otro) — no confundir con el campo `**Estado:** superseded` de una entry puntual de `-decisions.md`, que es un mecanismo distinto, ya existente, a nivel de decisión individual.
- Como son wikilinks, el CI (`vault-audit.yml`) ya las valida gratis contra el chequeo de links rotos que corre para todo el vault — una relación que apunta a algo inexistente falla el build igual que cualquier otro `[[link]]` roto, sin código nuevo.
- `id` (ya existente) sigue siendo la identidad estable de la unidad — las relaciones apuntan al wikilink del `-status.md` (que resuelve por nombre de archivo), no al `id` crudo.

**Deliberadamente diferido**: un índice compilado (tipo `_index/work-graph.md`) — con el tamaño actual del vault, derivar vecinos por búsqueda ya es barato; se reevalúa si el vault crece lo suficiente para que dejar de serlo. Y "candidate links" (sugerir relaciones no confirmadas por similitud) sigue sin implementarse — ahora que existe "Aprendizaje por experiencia" (ver esa sección) con su lifecycle `candidate`/`confirmed`/`superseded`, la razón ya no es "todavía no hay diseño": es que detectar similitud automáticamente entre notas es la misma **detección semántica automática** que esa sección decide no hacer con un script, en ningún caso. Si dos unidades de trabajo parecen relacionadas, se declara `related-to` a mano cuando el agente o el usuario lo nota — no hay sugerencia automática.

## Backlinks y vecinos (derivados por búsqueda, nunca por índice)

Para responder "¿qué depende de X?", "¿qué bloquea X?", "¿qué está relacionado con X?", "¿qué reemplaza a X?" — nunca abrir cada proyecto del vault para reconstruir el grafo a mano. Es una operación L0/L1 (barata, antes de abrir el `-status.md` completo de un vecino):

1. Lo que X declara de sí mismo ya lo tenés apenas abrís `X-status.md` (L1) — no hace falta buscar para eso.
2. Para los vecinos que apuntan *hacia* X (la dirección inversa, no declarada en ningún lado): buscar `[[X-status` dentro de los campos de relación de todos los `*-status.md` del vault — con el MCP (`search_query`) si está disponible, o `grep -rl '\[\[X-status' 01-Projects --include="*-status.md"` si no. El resultado son los nombres de archivo que la mencionan; recién ahí, si hace falta más detalle que el nombre, se abre el `-status.md` puntual de cada uno — nunca todos de una.

## Memory health (informativo, nunca automático)

Tres chequeos determinísticos, baratos (comparar fechas/campos, no juicio semántico), que corren solos en cada push (`vault-audit.yml`, step "Memory health") y también se pueden revisar a mano en cualquier momento:

- **TODOs estancados**: un ítem de `- [ ]` en "Activos" con fecha de alta de más de 30 días. Ítems sin fecha (legacy, de antes de la convención) se ignoran en silencio, no rompen nada.
- **Status posiblemente viejo**: `Actualizado:` de más de 60 días en `-status.md`.
- **Decisiones sin `**Estado:**`**: una entry de `-decisions.md` que no tiene ese campo — normalmente porque predata la convención (sesión 16/08).

Regla dura: esto **nunca bloquea el build ni corrige nada solo** — a diferencia de los demás steps de la CI (huérfanas/rotos/README/secretos/self-reference/circular, que sí fallan el push), este es puramente informativo (`::notice::`, no `::error::`). Un TODO viejo o un status desactualizado no es un bug — es una señal para que un agente o el usuario lo revise cuando corresponda, nunca algo para tocar sin que se pida. Si un agente ve una señal de estas al orientarse en un proyecto (L1), puede mencionarla en una línea, pero no reescribe `-status.md`/`-todos.md`/`-decisions.md` solo por esto.

**Deliberadamente fuera de este chequeo, en cualquier fase**: detectar contradicciones entre notas, patrones repetidos entre proyectos, y candidatos a convertirse en skill/resource. La sección "Aprendizaje por experiencia" de abajo ya cubre estos tres casos — pero como un **procedimiento que el agente sigue con criterio**, nunca como un chequeo automático de este CI: los tres requieren comparar significado, no fechas ni campos estructurales, y automatizarlos sin ese juicio genera ruido. Este step se queda puramente determinístico a propósito.

## Aprendizaje por experiencia (Experience Learning)

El objetivo no es que el vault recuerde qué pasó (eso ya lo hace `-context.md`) sino que comprima experiencia repetida en reglas cortas y reutilizables, para no repetir errores ni redescubrir lo mismo. Tres niveles, nunca mezclados entre sí:

- **System Learnings** — reglas sobre cómo funciona y se mantiene este mismo second brain (convenciones de nombre, dónde guardar qué, reglas de sync/integridad). Ya existen: es **[[reglas-aprendidas|reglas-aprendidas.md]]**, sin cambios de formato — no se crea un archivo nuevo para esto, ese archivo ya cumplía este rol desde la Fase 2.
- **Workstyle Learnings** — cómo trabaja la persona/equipo (preferencias recurrentes, criterios de decisión, nivel de autonomía esperado). Vive en `03-Resources/Workstyle-learnings.md`, a nivel vault — nunca por proyecto.
- **Domain/Project Learnings** — experiencia concreta de trabajar (errores recurrentes, edge cases, qué funcionó, qué falló, reglas de negocio descubiertas). Vive en `<project>-learnings.md` por proyecto, y en `03-Resources/Domain-learnings.md` cuando un patrón deja de ser particular de un solo proyecto.

### Formato de entry

Usar **[[learning-entry-template|learning-entry-template.md]]**: `**Estado:**`, `**Confidence:**` (low/medium/high), `**Apariciones:**` (cantidad + links a proyecto/sesión que lo evidencian), Patrón/Problema, Solución recomendada, Afecta a. Mismo mecanismo que `-decisions.md`: nunca reescribir una entry vieja completa, solo editar in-place su línea `**Estado:**` cuando cambia.

Estados posibles: `candidate` (default al crear una entry — no hace falta un estado "observed" separado como paso obligatorio: una primera aparición aislada y de bajo impacto simplemente queda en el log de `-context.md` de la sesión, sin crear ninguna entry todavía; `observed` existe como estado explícito solo para el caso real que lo justifique, no por defecto), `confirmed` (evidencia repetida, o el usuario estableció una regla explícita — en ese caso se crea directo en `confirmed`, sin pasar por `candidate`), `superseded por [[link]]` (evidencia nueva contradice a esta entry), `promovido a domain-learning → [[Domain-learnings#...|título]]` (ver promoción abajo).

`Domain-learnings.md` suma un campo `**Dominio:**` justo después de `**Estado:**`. `Workstyle-learnings.md` suma `**Scope:** user` o `**Scope:** team` en su lugar — una preferencia individual y una regla de equipo nunca comparten el mismo scope.

### Promoción project → domain (sin duplicar fuente de verdad)

Cuando el mismo patrón aparece en 2+ proyectos (reconocido por el agente mientras trabaja, no por un scanner — ver la restricción de detección semántica abajo): crear o actualizar la entry en `03-Resources/Domain-learnings.md` con el contenido canónico — Patrón y Solución vigentes viven ahí, y solo ahí, de ahí en adelante. En cada `<project>-learnings.md` de origen, editar in-place su línea `**Estado:**` a `promovido a domain-learning → [[Domain-learnings#{{fecha}} — {{título}}|{{título}}]]` — el resto de esa entry queda intacto, como evidencia histórica de que ese proyecto formó parte de la evidencia; no se borra ni se vuelve a escribir el contenido en dos lugares.

### Antes de crear un learning nuevo

1. Grep el learning relacionado primero (ver capa L1.5 más abajo) — nunca crear una entry sin buscar antes si ya existe una que aplica.
2. Si existe: sumar a `**Apariciones:**` (la evidencia nueva) y ajustar `**Confidence:**` si corresponde. Si la evidencia nueva contradice el contenido de la entry (no solo lo reafirma): no reescribir la vieja — marcarla `superseded por [[...]]` y crear la entry nueva con la versión corregida. Si la contradicción no se puede resolver con la evidencia disponible, preguntar al usuario antes de fijar cualquiera de las dos en `confirmed`.
3. Si no existe: primera aparición aislada y de bajo impacto → alcanza con el log de `-context.md`, no crear nada todavía. Reaparece, o hay evidencia fuerte ya en la primera vez, o el usuario fija una regla explícita → recién ahí se crea la entry (`<project>-learnings.md` se crea la primera vez que ese proyecto tiene un learning real — a diferencia de status/todos/context/decisions, que se crean siempre al trackear el proyecto, este archivo no).

### Auto-mejora de retrieval

Si un agente repite un error que ya estaba documentado en algún learning, no alcanza con volver a guardarlo de nuevo — el problema real fue que la búsqueda de la capa L1.5 no lo encontró. Corregir eso: agregar la keyword/alias que faltaba en el Patrón, o un link desde `-status.md`/`AGENTS.md` que lo hubiera hecho aparecer antes. El sistema tiene que aprender también de sus propios fallos de recuperación, no solo del trabajo.

### Restricción dura (cero detección semántica automática)

Nada de esto se detecta con un script: ni contradicciones, ni patrones repetidos entre proyectos, ni candidatos a skill/resource formal — los tres requieren juicio semántico (comparar significado), y automatizarlos sin ese juicio genera ruido o falsos positivos. Es un procedimiento que el agente sigue con criterio, no un chequeo de CI. Un candidato a Skill/Resource formal (una entry de domain-learning suficientemente genérica y con evidencia fuerte de varios proyectos) se propone al usuario, nunca se crea solo.

Y la restricción de fondo, literal: si un learning no cambiaría una decisión, diagnóstico, implementación o workflow futuro, no se crea — esto no es una colección de tips.

## Detección del proyecto actual

Antes de asumir de qué proyecto se está hablando, resolvé en este orden (parar en el primero que aplique):

1. **El repo del proyecto ya lo declara**: si estás parado en el repo de un proyecto y ese repo tiene `AGENTS.md`/`CLAUDE.md` (creado desde `_templates/project-agents-template.md` en el paso 1 de abajo), ese archivo ya dice explícitamente qué proyecto es y dónde está su carpeta en el vault — no hay nada que inferir.
2. **Contexto de archivo dentro del vault**: si estás trabajando directo sobre el vault (ej. un chat apuntado a esta carpeta) y hay un archivo en contexto bajo `01-Projects/<proyecto>/...`, ese es el proyecto.
3. **Match por cwd o remote**: si no hay ninguna de las dos señales anteriores, comparar el nombre de la carpeta actual o la salida de `git remote -v` contra los paths de repo listados en `01-Projects/Projects-index.md`.
4. **Preguntar una sola vez**: si sigue ambiguo (más de un proyecto matchea, o ninguno), una pregunta corta y puntual — nunca un cuestionario — y no se vuelve a preguntar el resto de la sesión.

## Cómo orientarte (recuperación en capas: L0-L3)

Al entrar a un proyecto ya trackeado, no cargues todo de una — en capas, subiendo solo si la anterior no alcanzó. No hay mecanismo nuevo acá, son los mismos archivos y `[[links]]` que ya existen — lo nuevo es pararse en la capa que ya contesta la pregunta, en vez de leer siempre lo mismo "por las dudas":

- **L0 — Project card**: el bullet de `01-Projects/Projects-index.md` (link, descripción de una línea, `Repo:`/`Remote:` si aplica). Alcanza para "¿existe este proyecto?", "¿cuál es su repo?", "¿qué proyectos hay trackeados?" — sin abrir la carpeta del proyecto siquiera.
- **L1 — `<project>-status.md` + `<project>-todos.md`**: barato, dan la foto actual (foco, bloqueos, tareas activas) en segundos. Punto de partida por default para cualquier tarea sobre un proyecto ya trackeado.
- **L1.5 — Learnings relevantes** (Experience Learning — ver esa sección arriba): **scoped, nunca se cargan los tres tipos de una**:
  - *Project/Domain*: caso por default para cualquier tarea normal sobre el proyecto — grep por palabra clave del problema/tarea actual contra `<project>-learnings.md` (si existe) y `03-Resources/Domain-learnings.md`.
  - *Workstyle*: solo cuando la tarea involucra decidir cómo encarar el trabajo, o hay incertidumbre sobre autonomía/preferencia — no en cada tarea. Grep puntual sobre `03-Resources/Workstyle-learnings.md`, nunca cargarlo entero salvo que haga falta revisar varias entries.
  - *System*: solo para tareas sobre el second brain mismo (crear/cambiar una convención del vault) — ya cubierto por la regla existente de leer `reglas-aprendidas.md` antes de proponer un cambio de estructura, no antes.
- **L2 — `<project>-decisions.md` / `modules/<project>-<module>.md`**: solo si la tarea pregunta por qué se decidió algo, o el detalle de un componente puntual. Para `-decisions.md`, si lo que hace falta es "qué está vigente hoy" (no la historia completa), buscá `**Estado:** vigente` en vez de leer el archivo entero — crece para siempre y la mayoría de las entradas viejas ya están supersedidas.
- **L3 — `<project>-context.md` / `_raw/`**: cold storage, nunca contexto inicial. `-context.md` es más-reciente-primero — leer solo las primeras ~40-60 líneas suele alcanzar (una o dos sesiones); leerlo completo (u ofsetear más) solo si la tarea pide historia vieja específica. `_raw/` no se lee de entrada, solo si una nota compilada lo referencia y hace falta ver la fuente original.

**Reglas de checkpoint:**
- Buscar antes de leer entero: si hay un MCP del vault disponible (ej. `search_query`), usalo para una pregunta puntual en vez de abrir una nota completa; sin MCP, un `grep`/búsqueda de texto puntual cumple el mismo rol.
- Después de cada capa, preguntate si ya alcanza para la tarea actual antes de subir a la siguiente — parar ahí si sí.
- Nunca cargues `-context.md`/`_raw/`/el archivo completo de decisiones "por las dudas": si no hay un motivo concreto de la tarea actual para esa capa, no se abre. Lo mismo aplica a L1.5: cada tipo de learning tiene su propio disparador (arriba) — no se cargan los tres "por las dudas" en cada tarea.

## Steps

0. **`git -C "<VAULT_PATH>" pull` primero, siempre** — antes de leer o escribir cualquier nota, si el vault es un repo git. Sin este paso se puede estar leyendo una versión vieja si otra sesión/máquina ya pusheó cambios.

1. **Find the project's vault folder**: `<VAULT_PATH>/01-Projects/<project>/`. If it doesn't exist yet: create it, copy `<VAULT_PATH>/_templates/status-template.md` → `<project>-status.md`, `decision-entry-template.md` → `<project>-decisions.md`, y `todos-template.md` → `<project>-todos.md`, y crear el `AGENTS.md` del repo del proyecto (symlinked from `CLAUDE.md`) desde `<VAULT_PATH>/_templates/project-agents-template.md` **si todavía no existe**, completando `{{proyecto}}` y la ruta real al vault — no redactarlo a mano cada vez. Si el repo ya tiene un `AGENTS.md` (por ejemplo con reglas propias del proyecto ya completadas en la sección final del template), **no regenerarlo desde cero**: solo tocarlo si le falta apuntar al vault/status correcto, preservando cualquier contenido propio que ya tenga. Este archivo se crea/edita en el repo del proyecto, pero **no se commitea automáticamente ahí** (a diferencia del paso 10, que sí commitea el vault) — nunca se toca el historial de un repo de código ajeno al vault sin que el usuario lo confirme en su propio flujo de trabajo de ese repo. Head every note with `[[Home]] ·` at the top. En `<project>-status.md`, setear el frontmatter `id: <project>` **una sola vez, al crear el proyecto** — ese id queda congelado para siempre, aunque el proyecto se renombre después (archivo, carpeta, título) el `id` no se toca. Es la identidad estable para cualquier referencia externa que necesite sobrevivir un rename; el nombre visible sigue siendo libre de cambiar. Si el proyecto tiene repo de código, sumar debajo del título de `-status.md` dos líneas `Repo:` y `Remote:` con el path local y la URL entre backticks (omitir si no aplica) — es lo que permite matchear el proyecto por cwd/remote en la sección "Detección del proyecto actual". Reflejar el mismo repo y remote en el bullet de `01-Projects/Projects-index.md` (el remote es el dato que sobrevive a un cambio de máquina; el path local no).

   **Si el proyecto ya existe** (tiene código/historia real, recién se empieza a trackear) en vez de crearse de cero — hacer un onboarding acotado, no un escaneo completo del repo:
   - `git -C <repo> log --oneline -20`, `git -C <repo> remote -v`, `git -C <repo> status --short`.
   - Leer `README.md` (si es corto, o sus primeras ~60 líneas) y cualquier doc de handoff legado (`CONTEXT_CLAUDE.md`, `HANDOFF.md` u otro) si existe — tratarlo igual que el resto de esta skill trata un doc de handoff legado (paso 2 de abajo): usarlo como semilla de `-context.md` y avisarle al usuario que hay una copia vieja, para no terminar manteniendo dos.
   - `ls` de primer nivel del repo + manifest de stack si existe (`package.json`, `pyproject.toml`, `__manifest__.py`, etc.) solo para identificar stack — no leerlo entero.
   - Compilar (no transcribir textual) lo relevado en `-status.md` (Foco actual = tema de los últimos commits), una entrada semilla en `-context.md` marcada explícitamente como reconstrucción inicial (no una sesión real), `-todos.md` solo si hay backlog/TODOs existentes para sembrar, y `-decisions.md` solo si el material deja ver una decisión de arquitectura real — nunca inventar decisiones que no estén evidenciadas.
   - Si el repo tiene historia grande, no forzar una lectura completa — un resumen honesto de lo que se alcanzó a revisar (y aviso explícito de que es parcial) es mejor que inflar el contexto tratando de leer todo.

2. **Antes de escribir el log**: si el proyecto es un repo git, correr en el repo del proyecto (nunca en el vault) `git status --short`, `git diff --stat`, `git log -1` para confirmar qué se tocó realmente esta sesión, en vez de confiar solo en el resumen de la conversación. Si no es un repo git (ej. una variante no-código de este patrón de vault), saltear este chequeo en silencio. Si lo que dice la conversación no coincide con git, priorizar la evidencia del repo y avisar la discrepancia en una línea antes de escribir la nota. **Update `<project>-context.md`** (create it from scratch, same naming rule, if the project doesn't have one yet): append the session log at the top (most recent first — never rewrite history), same level of detail the project already used in previous entries. This is the full continuity doc — if the repo still has its own `CONTEXT_CLAUDE.md`/`HANDOFF.md`-style file, that's a leftover from before the vault existed; flag it to the user instead of silently maintaining two copies.

3. **Update `<project>-status.md`**: refresh "Foco actual", "Bloqueado en", "Próximos pasos" (ahora un resumen de 2-3 ítems que apunta a `[[<project>-todos|<project>-todos]]`, no la lista completa), and the "Actualizado" date. Keep it short — this is the quick-glance index, `context.md` has the detail. Mismo chequeo de evidencia del paso anterior aplica acá: "Foco actual"/"Bloqueado en"/"Próximos pasos" reflejan lo que `git status`/`diff` confirma, no solo lo recordado. Si esta sesión identificó una relación real con otra unidad de trabajo (depende de, bloqueado por, relacionado con, reemplaza a), agregarla al frontmatter — ver "Unidad de trabajo y relaciones" arriba: una sola dirección, entre comillas, nunca inventar la inversa del otro lado.

4. **Update `<project>-todos.md`** (crear desde el template si no existe): reconciliar Activos/Bloqueado/Hecho contra lo que realmente pasó esta sesión. Podar ítems de "Hecho" que ya no aportan como referencia — borrar la línea, no archivarla en otro lado (el `git log` del archivo conserva el historial). Confirmar que el resumen de "Próximos pasos" en `-status.md` sigue apuntando acá. Todo ítem `- [ ]` **nuevo** suma la fecha de alta al final: `- [ ] Texto de la tarea (2026-08-17)` — retrocompatible, los ítems viejos sin fecha se leen igual, no hace falta reescribirlos en bloque solo para agregarla. No hace falta usarla todavía (es la base para detectar TODOs estancados más adelante), pero registrarla ahora evita rediseñar el formato después. "Bloqueado" acá es **a nivel tarea** (qué ítem puntual está frenado y por qué) — no confundir con "Bloqueado en" de `-status.md`, que es un resumen de una línea a nivel proyecto y, si aplica, apunta al ítem bloqueado concreto acá en vez de repetir el detalle.

   *Consulta entre proyectos (opcional, requiere el plugin Dataview):* como todos los `-todos.md` usan checkboxes Markdown estándar bajo `01-Projects/`, una nota propia puede listar TODOs abiertos de todos los proyectos con algo como:
   ```dataview
   TASK
   FROM "01-Projects"
   WHERE !completed
   ```

5. **If a real architectural decision was made** (not just a task completed), append an entry to `<project>-decisions.md`. Skip this step if nothing decision-worthy happened — most sessions don't need a new entry. Cada entry lleva un campo `**Estado:**`, arranca en `vigente`. Cuando una decisión nueva reemplaza a una vieja: no reescribir ni reestructurar la entry vieja — editar in-place *solo* su línea `**Estado:**` a `superseded por [[<project>-decisions#{{fecha}} — {{título}}|{{fecha}} — {{título}}]]`. El resto de la entry (Decisión/Por qué/Afecta a) queda intacto. Si una entry vieja predata este campo (no tiene línea `**Estado:**`), agregarla igual al hacer el edit de superseding.

6. **Learnings, si corresponde** (ver "Aprendizaje por experiencia" arriba): si esta sesión resolvió un error real, encontró un patrón que ya vio antes, o confirmó/contradijo una preferencia de trabajo — grepear primero si ya hay un learning relacionado (`<project>-learnings.md`, `Domain-learnings.md`, `Workstyle-learnings.md`, `reglas-aprendidas.md` según corresponda) antes de crear nada nuevo. `<project>-learnings.md` recién se crea la primera vez que ese proyecto amerita un learning real — no antes, a diferencia de los otros archivos de proyecto. Saltear este paso en silencio si la sesión no dejó nada de este tipo — no es obligatorio como status/todos.

7. **Link any skill used** from `<project>-status.md` directo a su nota en `02-Skills/<grupo>/<skill>.md` (ej: `[[code-review|code-review]]`) — no hay una carpeta de "areas" intermedia. Si la skill usada todavía no tiene nota en `02-Skills/`, crearla en el grupo que corresponda (ver regla de agrupación por dominio más abajo) antes de linkearla. Si el proyecto es nuevo, el bullet L0 va en `01-Projects/Projects-index.md` (ver paso 1) — `Home.md` no duplica esa lista, solo enlaza a `Projects-index.md`.

8. **Auto-audit before finishing**: if an MCP for the vault is available (ej. `obsidian-local-rest-api`), run `search_query` for notes with an empty `backlinks` array (orphans) and check that every `[[link]]` written this session resolves (no `unresolvedLinks`) — fix inline before reporting done. Sin MCP, correr el audit manual: comparar nombres de nota contra links extraídos (`comm -23`/`comm -13`). Don't wait for the user to notice disconnected notes. Si esta sesión tocó relaciones de trabajo, chequear a mano lo mismo que valida el CI (ver `vault-audit.yml`): ninguna relación apunta a sí misma, ningún `depends-on` directo forma un ciclo de 2 (A depende de B y B depende de A) — barato de revisar, no hace falta esperar al push.

9. Si el proyecto usa alguna herramienta de indexado de código (tipo Graphify u otra), su output vive en el repo del proyecto, no en el vault — no tocarlo desde acá.

10. **Commit y push del vault mismo**, si el vault es su propio repo git: cerrar con `git -C "<VAULT_PATH>" add <archivo1> <archivo2> ...` **listando exactamente los archivos que tocó esta sesión** — nunca `git add -A`/`add .` a ciegas, porque puede agarrar cambios ajenos hechos desde Obsidian directamente, o de otro agente corriendo en paralelo. Antes de commitear, correr `git status --short` y `git diff --stat` sobre esos archivos puntuales para confirmar que el contenido stageado es el esperado. Commit con mensaje corto describiendo qué proyecto/nota cambió, y `push`. No hace falta preguntar — es el mismo tipo de acción de "guardar" que ya dispara este skill. Nunca force-push acá. Si además de lo tocado por esta sesión el `git status` general muestra otros cambios sin explicar, no los incluyas en este commit — avisar al usuario y dejarlos para que se commiteen aparte.

11. **Si el push del paso 10 es rechazado** (otra sesión/máquina pusheó primero — normal con 2+ agentes trabajando en paralelo): `git pull` (merge normal, no rebase) antes de reintentar el push.
    - Si el merge es automático (git no reporta conflicto): listo, push de nuevo.
    - Si hay conflicto real (`<<<<<<<` en algún archivo): para logs append-only (`-context.md`, `-decisions.md`, `-learnings.md`, `Domain-learnings.md`, `Workstyle-learnings.md`, `reglas-aprendidas.md`) — **conservar las dos entradas**, la del otro lado no se descarta, ambas son agregados válidos al historial. Para archivos que se reescriben (`-status.md`) — **comparar el diff real primero**, no solo la fecha en "Actualizado": la fecha es una heurística, no la prueba. Si el diff muestra que un lado es estrictamente una extensión del otro, priorizar ese; si el contenido diverge de forma no trivial, no elegir a ciegas: avisar al usuario qué dice cada versión y preguntar. `-todos.md` **no** es append-only como `-context.md`/`-decisions.md` (se edita/poda in-place) — ante un conflicto real tratarlo como `-status.md`: comparar el diff real, no asumir "quedarse con las dos versiones" a ciegas (podría resucitar una tarea que el otro lado ya podó).
    - Nunca force-push para "resolver" un conflicto — siempre mergear localmente primero.

## Reglas aprendidas

Log completo (historial append-only, crece para siempre) movido a **[[reglas-aprendidas|reglas-aprendidas.md]]** (mismo directorio) — es contenido L3 (cold storage, ver sección de capas arriba): hace falta antes de proponer un cambio de estructura del vault, no en el uso rutinario de esta skill. No la releas de memoria ni la repitas acá; abrí el archivo cuando haga falta.

## What this skill deliberately does not do

No background monitoring, no capturing of raw conversation transcripts, no automatic triggering outside a real work boundary, explicit save request, or explicit material hand-off. It writes short, human-readable Markdown, and it only asks the user something when there's genuine ambiguity with no precedent recorded above.
