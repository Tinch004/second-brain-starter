# Profile: product

[[Profiles-index|_profiles]] ·

Dominio: producto — features, experimentos, research. Puede o no tener repo: a veces el producto es el mismo proyecto developer, a veces es una capa de decisión separada del código.

## `type` típicos
- `product` — el producto entero.
- `feature` — una feature puntual, normalmente `parent: "[[<product>-status]]"`.
- `experiment` — un experimento/A-B test, con hipótesis y resultado.
- `research` — research de usuarios/mercado que informa decisiones, sin ser código ni feature todavía.

## Vocabulario
"Foco actual" = en qué etapa está (discovery, diseño, build, testeo, live). Una entry de `-decisions.md` digna de registrarse es un cambio de scope de una feature, o un pivot basado en el resultado de un experimento/research — registrar el resultado que lo motivó, no solo la decisión final.

## Evidencia
Si el proyecto tiene repo, mismo chequeo de `git` que el profile `developer`. Si no, la evidencia son resultados de analytics/experimentos/research que el usuario trae a la sesión — mismo criterio que `agency-marketing`: no inventar un resultado que no fue mostrado.
