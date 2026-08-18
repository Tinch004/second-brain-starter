# Profile: developer

[[Profiles-index|_profiles]] ·

Dominio: software con repo de código. Es el caso que el core ya cubre por default hoy — nada de este archivo es un mecanismo nuevo, es documentar explícitamente lo que ya pasa sin declarar ningún `profile`.

## `type` típicos
- `project` (default implícito si `type` no está declarado) — el repo/producto entero.
- `module` — un componente/subsistema real dentro de un proyecto. Ya existe como mecanismo propio: `modules/<project>-<modulo>.md`, ver `SKILL.md`.
- `integration` — una integración puntual con un servicio/API externo, cuando amerita seguimiento separado del módulo que la usa.

## Vocabulario
"Foco actual" = qué se tocó en el código esta sesión (feature, fix, refactor). Una entry de `-decisions.md` digna de registrarse es una decisión de arquitectura (elegir una librería, un patrón, una migración) — no un fix puntual sin alternativas evaluadas.

## Evidencia
Ya cubierto por el core sin necesitar este profile: si el proyecto es un repo git, `git status --short`/`git diff --stat`/`git log -1` antes de escribir `-status.md`/`-context.md` (Steps 2-3 de `SKILL.md`) — prioridad sobre lo que dice la conversación si no coinciden.
