# Profile: ops-consulting

[[Profiles-index|_profiles]] ·

Dominio: operaciones/consultoría — procesos, incidentes, vendors. Normalmente sin repo de código: el chequeo de evidencia por `git` se saltea en silencio, como ya contempla el core.

## `type` típicos
- `process` — un proceso operativo que se documenta/mejora con el tiempo.
- `incident` — un incidente puntual, con post-mortem y acción correctiva.
- `vendor` — la relación con un proveedor/vendor externo.
- `operation` — una operación puntual (migración, auditoría, implementación) con alcance y cierre definidos.

## Vocabulario
"Foco actual" = en qué etapa está el proceso/incidente/operación. Una entry de `-decisions.md` digna de registrarse es un cambio de proceso, la elección de un vendor, o una acción correctiva derivada de un incidente — con el motivo y qué alternativa se descartó.

## Evidencia
Sin `git`, la evidencia son tickets, reportes de incidente, contratos/propuestas de vendors que el usuario trae a la sesión — mismo criterio que los demás profiles no-dev: no inventar un dato que no fue mostrado.
