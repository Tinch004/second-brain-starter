---
id: {{id-congelado-al-crear-el-proyecto-nunca-cambia}}
# type: project  # opcional, default implícito "project" si se omite — valor libre (client, campaign, product, research, etc.)
# profile: developer  # opcional, sin default — solo vocabulario, ver `_profiles/` y "Perfiles de trabajo" en la skill. No declararlo no cambia nada.
# Relaciones opcionales — wikilinks SIEMPRE entre comillas, sin comillas rompe el YAML. Una sola dirección, nunca la inversa. Ver "Unidad de trabajo y relaciones" en la skill.
# depends-on: `["[[otro-proyecto-status]]"]`
# blocked-by: `["[[otro-proyecto-status]]"]`
# related-to: `["[[otro-proyecto-status]]"]`
# supersedes: `["[[otro-proyecto-status]]"]`
# parent: `"[[otro-proyecto-status]]"`
---

# {{proyecto}} — estado

Actualizado: {{fecha}}

*Si el proyecto es un repo de código, sumar acá dos líneas `Repo:` y `Remote:` con el path local y la URL entre backticks (omitir si no aplica) — es lo que permite detectar el proyecto actual por cwd/remote, ver sección "Detección del proyecto actual" de la skill.*

## Foco actual
-

## Bloqueado en
-

## Próximos pasos
-

*Resumen corto (2-3 ítems) — la lista completa vive en `<project>-todos.md`.*

## Doc de continuidad del repo
Si el proyecto ya tiene su propio archivo de handoff (ej. `CONTEXT_CLAUDE.md`, `HANDOFF.md`), esta nota NO lo duplica — apunta a él. Esta nota es el índice corto que el vault necesita para saber, entre proyectos, dónde está cada uno sin abrir cada repo.

Ruta: `{{ruta-doc-continuidad}}`
