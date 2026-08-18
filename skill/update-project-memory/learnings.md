# Learnings — Aprendizaje por experiencia

Detalle completo del sistema de Experience Learning — referenciado desde `SKILL.md`. Se lee al resolver un error real, reconocer un patrón repetido, o crear/promover una entry (Step 6), no en el flujo rutinario de guardar memoria.

El objetivo no es que el vault recuerde qué pasó (eso ya lo hace `-context.md`) sino que comprima experiencia repetida en reglas cortas y reutilizables, para no repetir errores ni redescubrir lo mismo.

## Tres niveles, nunca mezclados

- **System Learnings** — reglas sobre cómo funciona y se mantiene este mismo second brain. Ya existen: es **[[reglas-aprendidas|reglas-aprendidas.md]]**, sin cambios de formato — no se crea un archivo nuevo para esto.
- **Workstyle Learnings** — cómo trabaja la persona/equipo. Vive en `03-Resources/Workstyle-learnings.md`, a nivel vault — nunca por proyecto.
- **Domain/Project Learnings** — experiencia concreta de trabajar (errores recurrentes, edge cases, qué funcionó, qué falló). Vive en `<project>-learnings.md` por proyecto, y en `03-Resources/Domain-learnings.md` cuando un patrón deja de ser particular de un solo proyecto.

## Formato de entry

Usar **[[learning-entry-template|learning-entry-template.md]]**: `**Estado:**`, `**Confidence:**` (low/medium/high), `**Apariciones:**` (cantidad + links de evidencia), Patrón/Problema, Solución recomendada, Afecta a. Mismo mecanismo que `-decisions.md`: nunca reescribir una entry vieja completa, solo editar in-place su línea `**Estado:**` cuando cambia.

Estados: `candidate` (default al crear — una primera aparición aislada y de bajo impacto simplemente queda en `-context.md`, sin crear entry; `observed` existe solo para el caso real que lo justifique, no por defecto), `confirmed` (evidencia repetida, o regla explícita del usuario — puede saltear `candidate`), `superseded por [[link]]` (evidencia nueva contradice), `promovido a domain-learning → [[Domain-learnings#...|título]]`.

`Domain-learnings.md` suma `**Dominio:**` después de `**Estado:**`. `Workstyle-learnings.md` suma `**Scope:** user` o `**Scope:** team` — una preferencia individual y una regla de equipo nunca comparten scope.

## Promoción project → domain (sin duplicar fuente de verdad)

Cuando el mismo patrón aparece en 2+ proyectos (reconocido por el agente mientras trabaja, no por un scanner): crear/actualizar la entry en `03-Resources/Domain-learnings.md` con el contenido canónico — Patrón y Solución viven ahí y solo ahí de ahí en más. En cada `<project>-learnings.md` de origen, editar in-place su línea `**Estado:**` a `promovido a domain-learning → [[Domain-learnings#{{fecha}} — {{título}}|{{título}}]]` — el resto de la entry queda intacto como evidencia histórica.

## Antes de crear un learning nuevo

1. Grep el learning relacionado primero (capa L1.5 de `SKILL.md`) — nunca crear una entry sin buscar antes.
2. Si existe: sumar `**Apariciones:**`, ajustar `**Confidence:**`. Si la evidencia nueva contradice: `superseded por [[...]]` en la vieja, entry nueva con la versión corregida. Si la contradicción no se puede resolver con la evidencia disponible, preguntar al usuario antes de fijar cualquiera en `confirmed`.
3. Si no existe: primera aparición aislada y de bajo impacto → alcanza con `-context.md`. Reaparece, hay evidencia fuerte, o el usuario fija una regla explícita → se crea la entry (`<project>-learnings.md` recién se crea la primera vez que hace falta, a diferencia de status/todos/context/decisions).

## Auto-mejora de retrieval

Si un agente repite un error ya documentado en un learning, no alcanza con volver a guardarlo — el problema fue que la búsqueda de L1.5 no lo encontró. Agregar la keyword/alias que faltaba, o un link desde `-status.md`/`AGENTS.md` que lo hubiera hecho aparecer antes.

## Restricción dura (cero detección semántica automática)

Nada de esto se detecta con un script: ni contradicciones, ni patrones repetidos entre proyectos, ni candidatos a skill/resource formal — requieren juicio semántico, y automatizarlos sin ese juicio genera ruido. Es procedimiento que el agente sigue con criterio, nunca un chequeo de CI. Un candidato a Skill/Resource formal se propone al usuario, nunca se crea solo.

Restricción de fondo: si un learning no cambiaría una decisión, diagnóstico, implementación o workflow futuro, no se crea — esto no es una colección de tips.
