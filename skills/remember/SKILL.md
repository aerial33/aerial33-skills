---
name: remember
description: Save what matters at the end of a session so the next session picks up exactly where you left off, or restore context at the start of a new session. Routes project status to the progress tracker, durable decisions to the decisions log and session handoff to the memory file, points to the active /architect plan instead of re-describing it, and restores only what the next action needs (sections, not whole files). Never persists secrets. File paths, reading order and secret names come from the project's CLAUDE.md and stack manifest, never hardcoded.
---

> FORK aerial33 du skill JavaScript Mastery. Différences vs original : frontière explicite entre
> statut (progress tracker), décisions durables (journal des décisions) et handoff de session (memory) ;
> restore suit la liste de lecture déclarée par le projet, **par sections et selon le mode (reprise /
> nouvelle feature)** ; secrets déclarés par la stack redactés ; état du gate noté ; le handoff renvoie
> au plan actif de `/architect` (étape `F05.3`) au lieu de le redécrire. **Aucun chemin en dur** — tout
> est lu dans `CLAUDE.md` et le manifeste de stack (architecture agent-starter). Voir FORK-NOTES.md.

AI has no memory between sessions. Every new session starts blank. This skill fixes that — at the
lowest context cost that keeps the next session as good as this one.

Run `/remember save` at the end of a session, `/remember restore` at the start of the next one.

## How to Invoke

```
/remember save      # end of session — compress what matters
/remember restore   # start of session — reload context, confirm before continuing
```

If the developer runs `/remember` alone, ask which one they need.

**Then read only the file of the mode you run, in this skill's folder:**
`modes/save.md` or `modes/restore.md`. Do not read the other one.

---

## Step 0 — Resolve the project layout (both modes)

Never assume paths. Resolve them, in this order:

1. **`CLAUDE.md`** (project root). If it is already in your context (Claude Code loads it at session
   start), do **not** read it again.
   - **reading list** (§1) — what to read *always*, *on resume* and *per task*;
   - **state boundaries** table (§4) — exact paths of the **progress tracker**, the **decisions log**,
     the **memory file** and the **UI registry** (in agent-starter: `context/state/progress-tracker.md`,
     `context/state/decisions.md`, `context/state/memory.md`, `context/state/ui-registry.md`), and the
     **plans folder** (in agent-starter: `context/plans/`).
2. **Stack manifest** — `context/stack/stack.md` (or the manifest `CLAUDE.md` points to):
   - the **secret names** to redact;
   - the **verification (gate) command**.
3. **Build plan** — the file listing features with IDs (in agent-starter: `context/build-plan.md`).
4. **Fallback** — if `CLAUDE.md` has no state table or reading list, say so and ask the developer
   where state lives. Never create a state file at a path that was not declared. If §4 declares no
   decisions log, durable decisions stay in the progress tracker (older layout).

---

## Boundaries (summary — details in `modes/save.md`)

- **Never persist or surface secrets** (names listed under Secrets in the stack manifest, and any
  credential, token, password or key).
- **Status** → progress tracker (short, read every session) · **decisions** → decisions log (history,
  read by `/architect`, searched before changing a choice) and the rule file they constrain ·
  **session handoff** → memory file · **plan** → owned by `/architect`, pointed to, never copied.

---

## The Rule

Every session ends with `/remember save`. Every session starts with `/remember restore`.
Status lives in the progress tracker, decisions in the decisions log (and in the rule file they
constrain), session handoff in the memory file.
