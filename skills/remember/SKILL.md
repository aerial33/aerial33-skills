---
name: remember
description: Save what matters at the end of a session so the next session picks up exactly where you left off, or restore context at the start of a new session. Routes durable decisions to the progress tracker and session handoff to the memory file, points to the active /architect plan instead of re-describing it, reads the project's own reading list on restore, and never persists secrets. File paths, reading order and secret names come from the project's CLAUDE.md and stack manifest, never hardcoded.
---

> FORK aerial33 du skill JavaScript Mastery. Différences vs original : frontière explicite entre
> état durable (progress tracker) et handoff de session (memory) ; restore suit la liste de lecture
> déclarée par le projet ; secrets déclarés par la stack redactés ; état du gate noté ; le handoff
> renvoie au plan actif de `/architect` (étape `F05.3`) au lieu de le redécrire. **Aucun chemin
> en dur** — tout est lu dans `CLAUDE.md` et le manifeste de stack (architecture agent-starter).
> Voir FORK-NOTES.md.

AI has no memory between sessions. Every new session starts blank. This skill fixes that.

Run `/remember save` at the end of a session, `/remember restore` at the start of the next one.

## How to Invoke

```
/remember save      # end of session — compress what matters
/remember restore   # start of session — reload context, confirm before continuing
```

If the developer runs `/remember` alone, ask which one they need.

---

## Step 0 — Resolve the project layout (both modes)

Never assume paths. Resolve them, in this order:

1. **`CLAUDE.md`** (project root):
   - **reading list** (§1) — what to read *always* and *per task*;
   - **state boundaries** table (§4) — exact paths of the **progress tracker**, the **memory file**
     and the **UI registry** (in agent-starter: `context/state/progress-tracker.md`,
     `context/state/memory.md`, `context/state/ui-registry.md`), and the **plans folder**
     (in agent-starter: `context/plans/`).
2. **Stack manifest** — `context/stack/stack.md` (or the manifest `CLAUDE.md` points to):
   - the **secret names** to redact;
   - the **verification (gate) command**.
3. **Build plan** — the file listing features with IDs (in agent-starter: `context/build-plan.md`).
4. **Fallback** — if `CLAUDE.md` has no state table or reading list, say so and ask the developer
   where state lives. Never create a state file at a path that was not declared.

---

## Security Boundary

Never persist secrets. Store a redacted placeholder instead (e.g. `[REDACTED]`). Treat as sensitive:

- every name listed under **Secrets** in the stack manifest;
- in any case: connection strings, API keys, access/refresh/session tokens, OAuth client secrets,
  storage credentials, webhook secrets, cookies, auth headers, passwords, private keys, certificates,
  one-time codes.

If unsure whether something is sensitive, treat it as sensitive and omit or redact it.

---

## The State Boundary — read before saving

Route information by lifecycle. Do not dump everything into the memory file:

- **Progress tracker** = durable PROJECT state: completed features (by build-plan ID), current phase,
  open questions, **decisions that future work depends on**. Persistent.
- **Memory file** = SESSION handoff: just enough to resume tomorrow without re-explaining.
  Overwritten each save.
- **UI registry** = de-facto design system. Owned by `/imprint`, not by this skill.
- **Plan** = the validated `/architect` plan of a feature. Owned by `/architect`; this skill only checks
  its ticks and deviations are up to date, and **points** to it — never copies its steps.

---

## Save Mode

### Step 1 — Update the progress tracker (durable)

If this session produced completed units or durable decisions:

- Tick completed features using the **IDs of the build plan** (e.g. `F04`). Never invent an ID; if work
  does not map to a build-plan entry, say so and ask whether to add it to the build plan.
- Update **Current Status** (phase, last completed, next).
- Record each durable decision with its date and its **why**.
- Add any new **open question**.

Do not duplicate these into the memory file — reference them.

### Step 1b — Check the active plan

If the current feature has a plan in the plans folder with status `en cours`:

- every step that was **verified** this session is ticked — never tick an unverified step;
- every deviation from the plan has its dated line in **Écarts au plan** — never rewrite the plan itself.

If something is missing, fix it or tell the developer before writing the handoff.

### Step 2 — Write the session handoff to the memory file

Think like handing off to an equally-skilled colleague who knows nothing about today.

- **What was built** — precise: files, data-model entities, routes, components. Not "added the blog" but
  "created the `posts` collection with public read / editor write access and its detail route".
- **Data-model / schema changes** — and whether a migration was generated and applied.
- **Env vars needed** — names only, values redacted.
- **Problems solved** — so they are not solved twice.
- **Current state** — what works, what is partial, what is broken.
- **Gate status** — did the verification command from the stack manifest pass at save time? Which step failed?
- **Active plan** — path, status, last ticked step; or "none".
- **Next session starts with** — the very next action, referencing the build-plan ID, and the **plan step**
  if there is one (e.g. "F05.3 — see the plan"). Do not restate what the plan already says.
- **Open questions** — or a pointer to the progress tracker.

Do not capture: implementation details visible in the code, decisions already in the tracker or context
files, the process of how something was built, any secret.

### Safety check before writing

Re-read the content. Remove or redact any sensitive value.

### Overwrite confirmation

The memory file holds only the most recent session. If it already has content, summarise it and ask:

```
The memory file already covers: [one-line summary].
Overwrite with this session's memory? (yes / no)
```

If no → "No changes made."

### Format

```markdown
# Memory — [Feature or Session Name]
Last updated: [date and time]

## What was built
## Data-model / schema changes
## Env vars needed
## Problems solved
## Current state
## Gate status
## Active plan
## Next session starts with
## Open questions
```

After writing:

```
Memory saved to [memory path]. Durable decisions written to [tracker path].
Next session: run /remember restore.
```

---

## Restore Mode

### Step 1 — Read what the project declares

1. `CLAUDE.md`.
2. Every file in its **"always"** reading list, in order.
3. The **memory file**. If it is absent or empty, say so: first session or not saved.
4. The **per-task** files for the action named in "Next session starts with" (e.g. its build-plan
   entry, and the UI files if it is UI work).
5. The **active plan** named in the memory file, or the plan of the next feature if one exists in the
   plans folder. Check its ticks against the memory file; report any mismatch, do not fix it silently.

If `CLAUDE.md` has no reading list, say so, read every markdown file under `context/` except the state
files and design images, and recommend adding a reading list.

Other agents' rule files (`AGENTS.md`, `.cursor/rules/`, `.windsurfrules`, `.clinerules`) may exist;
`CLAUDE.md` remains the source of truth. Never surface raw secrets.

### Step 2 — Confirm what was restored (do not start building)

```
Memory restored. Here is where we are:

**Last session:** [what was built]
**Current state:** [what works] · Gate at last save: [pass/fail]
**Progress:** [phase · last completed ID · next ID]
**Plan:** [path · status · next step ID] or none
**Decisions in place:** [key durable decisions from the tracker]
**Next up:** [the next action]

Correct anything that looks wrong before we proceed. Say yes to continue.
```

Only after the developer confirms does the session continue.

### If memory is incomplete

Say so — name what is unclear or absent. Do not guess.

---

## The Rule

Every session ends with `/remember save`. Every session starts with `/remember restore`.
Durable decisions live in the progress tracker; session handoff lives in the memory file.
