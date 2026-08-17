# 01-Projects

[[Home]] ·

Los proyectos de programación activos que este vault trackea. Cada uno vive en su propia carpeta `01-Projects/<proyecto>/` con `<proyecto>-status.md` (estado actual, punto de entrada), `<proyecto>-todos.md` (tareas activas/bloqueadas/hechas en checkboxes, consultable con Dataview), `<proyecto>-decisions.md` (decisiones de arquitectura) y, si tuvo sesiones de trabajo real, `<proyecto>-context.md` (log de continuidad). Los módulos/componentes reales de cada proyecto son sub-nodos en `<proyecto>/modules/`, indexados desde el propio `-status.md` — no hay un índice separado de módulos, el `-status.md` ya cumple ese rol.

## Proyectos
_(vacío — se llena con el primer proyecto real)_

*Formato del bullet cuando haya proyectos: link al status, descripción corta, y "— repo:"/"remote:" con el path local y la URL entre backticks (omitir ambos si el proyecto no es código; el remote es opcional si el repo todavía no tiene uno). Ej: `- [[mi-app-status|mi-app]] — API + frontend — repo:` path `— remote:` url. Repo y remote acá deben coincidir con los que tiene el propio `<proyecto>-status.md` — el remote en particular es lo que permite detectar el proyecto por `git remote -v` aunque el path local cambie de máquina; ver "Detección del proyecto actual" en la skill.*

## Cómo se agrega uno nuevo
Ver skill [[SKILL|update-project-memory]] — tiene el proceso paso a paso y las reglas de nombre.
