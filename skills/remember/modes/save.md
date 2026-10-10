# /remember save

> Prerequisite: Step 0 of `SKILL.md` is resolved.

## Security Boundary

Never persist secrets. Store a redacted placeholder instead (e.g. `[REDACTED]`). Treat as sensitive:

- every name listed under **Secrets** in the stack manifest;
- in any case: connection strings, API keys, access/refresh/session tokens, OAuth client secrets,
  storage credentials, webhook secrets, cookies, auth headers, passwords, private keys, certificates,
  one-time codes.

If unsure whether something is sensitive, treat it as sensitive and omit or redact it.

## The State Boundary

Route information by lifecycle and by **who needs to read it when**:

- **Progress tracker** = project STATUS: current phase, checklist by build-plan ID, open questions.
  Read at every session start — so it stays **short**: no decision log, no notes.
- **Decisions log** = durable DECISIONS (date — ID — decision — why) and notes (frictions, workarounds).
  Append-only history. **Not** read at session start: `/architect` reads it before planning, anyone
  searches it (grep) before changing an existing choice.
- **Rule files** (project architecture, UI rules, library docs, glossary — the "Keeping docs in sync"
  list of the method) = decisions that **constrain future code** are also promoted there, so they are
  read whenever the task needs them.
- **Memory file** = SESSION handoff: just enough to resume tomorrow without re-explaining.
  Overwritten each save.
- **UI registry** = de-facto design system. Owned by `/imprint`, not by this skill.
- **Plan** = the validated `/architect` plan of a feature. Owned by `/architect`; this skill only checks
  its ticks and deviations are up to date, and **points** to it — never copies its steps.

---

## Step 1 — Update the progress tracker (status)

If this session produced completed units:

- Tick completed features using the **IDs of the build plan** (e.g. `F04`). Never invent an ID; if work
  does not map to a build-plan entry, say so and ask whether to add it to the build plan.
- Update **Current Status** (phase, last completed, next).
- Add any new **open question**; remove the ones resolved this session (their answer is a decision →
  Step 1a).

Keep the tracker to its sections (status, checklist, open questions). If it holds a decisions or notes
section (older layout) and the project declares a decisions log, say so and propose moving those
sections to the log, verbatim — do not move them without the developer's agreement.

## Step 1a — Record durable decisions

For each decision that future work depends on:

- append one line to the **decisions log**: `AAAA-MM-JJ — <ID> — <decision> — <why>`;
- if it **constrains future code** (a convention, a boundary, a library choice, a UI rule), also write
  it in the rule file that governs it (method § "Keeping docs in sync": project architecture, UI rules,
  library docs, glossary…), so it is read whenever that kind of task comes up;
- decisions already recorded in the active plan (Décisions, Écarts) are not copied: once the feature is
  done, only those that outlive it go to the log.

Frictions, workarounds and traps go to the log's **Notes** (traps of a library also to its library docs).

## Step 1b — Check the active plan

If the current feature has a plan in the plans folder with status `en cours`:

- every step that was **verified** this session is ticked — never tick an unverified step; same for a
  milestone (jalon) and its end-to-end check;
- every deviation from the plan has its dated line in **Écarts au plan** — never rewrite the plan itself.

If something is missing, fix it or tell the developer before writing the handoff.

## Step 2 — Write the session handoff to the memory file

Think like handing off to an equally-skilled colleague who knows nothing about today. **Aim for about
60 lines**: point to the plan, the tracker and the log instead of restating them.

- **What was built** — precise: files, data-model entities, routes, components. Not "added the blog" but
  "created the `posts` collection with public read / editor write access and its detail route".
- **Data-model / schema changes** — and whether a migration was generated and applied.
- **Env vars needed** — names only, values redacted.
- **Problems solved** — so they are not solved twice (one line each; details in the log's Notes).
- **Current state** — what works, what is partial, what is broken.
- **Gate status** — did the verification command from the stack manifest pass at save time? Which step failed?
- **Active plan** — path, status, current part (if the plan has parts), last ticked step; or "none".
- **Next session starts with** — the very next action, referencing the build-plan ID, and the **plan step**
  if there is one (e.g. "F07.5, part B — see the plan"), and its **kind** (UI, data model, code…) so
  restore knows which per-task files to load. Do not restate what the plan already says.
- **Open questions** — or a pointer to the progress tracker.

Do not capture: implementation details visible in the code, decisions already in the log, the plan or
context files, the process of how something was built, any secret.

## Safety check before writing

Re-read the content. Remove or redact any sensitive value.

## Overwrite confirmation

The memory file holds only the most recent session. If it already has content, summarise it and ask:

```
The memory file already covers: [one-line summary].
Overwrite with this session's memory? (yes / no)
```

If no → "No changes made."

## Format

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
Memory saved to [memory path]. Status in [tracker path], decisions in [log path].
Next session: run /remember restore.
```
