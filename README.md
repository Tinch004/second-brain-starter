# Second Brain for AI Work

Memoria operativa persistente, compartida y eficiente en tokens para trabajar con agentes de IA.

`second-brain-starter` usa Markdown + Obsidian + Git como fuente de verdad para que Claude Code, Codex y otros agentes puedan retomar trabajo sin reconstruir contexto desde cero, recordar qué se decidió, qué falta y qué se aprendió trabajando.

> **La idea central:** continuar exactamente donde quedó el trabajo usando la mínima cantidad de contexto necesaria.

## El problema que resuelve

Una sesión nueva de un agente normalmente arranca casi en cero: o le reexplicás el proyecto, o vuelve a explorar archivos, commits y decisiones que otro agente ya había entendido. Eso cuesta tiempo y tokens, y empeora cuando alternás entre agentes o máquinas.

Este starter separa la memoria del chat y de los repos de código. La memoria vive en un vault de Obsidian, versionado con Git, enlazado como grafo y escrito en Markdown legible tanto por humanos como por agentes.

No intenta guardar toda tu vida ni convertir Obsidian en una plataforma gigante. Está orientado a **trabajo**: proyectos, tareas, decisiones, bloqueos, relaciones, contexto y experiencia acumulada.

## Qué te da

### Continuidad entre agentes

Cada unidad de trabajo mantiene una foto actual y una memoria larga separadas:

- `status` — foco actual, bloqueos y próximos pasos;
- `todos` — tareas activas, bloqueadas y hechas;
- `decisions` — decisiones importantes y por qué se tomaron;
- `context` — continuidad histórica de sesiones;
- `learnings` — experiencia reutilizable cuando realmente aparece un patrón.

El agente puede detectar el proyecto actual por `AGENTS.md`, contexto del vault, carpeta de trabajo o remote Git. Un proyecto existente puede incorporarse con un onboarding acotado sin escanear el repo entero.

### Retrieval eficiente en tokens

La memoria se recupera por capas y se detiene cuando ya alcanza:

```text
L0   project card / índice
L1   status + todos
L1.5 learnings relevantes
L2   decisions + módulos puntuales
L3   context + _raw (cold storage)
```

Reglas centrales:

- buscar antes de leer archivos completos;
- leer solo la sección necesaria cuando sea posible;
- no abrir `context`, `_raw` o decisiones históricas "por las dudas";
- después de cada capa, evaluar si ya hay contexto suficiente;
- cargar learnings por scope, no todos juntos.

La idea no es comprimir todo en un resumen gigante: es **recuperar menos y mejor**.

### Experience Learning

El sistema no solo recuerda qué pasó: puede convertir experiencia repetida en reglas cortas reutilizables para no volver a descubrir lo mismo.

Hay tres niveles:

- **System Learnings** — cómo funciona y se mantiene el propio second brain;
- **Workstyle Learnings** — cómo trabaja una persona o equipo;
- **Project / Domain Learnings** — errores recurrentes, edge cases, soluciones probadas y patrones reutilizables.

Una primera observación puede quedarse solo en `context`. Si reaparece o tiene evidencia suficiente, puede convertirse en `candidate`, luego `confirmed`, ser reemplazada con trazabilidad o promoverse de proyecto a dominio.

La regla más importante es simple:

> Si un learning no cambiaría una futura decisión, diagnóstico, implementación o workflow, probablemente no merece existir.

### Work Model + Work Graph

El core no asume que todo trabajo es software.

Cada unidad puede declarar un `type` libre y relaciones opcionales como:

- `parent`
- `depends-on`
- `blocked-by`
- `related-to`
- `supersedes`

Las relaciones usan wikilinks canónicos y los backlinks se derivan por búsqueda: no se mantienen dos direcciones manualmente.

Esto permite modelar tanto un proyecto técnico como un cliente, campaña, producto, investigación o proceso sin crear una ontología rígida.

**El core conoce trabajo. El profile conoce el oficio.**

### Work Profiles

Los profiles adaptan vocabulario, evidencia y criterios sin duplicar el core ni crear otra arquitectura por profesión.

Incluye guías iniciales para:

- Developer
- Agency / Marketing
- Product
- Ops / Consulting

Un profile es documentación scoped que el agente consulta solo cuando corresponde. No cambia los archivos core, los Steps ni el CI.

### Memory Health

GitHub Actions audita automáticamente problemas estructurales y señales de mantenimiento, entre ellas:

- notas huérfanas y links rotos;
- nombres inválidos;
- secretos de alta confianza en Markdown;
- relaciones rotas o ciclos directos evidentes en el Work Graph;
- TODOs posiblemente estancados;
- status posiblemente viejos;
- decisiones/learnings sin estado cuando corresponde.

Los chequeos semánticos ambiguos siguen siendo responsabilidad del agente: no hay un scanner que invente contradicciones o relaciones por similitud.

### Cross-agent y portable

La misma skill `update-project-memory` se instala para Claude Code y Codex, y el vault sigue siendo Markdown normal: no depende de una base vectorial, un daemon ni una conversación específica.

Git sincroniza el estado entre agentes y máquinas con reglas explícitas de:

- pull antes de leer;
- staging puntual;
- commit/push al guardar memoria real;
- resolución de conflictos sin force-push.

### `_raw/`

La fuente original se guarda antes de compilarla en memoria estructurada. Las notas derivadas apuntan de vuelta al material original para poder verificar o recompilar conocimiento sin depender de la sesión que lo procesó.

## Filosofía

Este proyecto es deliberadamente más chico que otros sistemas de "second brain" que agregan bases vectoriales, chats internos, feeds, calendarios, pipelines permanentes o decenas de comandos.

Acá las decisiones son otras:

- **Work-first** — memoria laboral, no life OS.
- **Markdown-first** — la fuente de verdad sigue siendo legible y portable.
- **Implícito, no command-driven** — el agente reconoce cuándo corresponde guardar memoria.
- **Search/index first, details later** — gastar contexto solo cuando la tarea lo justifica.
- **Curated memory** — no guardar cada tool call ni cada pensamiento como memoria permanente.
- **Evidence over recollection** — cuando hay repo Git, el estado se contrasta con evidencia real antes de escribir memoria.
- **Few moving parts** — no sumar infraestructura hasta que exista una necesidad concreta.
- **No duplicar Graphify** — este vault modela conocimiento y trabajo; Graphify sigue siendo el lugar para dependencias internas de código.

## Estructura

```text
Home.md
00-Inbox/
01-Projects/
02-Skills/
03-Resources/
04-Archive/
_profiles/
_templates/
_raw/
AGENTS.md
CLAUDE.md
skill/
  update-project-memory/
    SKILL.md
    reglas-aprendidas.md
    work-graph.md
    learnings.md
```

Los proyectos empiezan con una estructura mínima y los archivos opcionales —como `-learnings.md`— se crean de forma perezosa cuando realmente hacen falta.

## Instalación

### Windows

```powershell
irm https://raw.githubusercontent.com/Tinch004/second-brain-starter/main/install.ps1 | iex
```

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/Tinch004/second-brain-starter/main/install.sh | bash
```

La guía completa, incluidos los pasos manuales que Obsidian requiere para habilitar plugins y conectar el MCP, está en **[SETUP.md](./SETUP.md)**.

## Qué no intenta ser

No busca reemplazar:

- un code graph;
- un gestor completo de proyectos;
- un RAG/vector database;
- un calendario personal;
- un sistema de journaling;
- un agregador de X/YouTube/feeds;
- un "segundo cerebro para toda la vida".

Su objetivo es más específico:

> **Que un agente pueda retomar trabajo, entender qué importa y aprovechar experiencia previa sin hacerte pagar otra vez los mismos tokens.**

## Estado

El starter ya incluye las seis capas de evolución iniciales:

1. Continuity
2. Token Efficiency
3. Work Model + Work Graph
4. Intelligence / Memory Health
5. Experience Learning
6. Work Profiles

A partir de acá, la prioridad es endurecerlo con uso real, medir retrieval y mantener el core chico antes de sumar infraestructura nueva.

## Licencia

MIT — usalo, modificalo y adaptalo a tu forma de trabajar.
