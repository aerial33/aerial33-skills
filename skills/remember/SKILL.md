---
name: remember
description: Save what matters at the end of a session so the next session picks up exactly where you left off, or restore context at the start of a new session. Routes project status to the progress tracker, durable decisions to the decisions log and session handoff to the memory file, points to the active /architect plan instead of re-describing it, and restores only what the next action needs (sections, not whole files). Never persists secrets. File paths, reading order and secret names come from the project's CLAUDE.md and stack manifest, never hardcoded.
model: sonnet
---

> Fork aerial33 du skill JavaScript Mastery — différences dans FORK-NOTES.md.

```
/remember save      # end of session — compress what matters
/remember restore   # start of session — reload context, confirm before continuing
```

Alone, `/remember` asks which one. Then read **only** the mode file you need, in this skill's folder:
`modes/save.md` or `modes/restore.md`.

## Step 0 — Resolve the project layout (both modes)

Never assume a path.

1. **`CLAUDE.md`** — do not re-read it if it is already in context (Claude Code loads it at start).
   - §1 **reading list**: *always*, *resume* and *per task* rows;
   - §4 **state boundaries**: paths of the **progress tracker**, **decisions log**, **frictions log**
     (optional), **memory file**,
     **UI registry** (main file; its entries file is not read here) and **plans folder** (agent-starter:
     `context/state/…`, `context/plans/`).
2. **Stack manifest** (`context/stack/stack.md` or the one `CLAUDE.md` names): **secret names** and the
   **verification (gate) command**.
3. **Build plan** — the features and their IDs (agent-starter: `context/build-plan.md`).
4. Missing state table or reading list → say so and ask where state lives; never create a state file at
   an undeclared path. No decisions log in §4 → decisions stay in the tracker (older layout).

## Boundaries

- **Never persist or surface a secret** (manifest's secret names, any credential, token, password, key).
- **Status** → progress tracker (short, read every session). **Decisions** → decisions log, and the rule
  file they constrain. **Frictions, workarounds, traps** → frictions log (never read by `/architect`).
  **Handoff** → memory file (overwritten each save). **Plan** → owned by `/architect`: pointed to, never
  copied. **UI registry** (both files) → owned by `/imprint`.

Every session ends with `/remember save` and starts with `/remember restore`.
