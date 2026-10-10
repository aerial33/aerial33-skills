# /remember restore

> Prerequisite: Step 0 of `SKILL.md` is resolved.

Goal: the next session works as well as if it had never stopped, **without** loading what the next
action does not need. Read what is declared; read it once; read sections, not whole files, when the
reading list names a section.

## Budget — restore reads, it does not investigate

- **Allowed:** the files and sections the mode declares (plus the one decisions-log search of mode
  *Nouvelle feature*), and at most these commands: `git status --short`, `git branch --show-current`,
  `git log --oneline -5`.
- **Not during restore:** reading source code, searching other files or the decisions log for a term,
  checking services (database, containers, dev server), comparing branches, running the gate or tests,
  listing folders to look for something.
- Read each file **once**; never re-read a file to confirm a detail.
- A mismatch is reported only from what these reads show (memory file ↔ plan ticks ↔ git). Anything
  else worth checking goes in the confirmation under **To check** — proposed, not done.

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
- **Nouvelle feature** — no active plan: read only the feature's **build-plan entry** (by extraction)
  and its plan if a **draft** exists. For the summary, search the decisions log for the feature ID and
  the terms of its entry (e.g. `grep -n -E 'F09|hero' <decisions log>`) instead of reading it. Do
  **not** read the overview, the glossary or the whole decisions log: `/architect` loads them when
  planning starts, and a session may first do something else (a fix, a small task).

Then the **per-task** files for the **kind** of the next action named in the memory file (UI, data
model, code, library…) — read them now, they will not need re-reading when work starts. In mode
**Nouvelle feature**, only when that next action is direct work (a fix, a small task); when it is
planning the feature, `/architect` decides what to read.

When the reading list names **sections** of a file (e.g. the *Index* and *Baseline* of the UI registry),
extract those sections only (e.g. `awk '/^## (Index|Baseline)/{f=1;print;next} f&&/^(## |### |---)/{f=0} f' <registry>`);
full entries are read later, when the work reaches that component.

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
**Decisions in place:** [the plan's key decisions; for a new feature, the log lines found by the search]
**Next up:** [the next action]
**To check:** [verifications proposed, not done — or none]

Correct anything that looks wrong before we proceed. Say yes to continue.
```

Only after the developer confirms does the session continue.

## If memory is incomplete

Say so — name what is unclear or absent. Do not guess. If the next action needs a file the mode did not
load (e.g. the overview to settle a scope question), read it then — the modes set the default, not a
ban.
