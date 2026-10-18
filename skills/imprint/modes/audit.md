# /imprint audit

> Prerequisite: Step 0 and Step 1 of `SKILL.md` (Step 4 there defines the registry format).

## Step 1 — Scan

Resolve the layout (Step 0) and load the tokens (Step 1). Read every file in the declared component
folders, applying the exclusions.

## Step 2 — Identify conflicts against the tokens

```
## UI Consistency Audit

## Conflicts found
**Border radius** — [variants found] → standardise on [token-scale value]
**Background colors** — [classes found; flag any raw hex] → [token classes]
**Text colors** — [classes found; flag any bypassing tokens] → [token classes]
**Spacing** — [variations] → [standard]
**Border colors** — [classes found] → [token class]
**Interactive states** — [variants] → [standard]

## Token violations (must fix)
[Every raw hex / arbitrary value, with file and line]

## Palette warnings (decide)
[Every palette class outside the declared exceptions, with file and line → role, new token, or new exception]

## Recommended baseline
[The correct pattern per property — based on the tokens and what the majority already uses correctly]
```

## Step 3 — Registry hygiene

Run `registry.sh check` (`SKILL.md`, Step 0). It reports, mechanically: main file over 10 KB, section order, Index
lines over 160 characters, missing family labels, entry without Index line and the reverse, entries out
of Index order, `File:` paths that no longer exist, old table format, empty rows, `Token violations:
none`, notes over ten lines, history and open-point markers in the notes (with how often a feature ID
appears in the decisions log), possible logic in the notes, the same sentence in two entries or more,
a section that may override the Baseline. Then judge, opening only the entries concerned:

- each history or open point: already settled in the decisions log? → remove it; still open? → Open
  Questions with a pointer; otherwise → decisions log;
- each repeated rule → which cross-cutting section or `ui-rules.md` line;
- each Baseline override → the corrected Baseline line.

```
## Registry hygiene
[finding → proposed fix → destination file]
Moves: [what goes to which file]
```

## Step 4 — Wait for confirmation

Do not fix anything, do not write the registry yet.

```
Audit complete. [X] conflicts, [Z] token violations across [Y] properties, [H] registry hygiene findings.
Confirm the baseline and the hygiene fixes and I will write them.
```

## Step 5 — Write what was confirmed

Write the Baseline **in place** (`## Baseline`, `Last updated: [date] (/imprint audit)`), its
deviations, the confirmed hygiene fixes and moves, and the Index (`SKILL.md`, Step 4) in the same pass.

`/imprint audit registry` runs Step 0 of `SKILL.md`, then Steps 3, 4 and 5 here — no component scan.
