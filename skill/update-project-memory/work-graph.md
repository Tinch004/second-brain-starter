# Work Graph — unidad de trabajo y relaciones

Detalle completo de `type`, las 5 relaciones opcionales, y cómo derivar backlinks/vecinos — referenciado desde `SKILL.md`. Se lee al declarar o buscar una relación real, no en el flujo rutinario de guardar memoria.

## Unidad de trabajo (`type`)

El core conoce trabajo, no oficios — no asume que toda unidad trackeada es un repo de código. Esto es preparación deliberada para que perfiles futuros (developer, agencia, producto, ops) puedan existir sin tocar esta skill.

**`type` (opcional, en el frontmatter de `<project>-status.md`)**: valor libre — `project` (default implícito si el campo no está, así que nada existente se rompe ni hace falta migrar en masa), o cualquier otro (`client`, `campaign`, `product`, `research`, etc.). La skill no necesita conocer de antemano qué significa cada valor; eso es trabajo de un profile (ver `_profiles/`).

## Relaciones

Opcional, mismo frontmatter — cinco tipos: `parent`, `depends-on`, `blocked-by`, `related-to`, `supersedes`. Reglas duras:
- Se escriben como wikilinks **entre comillas**, ej. `depends-on: ["[[otro-proyecto-status]]"]` — nunca sin comillas (`[[x]]` sin comillas en YAML se parsea como una lista anidada, no como texto — rompe el campo). `parent` es un único wikilink entre comillas, no una lista (una unidad de trabajo tiene un solo padre).
- **Una sola dirección canónica por relación — nunca la inversa.** Si A `depends-on` B, solo A lo declara; B no declara "depended-on-by" ni nada equivalente de vuelta. Lo mismo para `parent`/`blocked-by`/`supersedes`. Los vecinos inversos se derivan por búsqueda (ver abajo), nunca se duplican a mano.
- `related-to` es conceptualmente simétrico, pero igual se escribe una sola vez, del lado que lo identificó primero — no hace falta que ambos lados lo declaren. Redundante pero inofensivo si pasa, no hace falta limpiarlo.
- `supersedes` acá es a nivel de unidad de trabajo entera (un proyecto reemplaza a otro) — no confundir con `**Estado:** superseded` de una entry puntual de `-decisions.md`, mecanismo distinto a nivel de decisión individual.
- Como son wikilinks, el CI (`vault-audit.yml`) ya las valida gratis contra el chequeo de links rotos — una relación que apunta a algo inexistente falla el build igual que cualquier `[[link]]` roto.
- `id` sigue siendo la identidad estable de la unidad — las relaciones apuntan al wikilink del `-status.md`, no al `id` crudo.

## Backlinks y vecinos (derivados por búsqueda, nunca por índice)

Para responder "¿qué depende de X?", "¿qué bloquea X?", "¿qué está relacionado con X?", "¿qué reemplaza a X?" — nunca abrir cada proyecto del vault para reconstruir el grafo a mano:

1. Lo que X declara de sí mismo ya lo tenés apenas abrís `X-status.md`.
2. Para los vecinos que apuntan *hacia* X (dirección inversa, no declarada en ningún lado): buscar `[[X-status` dentro de los campos de relación de todos los `*-status.md` — con el MCP (`search_query`) si está disponible, o `grep -rl '\[\[X-status' 01-Projects --include="*-status.md"` si no. Recién ahí, si hace falta más detalle, se abre el `-status.md` puntual de cada uno.

## Deliberadamente diferido

Un índice compilado (tipo `_index/work-graph.md`) — con el tamaño actual del vault, derivar vecinos por búsqueda ya es barato; se reevalúa si el vault crece lo suficiente para que dejar de serlo. Y "candidate links" (sugerir relaciones no confirmadas por similitud) sigue sin implementarse — es la misma detección semántica automática que `learnings.md` decide no hacer con un script, en ningún caso. Si dos unidades de trabajo parecen relacionadas, se declara `related-to` a mano cuando el agente o el usuario lo nota.
