# /remember restore

> Prerequisite: Step 0 of `SKILL.md` is resolved.

Goal: the next session works as well as if it had never stopped, **without** loading what the next
action does not need. Read what is declared, once, and only the sections the reading list names.

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

## How to read — one script call, not file by file

The file-reading tool loads **whole files with line numbers**: reading a 14 k file for one 300-character
entry, or a 20 k registry for its index, is where restore cost comes from. So:

- Everything that is **only read** goes through **one** call of this skill's script
  `scripts/read-sections.sh` (in this skill's folder), which prints whole files or named sections, without
  line numbers:

  ```
  sh <skill folder>/scripts/read-sections.sh \
    <file> "<file>#<Section>" "<file>#<Section A>|<Section B>" …
  ```

  A section is matched by the start of its heading text (`#Invariants`, `#F09 `, `#Index|Baseline`) and
  runs to the next heading of the same or higher level, or to a `---` line. Missing files or sections are
  printed as `!! …`: report them, do not hunt for them.
- Files this session **will edit** are read with the file-reading tool instead (the editor requires it,
  and reading them twice would cost double): the **memory file** (Step 1) and the **active plan** (ticked
  at every step).
- Never re-read with the file-reading tool what the script already printed. If work later needs to
  **edit** one of those files, read it then.

## Step 1 — Read the memory file

With the file-reading tool. It decides the mode. If it is absent or empty, say so (first session or not
saved) and use mode **Nouvelle feature** with the next unchecked ID of the progress tracker.

## Step 2 — Build the list and read it in one call

Collect, in this order, then run the script **once** with the whole list:

1. The **"always"** list of `CLAUDE.md` §1 — skip `CLAUDE.md` itself if it is already in context and the
   memory file (already read). An item that names a section becomes `"<file>#<Section>"`.
2. The **mode** files:
   - **Reprise** — the memory file names an active plan with status `validé` or `en cours`: the
     reading list's **resume** row, or by default the feature's **build-plan entry only**
     (`"<build plan>#<ID> "`). The **active plan itself** is read in full with the file-reading tool
     (it is the contract: scope, aligned language, decisions, steps, deviations). Do not read the project
     overview, the glossary or the decisions log: the plan already carries what applies to this feature.
   - **Nouvelle feature** — no active plan: the feature's **build-plan entry** only, and its plan if a
     **draft** exists (file-reading tool). For the summary, search the decisions log for the feature ID
     and the terms of its entry (e.g. `grep -n -E 'F09|hero' <decisions log>`) instead of reading it. Do
     **not** read the overview, the glossary or the whole log: `/architect` loads them when planning
     starts, and a session may first do something else (a fix, a small task).
3. The **per-task** files for the **kind** of the next action named in the memory file (UI, data model,
   code, library…), with the sections the reading list names (e.g. `"<UI registry>#Index|Baseline"`).
   In mode **Nouvelle feature**, only when that next action is direct work (a fix, a small task); when it
   is planning the feature, `/architect` decides what to read. Full registry entries are read later,
   when the work reaches that component.

Then the allowed git commands (they may share the same shell call).

## Step 3 — Check the active plan against the memory file

Compare its ticks and current part with the memory file and git. Report any mismatch, do not fix it
silently (Step 5 offers the fix).

If `CLAUDE.md` has no reading list, say so, read every markdown file under `context/` except the state
files and design images, and recommend adding a reading list.

Other agents' rule files (`AGENTS.md`, `.cursor/rules/`, `.windsurfrules`, `.clinerules`) may exist;
`CLAUDE.md` remains the source of truth. Never surface raw secrets.

## Step 4 — Confirm what was restored (do not start building)

```
Memory restored. Here is where we are:

**Mode:** [reprise / nouvelle feature] · **Read:** [files and sections loaded, one line]
**Last session:** [what was built]
**Current state:** [what works] · Gate at last save: [pass/fail]
**Progress:** [phase · last completed ID · next ID]
**Plan:** [path · status · current part · next step ID] or none
**Decisions in place:** [the plan's key decisions; for a new feature, the log lines found by the search]
**Next up:** [the next action]
**Mismatches:** [memory ↔ plan ↔ git, one line each — or none]
**To check:** [verifications proposed, not done — or none]

Correct anything that looks wrong before we proceed. Say yes to continue.
```

Only after the developer confirms does the session continue.

## Step 5 — Correct the handoff (only if there were mismatches)

The memory file is rewritten only by `/remember save`; until then every restore would report the same
stale lines. So, when **Mismatches** is not "none", ask once, with the confirmation:

```
Update these lines of the memory file so the next restore is clean? (yes / no)
```

On yes: edit **only** the lines the mismatches name (e.g. a commit now done, a "Next session" item
already handled), and the `Last updated` line (`[date], handoff corrected at restore`). Never rewrite
the rest, never add today's work (that is `/remember save`'s job), never touch the tracker or the plan.
On no: change nothing.

## If memory is incomplete

Say so — name what is unclear or absent. Do not guess. If the next action needs a file the mode did not
load (e.g. the overview to settle a scope question), read it then — the modes set the default, not a
ban.
