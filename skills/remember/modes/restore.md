# /remember restore

> Prerequisite: Step 0 of `SKILL.md` is resolved.

Goal: the next session works as well as if it had never stopped, **without** loading what the next
action does not need. Read what is declared; read it once; read sections, not whole files, when the
reading list names a section.

## Step 1 — Read the memory file first

It decides the mode. If it is absent or empty, say so (first session or not saved) and use mode
**Nouvelle feature** with the next unchecked ID of the progress tracker.

## Step 2 — Read the "always" list of `CLAUDE.md` §1

In order, skipping `CLAUDE.md` itself if it is already in context.

- When an item names a **section** of a file (e.g. "section Invariants of `architecture.md`"), extract
  that section only, e.g. `awk '/^## Invariants/{f=1} f&&/^## /&&!/Invariants/{exit} f' <file>`.
  Never read the whole file for one section.
- The memory file is already read: do not read it again.

## Step 3 — Pick the mode and read its files

- **Reprise** — the memory file names an active plan with status `validé` or `en cours`: read the
  reading list's **resume** row. In the absence of such a row: the **active plan in full** (it is the
  contract: scope, aligned language, decisions, steps, deviations) and the feature's **build-plan entry
  only** (extract it by ID, e.g. `awk '/^### F08 /{f=1;print;next} f&&/^##/{exit} f' <build plan>`).
  Do not read the project overview, the glossary or the decisions log: the plan already carries what
  applies to this feature.
- **Nouvelle feature** — no active plan: read the reading list's **new feature** row (its build-plan
  entry by extraction, its plan if a draft exists, the overview, the glossary…).

Then, in both modes, the **per-task** files for the **kind** of the next action named in the memory file
(UI, data model, code, library…) — read them now, they will not need re-reading when work starts.

## Step 4 — Check the active plan against the memory file

Compare its ticks and current part with what the memory file says. Report any mismatch, do not fix it
silently.

If `CLAUDE.md` has no reading list, say so, read every markdown file under `context/` except the state
files and design images, and recommend adding a reading list.

Other agents' rule files (`AGENTS.md`, `.cursor/rules/`, `.windsurfrules`, `.clinerules`) may exist;
`CLAUDE.md` remains the source of truth. Never surface raw secrets.

## Step 5 — Confirm what was restored (do not start building)

```
Memory restored. Here is where we are:

**Mode:** [reprise / nouvelle feature] · **Read:** [files and sections loaded, one line]
**Last session:** [what was built]
**Current state:** [what works] · Gate at last save: [pass/fail]
**Progress:** [phase · last completed ID · next ID]
**Plan:** [path · status · current part · next step ID] or none
**Decisions in place:** [the plan's key decisions; for a new feature, the relevant ones from the log]
**Next up:** [the next action]

Correct anything that looks wrong before we proceed. Say yes to continue.
```

Only after the developer confirms does the session continue.

## If memory is incomplete

Say so — name what is unclear or absent. Do not guess. If the next action needs a file the mode did not
load (e.g. the overview to settle a scope question), read it then — the modes set the default, not a
ban.
