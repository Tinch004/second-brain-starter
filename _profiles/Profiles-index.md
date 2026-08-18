# _profiles

[[Home]] ·

Guías de vocabulario por dominio — **no cambian ningún mecanismo del core**: siguen siendo `-status.md`/`-todos.md`/`-context.md`/`-decisions.md`/`-learnings.md` opcional, los mismos Steps, el mismo CI. "El core conoce trabajo, el profile conoce el oficio" (ver decisión de la Fase 3 en `reglas-aprendidas.md`). Un profile documenta solo tres cosas para su dominio: valores típicos de `type`, qué cuenta como "Foco actual"/decisión digna de registrar, y de dónde sale la evidencia cuando no hay repo de código para verificar con `git`.

Se consultan de forma puntual (ver "Perfiles de trabajo" en la skill [[SKILL|update-project-memory]]) — nunca se cargan los 4 de una, y declarar un `profile:` en el frontmatter de `-status.md` es opcional: si no está, el comportamiento genérico del core sigue exactamente igual.

## Perfiles iniciales
- [[developer|developer]] — software con repo (el caso que el core ya cubre por default hoy).
- [[agency-marketing|agency-marketing]] — clientes, campañas, automations, eventos.
- [[product|product]] — producto, features, experimentos, research.
- [[ops-consulting|ops-consulting]] — procesos, incidentes, vendors, operaciones.

## Regla para perfiles nuevos
Un profile nunca puede: renombrar una sección del core (`-status.md` sigue teniendo "Foco actual" en cualquier dominio), agregar un tipo de archivo nuevo por proyecto, ni cambiar los Steps o el CI. Si un dominio necesita algo de eso de verdad, es señal de que el core está incompleto — se extiende el core (como ya pasó con `type` en la Fase 3), nunca se bifurca el mecanismo por perfil.
