# /imprint migrate

> Prerequisite: Step 0 of `SKILL.md`; the target format is its Step 4, the hygiene check is `modes/audit.md` Step 3.

For a registry still in one file. Content does not change, only its form; whatever moves to another
file is listed.

1. **Preconditions** — the single file exists and the entries file does not; the registry has no
   uncommitted change (the diff must be readable); `CLAUDE.md` §4 declares the entries path. If not,
   show the §1 *Interface* row and the two §4 rows of the kit's `CLAUDE.md`, ask, stop.
2. **Split and tables** — `registry.sh split <single> <main.new> <entries>` (kit templates as extra
   arguments if they exist, for the headers), then replace the single file with `<main.new>`. The
   script: moves the Index, the Baseline and every cross-cutting section to the main file (a section
   found between entries moves up, and is listed); puts every `###` block that has a `File:` line in the
   entries file, in Index order; removes the empty rows, the compliance column (a bare `yes` disappears,
   any other text moves into the class cell), `Token violations: none` lines and the parenthesis after
   `Last updated`; then **verifies** that nothing else was lost or added. A failed verify → stop, show it.
3. **Hygiene report** — commit the split (form only, proven by `verify`), then `modes/audit.md` Step 3
   on the two new files; present the split report and the hygiene report together. **Stop**: no note, Index line or Baseline is rewritten before the developer agrees.
4. **After agreement** — apply the hygiene fixes (family labels, Index order and length, notes, moves to
   the decisions log, Open Questions, `architecture.md`, `ui-rules.md` or a cross-cutting section), then
   run `registry.sh keep` (the two files as committed at step 3 and the destination files as they
   were, `--`, the same files now) and `registry.sh check`. A missing
   sentence → put it back or show it; give the final list of moves and the sizes before / after.
