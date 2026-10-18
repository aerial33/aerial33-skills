# /remember restore

> Prerequisite: Step 0 of `SKILL.md`.

Goal: the next session works as if it had never stopped, loading only what the next action needs.

## Budget — restore reads, it does not investigate

- **Allowed:** the files and sections below, and at most `git status --short`,
  `git branch --show-current`, `git log --oneline -5`.
- **Not now:** source code, searches (except the one of mode *Nouvelle feature*), services (database,
  containers, dev server), branch comparisons, gate or tests, folder listings. Read each file once.
- Anything else worth checking goes under **To check** in the confirmation — proposed, not done.

## How to read

- The file-reading tool loads **whole files with line numbers**. So everything that is only read goes
  through **one** call of this skill's script, which prints files or named sections without numbers:
  `sh <skill folder>/scripts/read-sections.sh <file> "<file>#<Section>" "<file>#<A>|<B>" …`
  A section is matched by the start of its heading text and ends at the next heading of the same or
  higher level, or at `---`. `!! …` lines are missing files or sections: report them, do not hunt.
- Files this session **will edit** use the file-reading tool: the **memory file** and the **active plan**.
  Never re-read what the script printed, unless you must edit it later.

## Step 1 — Memory file

File-reading tool. It decides the mode. Absent or empty → say so, mode **Nouvelle feature** with the
tracker's next unchecked ID.

## Step 2 — One script call

1. **Always** list of `CLAUDE.md` §1 (minus `CLAUDE.md` and the memory file); a named section becomes
   `"<file>#<Section>"`.
2. **Mode:**
   - **Reprise** — the memory file names a plan `validé` or `en cours`: the *resume* row, by default the
     **build-plan entry only** (`"<build plan>#<ID> "`). The **plan** itself in full, with the
     file-reading tool (the contract: scope, language, decisions, steps, deviations). Not the overview,
     glossary or decisions log — the plan carries what applies.
   - **Nouvelle feature** — no active plan: the **build-plan entry** only, the plan if a **draft**
     exists, and one search of the decisions log for the ID and the entry's terms
     (`grep -n -E 'F09|hero' <log>`). Overview, glossary and full log are `/architect`'s to load.
3. **Per task**, for the kind of next action in the memory file (UI, data model, code…), with the
   files and sections the reading list names (e.g. the UI registry main file, whole: `"<UI registry>"`).
   Never the UI registry **entries** file: an entry is read when the work reaches that component. In
   *Nouvelle feature*, only if the next action is direct work, not planning.

No reading list in `CLAUDE.md` → say so, read the markdown under `context/` except state files and
designs, recommend adding one. `CLAUDE.md` stays the source of truth over other agents' rule files.

## Step 3 — Confirm (do not start building)

Compare the plan's ticks and part with the memory file and git. Report mismatches; never fix silently.

```
Memory restored. Here is where we are:

**Mode:** [reprise / nouvelle feature] · **Read:** [files and sections, one line]
**Last session:** [what was built]
**Current state:** [what works] · Gate at last save: [pass/fail]
**Progress:** [phase · last completed ID · next ID]
**Plan:** [path · status · current part · next step ID] or none
**Decisions in place:** [the plan's key decisions; new feature: the log lines found]
**Next up:** [the next action]
**Mismatches:** [memory ↔ plan ↔ git, one line each — or none]
**To check:** [proposed, not done — or none]

Correct anything that looks wrong. Say yes to continue.
```

With mismatches, add: `Update these lines of the memory file so the next restore is clean? (yes / no)`.
On yes, edit **only** those lines and `Last updated` (`[date], handoff corrected at restore`) — never the
rest, the tracker or the plan; today's work is `/remember save`'s job.

Nothing continues before the developer confirms. Memory incomplete → name what is missing, do not
guess. If the next action needs a file the mode did not load, read it then: modes set the default, not a ban.
