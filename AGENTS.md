# Vault (segundo cerebro) — contexto de agente

Este vault de Obsidian es la memoria centralizada de tus proyectos más las skills compartidas — y su propia arquitectura puede seguir evolucionando. Si estás acá (Claude Code, Codex, o un chat de agente apuntando directo a esta carpeta), es porque el trabajo es sobre el vault mismo, no sobre uno de los proyectos que contiene.

## Antes de proponer cualquier cambio de estructura

0. **Primero, siempre**: `git pull` acá mismo (si este vault es un repo git propio) — puede haber cambios de otra sesión o máquina que todavía no llegaron a este checkout.
1. Leer **[[Home]]** — es el hub, tiene el mapa completo de carpetas.
2. Leer **`~/.agents/skills/update-project-memory/reglas-aprendidas.md`** (mirroreada en `~/.codex/skills/`, vive junto a `SKILL.md`) — es el log real de decisiones de arquitectura del vault. No proponer de nuevo algo que ya está ahí resuelto.
3. El resto de esa misma skill tiene el proceso completo de cómo se escribe memoria de proyecto — es la fuente de verdad operativa, no un doc aparte.

## Detección del proyecto actual

Orden de precedencia completo en la sección "Detección del proyecto actual" de la skill `update-project-memory` — no lo repitas de memoria ni lo reinterpretes, léelo de ahí. Resumen de una línea: repo propio con su `AGENTS.md` ya declarándolo → si no, archivo en contexto bajo `01-Projects/<proyecto>/...` → si no, match de cwd/remote contra `01-Projects/Projects-index.md` → si sigue ambiguo, una sola pregunta corta.

## Reglas duras de este vault (resumen — el detalle está en la skill)

- Ningún archivo de proyecto se llama `_status.md`/`todos.md`/`decisions.md`/`context.md` a secas — siempre `<proyecto>-<tipo>.md`.
- Nunca secretos reales en el vault (API keys, tokens, private keys, passwords) — ni en `_raw/`: redactar antes de guardar. El CI (`vault-audit.yml`) es un hard gate: si falla por esto, corregir/redactar, nunca bypassear. Si marca un falso positivo (ej. un placeholder tipo `API_KEY=your_key_here` pegado de un `.env.example`), reescribir esa línea para que no matchee (ej. `<tu-api-key>` sin comillas) en vez de bypassear.
- Ningún índice de carpeta se llama `README.md` — siempre `<Carpeta>-index.md`.
- Nunca hardcodear cantidades ("9 skills", "3 proyectos") en un índice — quedan viejas.
- Skills en `02-Skills/` van agrupadas por dominio en subcarpetas, no en lista plana.
- Cero huérfanas, cero links rotos — verificar antes de cerrar cualquier cambio.
- Material crudo entregado por el usuario se guarda primero en `_raw/<proyecto>/` antes de compilarlo en una nota.
- Toda técnica/herramienta nueva que se descubra en esta máquina se anota en `03-Resources/Tecnicas-agente.md`.

## Memoria del vault mismo

Este archivo no tiene un `-status.md` propio como los proyectos reales — la continuidad de "en qué está el vault" vive en `reglas-aprendidas.md` (se lee como changelog: más reciente al final). Si una sesión de trabajo real cambia la arquitectura del vault, ese archivo es donde se registra.
