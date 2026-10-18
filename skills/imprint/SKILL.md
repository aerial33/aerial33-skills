---
name: imprint
description: After building any UI component, extract the visual patterns that matter for consistency, check them against the project's design tokens, and record them in the UI registry — a short main file read in full (Index, Baseline, cross-cutting rules) and an entries file read one entry at a time — so every component built next matches what came before. Also audits the registry's own hygiene and migrates a single-file registry. Paths, component folders and token source are read from the project's CLAUDE.md and stack manifest, never hardcoded.
model: sonnet
---

> Fork aerial33 du skill JavaScript Mastery — différences dans FORK-NOTES.md.

Components built in isolation drift (spacing, colors, radius, raw values bypassing the design system).
This skill reads what was just built, checks it against the tokens, and records the patterns that matter
so every next component matches — in a registry that stays cheap to read.

---

## How to Invoke

```
/imprint                 # capture from the most recently built/modified component(s)
/imprint [filepath]      # capture from a specific file
/imprint audit           # scan the whole UI and the registry, find conflicts, establish the baseline
/imprint audit registry  # registry hygiene only (no component scan) — cheap, run it often
/imprint migrate         # single-file registry → main file + entries file (form only)
```

Run `/imprint audit` first on any project whose UI was not tracked from the beginning.

---

## Step 0 — Resolve the project layout

Never assume paths. Resolve them, in this order:

1. **`CLAUDE.md`** (project root)
   - its reading list (§1) → the files to read for **UI / interface** work
     (in agent-starter: `context/ui-tokens.md`, `context/ui-rules.md`, `context/state/ui-registry.md`,
     `context/designs/`);
   - its **state boundaries** table (§4) → the exact paths of the **UI registry** (main file) and of the
     **UI registry entries** file. Only one registry path declared → older single-file layout: outside
     `migrate`, say so, propose `/imprint migrate` and write nothing.
2. **Stack manifest** — `context/stack/stack.md` (or the manifest `CLAUDE.md` points to):
   - **component folders to imprint**;
   - **folders to exclude** (generated code, component-library primitives);
   - the **token source file** (e.g. a CSS file with theme variables exposed through `@theme`) — the
     single source of values, organised as the manifest describes;
   - the component library in use, if any.
3. **Fallback** — if `CLAUDE.md` or the manifest is missing, or a value is not declared: say which one
   is missing and **ask the developer**. Do not guess a folder, and never create the registry anywhere
   other than the declared paths.

State the resolved values in one line before continuing, e.g.
`Registry: context/state/ui-registry.md + ui-registry-entries.md · Components: src/components/**, src/blocks/** · Tokens: src/app/(frontend)/globals.css`.

**How to read the registry**

- **Main file**: always in full — it is kept small for that.
- **Entries file**: never in full. For each component you update, reuse or imitate:
  `grep -n '^### <Name>' <entries file>`, then read about 40 lines from the line found (Read with
  `offset`/`limit`, or `sed -n 'N,+40p'`). Unsure of the name → find it in the Index first.
- `audit` and `migrate` go through this skill's script, and open only the entries its report points to:
  `sh <skill folder>/scripts/registry.sh check <main> <entries> <decisions log>` (run from the project
  root), `… split <single> <main> <entries>`, `… verify <single> <main> <entries>`.

---

## Step 1 — Load the design source of truth

Read the token source file and the UI files resolved in Step 0. Build the canonical reference:

- the color tokens (roles) — the default for every color;
- the **declared palette exceptions** in the visual rules (e.g. an "Exceptions palette" section):
  framework palette classes allowed for listed cases only (charts, categories, overlays…);
- the border-radius scale;
- the typography variables;
- the spacing conventions and the visual rules (including the project's "do nots").

A component that uses a raw hex or arbitrary value is a **violation to flag**, not a pattern to record.
A palette class outside the declared exceptions is a **warning** to surface (it should become a role,
a token, or a declared exception).

---

## Step 2 — Find what was just built

If a filepath was provided — read that file.

Otherwise, identify the most recently created or modified files **inside the component folders
declared in the manifest**. Skip everything in the **excluded folders**, and never imprint the
**styleguide / page témoin** declared in the manifest (it showcases the tokens, it is not a component).
When a custom component wraps a primitive of the component library, do not imprint the primitive —
note which one it wraps. When a component comes from an external source declared in the project's
design brief (`designs/brief.md`), note that source in the entry's **Type**.

If it is unclear which files to capture from, ask:

```
Which component should I capture patterns from?
```

---

## Step 3 — Extract what matters, and check against tokens

Extract only what affects visual consistency: background, border (color/width/style), border radius,
text colors, text sizes/weights, spacing (padding, gaps), interactive states (hover/focus/active),
shadow, accent/brand usage.

Do not extract: width/height, flex/grid layout, positioning/z-index, animation timing (unless an
enforced pattern), responsive variants (capture the base only).

For each extracted value, check conformance:

- color backed by a token? ✅ — palette class within a declared exception? ✅ (mark `exception (…)`) —
  palette class outside the exceptions? ⚠️ warning — raw hex / arbitrary value? ⚠️ violation;
- radius on the defined scale? ✅ — off-scale value? ⚠️ flag it;
- spacing matches the convention? ✅ — outlier? ⚠️ note it.

---

## Step 4 — Write to the UI registry

Open the entry to update (Step 0, *How to read*); create the files from the kit templates if missing.
Add a new entry, or update the existing one **in place**. Never duplicate. Every write updates the
Index in the same edit.

### Layout — two files

| Main file (read in full, keep under 10 KB) | Entries file (read one entry at a time) |
| ------------------------------------------ | --------------------------------------- |
| header (reading rule), then **Index**, then **Baseline**, then the **cross-cutting sections**, in this order | header (reading rule), then `## <Family>` headings in Index order, each with its `### <Name>` entries |

- A cross-cutting section lives **only** in the main file, after the Baseline — never between entries
  (the entries after it would read as its sub-sections).
- The header of each file says how to read both (kit templates: `context/method/state/` or the kit's
  `method/state/`). Keep it.

### The Index

```markdown
## Index

**[Family]**
- **[Name]** — `[file or folder]` — [type, short] — [the rule that matters + when to open the entry]
- Transverse : § [section title] — [what it governs]
```

- One line per component, **160 characters at most**. It gives the rule that matters and enough to
  know *when* to open the entry — not a summary of the entry.
- Lines grouped under family labels (the project's own: e.g. admin, gateways, heros, blocks,
  navigation and frame, content…), in the **same order** as the entries file.
- Cross-cutting section lines come last.

### The Baseline

`## Baseline` then `Last updated: [date] (/imprint audit)`, the standard table, and **Deviations**: one
line per component, with a one-line pointer where the point is tracked. Corrected **in place** when a
source or a rule changes — never a correcting section added further down.

### Entry format

```markdown
### [Component Name]

File: [filepath]
Type: [component | content block | wraps <library>:<primitive> | external:<source>]
Last updated: [date]

| Property | Class |
| -------- | ----- |
| [only the properties that have a value] | [class] — [only if needed: `exception (…)`, `⚠️ …`, a contrast ratio] |

**Pattern notes:** [what it takes to build or review the component]
**Token violations:** [only if there is one]
```

- Table properties come from: Background, Border, Border radius, Text — primary, Text — secondary,
  Spacing, Hover state, Shadow, Accent usage. **No row** for an empty property (no `none`, no `—`); no
  compliance column — a compliant class carries no mark.
- `Last updated` is the only date in the entry, with nothing after it.
- **Pattern notes**: rendering, variants, accessibility, usage — **about ten lines at most**. Never in
  the notes (write it where it belongs, leave at most a one-line pointer):
  - history — feature or step references, "milestone review…", "decided on…" → decisions log;
  - open points — "to decide", "risk", "provisional, to revisit" → Open Questions of the progress tracker;
  - logic or data — queries, validation, access filtering → `context/architecture.md`;
  - a rule that holds beyond the component (cited by two entries or more) → a cross-cutting section of
    the main file when it governs a family of components, `context/ui-rules.md` when it is a general
    visual rule; the entries keep a pointer.

### Removed component

Its entry and Index line are removed once any rule it carried has moved (cross-cutting section,
`ui-rules.md`), with one line in the decisions log. This is the only removal.

---

## Step 5 — Confirm and flag

```
Imprinted [Component Name] → [entries file] (+ Index)
Captured: bg [class] · border [class] · radius [class] · text [classes] · spacing [classes] · hover [class]
```

If any value bypassed the design system, surface it — never record it silently:

```
⚠️ Token violations in [Component Name]:
- [class/value] should be [token]
Fix these to keep the design system intact.
```

If the main file is now over 10 KB, say so and propose `/imprint audit registry`.

---

## Audit and migration

`/imprint audit`, `/imprint audit registry` → read **only** `modes/audit.md` in this skill's folder.
`/imprint migrate` → read **only** `modes/migrate.md`. The normal mode needs neither.

---

## The Rule

Build a component. Run `/imprint`. Move on. Every time.
A registry that matches the tokens is a design system that enforces itself; a registry that stays
short is one that actually gets read.
