# {{proyecto}} — contexto de agente

La memoria de este proyecto (estado actual, decisiones de arquitectura, continuidad entre sesiones) vive en el vault de Obsidian, **no en este repo** — este archivo solo apunta ahí.

0. **Primero, siempre**: `git -C "{{VAULT_PATH}}" pull` — puede haber cambios de otra sesión o máquina que todavía no llegaron a este checkout del vault.
1. Leer **`{{VAULT_PATH}}/01-Projects/{{proyecto}}/{{proyecto}}-status.md`** antes de tocar nada — es el punto de entrada: foco actual, bloqueos, próximos pasos.
2. Si hace falta más detalle: `{{proyecto}}-todos.md` (tareas activas), `{{proyecto}}-decisions.md` (por qué se decidió algo), `{{proyecto}}-context.md` (log de sesiones anteriores) — en ese orden, solo si la tarea lo exige (ver "carga progresiva" en la skill del paso 3).
3. Al terminar una sesión con trabajo real, actualizar el vault (no crear un doc de handoff en este repo) — la skill `update-project-memory` (`~/.agents/skills/` o `~/.codex/skills/`) tiene el proceso completo.

## Detección de proyecto

Este archivo es justamente la señal de detección: si estás en este repo, el proyecto es **{{proyecto}}** y su carpeta en el vault es la de arriba — no hace falta inferir nada más.

## Reglas duras de este repo

- Ningún doc de handoff nuevo acá (`CONTEXT_CLAUDE.md`, `HANDOFF.md` o similar) — la memoria vive en el vault, un doc paralelo en el repo se desincroniza.
- {{regla específica del proyecto, si aplica}}
