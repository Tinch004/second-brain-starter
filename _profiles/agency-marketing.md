# Profile: agency-marketing

[[Profiles-index|_profiles]] ·

Dominio: agencia/marketing — clientes, campañas, automations, eventos. La mayoría de estos proyectos no son un repo de código: el chequeo de evidencia por `git` (Steps 2-3 de `SKILL.md`) se saltea en silencio, como ya contempla el core para cualquier proyecto no-git.

## `type` típicos
- `client` — la relación completa con un cliente. Puede tener varias campañas como hijas (`parent: "[[<client>-status]]"` en cada campaña).
- `campaign` — una campaña puntual.
- `automation` — un flujo automatizado (nurturing, secuencia de emails) que se sigue por separado de la campaña que lo dispara.
- `event` — un evento puntual (lanzamiento, webinar) con fecha y cierre definidos.

## Vocabulario
"Foco actual" = en qué etapa está la campaña/cliente (briefing, producción, en vivo, reporte). Una entry de `-decisions.md` digna de registrarse es un cambio de dirección creativa, una reasignación de presupuesto, o un pivot de estrategia — no un ajuste menor de copy o de horario de publicación.

## Evidencia
Sin `git`, la evidencia son los materiales que el usuario trae a la sesión: métricas, capturas de dashboards, emails/feedback del cliente. Nunca inventar una métrica o un resultado que no fue mostrado — si algo relevante no está confirmado, se anota como pendiente de confirmar en vez de asumirlo.
