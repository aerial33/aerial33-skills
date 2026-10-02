---
name: imprint
description: After building any UI component, extract the visual patterns that matter for consistency, check them against the project's design tokens, and record them in the UI registry — so every component built next matches what came before and uses the design system instead of bypassing it. Paths, component folders and token source are read from the project's CLAUDE.md and stack manifest, never hardcoded.
---

> FORK aerial33 du skill JavaScript Mastery. Différences vs original : contrôle de conformité aux
> tokens (pas un simple enregistrement), exclusion du code généré, et **aucun chemin en dur** — tout
> est lu dans `CLAUDE.md` et le manifeste de stack du projet (architecture agent-starter).
> Voir FORK-NOTES.md.

UI consistency does not happen by accident. It happens because every component is built with
awareness of what already exists — and against a single source of design truth.

Each AI-built component tends to be built in isolation: spacing drifts, colors vary, radius is
inconsistent, and raw values creep in that bypass the design system. This skill reads what was just
built, checks it against the canonical tokens, extracts the patterns that matter, and records them so
every future component can match.

---

## How to Invoke

```
/imprint              # capture from the most recently built/modified component(s)
/imprint [filepath]   # capture from a specific file
/imprint audit        # scan the whole UI, find conflicts, establish a baseline
```

Run `/imprint audit` first on any project whose UI was not tracked from the beginning.

---

## Step 0 — Resolve the project layout

Never assume paths. Resolve them, in this order:

1. **`CLAUDE.md`** (project root)
   - its reading list (§1) → the files to read for **UI / interface** work
     (in agent-starter: `context/ui-tokens.md`, `context/ui-rules.md`, `context/state/ui-registry.md`,
     `context/designs/`);
   - its **state boundaries** table (§4) → the exact path of the **UI registry**.
2. **Stack manifest** — `context/stack/stack.md` (or the manifest `CLAUDE.md` points to):
   - **component folders to imprint**;
   - **folders to exclude** (generated code, component-library primitives);
   - the **token source file** (e.g. a CSS file with theme variables exposed through `@theme`) — the
     single source of values, organised as the manifest describes;
   - the component library in use, if any.
3. **Fallback** — if `CLAUDE.md` or the manifest is missing, or a value is not declared: say which one
   is missing and **ask the developer**. Do not guess a folder, and never create the registry anywhere
   other than the declared path.

State the resolved values in one line before continuing, e.g.
`Registry: context/state/ui-registry.md · Components: src/components/**, src/blocks/** · Tokens: src/app/(frontend)/globals.css`.

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

- color backed by a token? ✅ — palette class within a declared exception? ✅ (note "exception") —
  palette class outside the exceptions? ⚠️ warning — raw hex / arbitrary value? ⚠️ violation;
- radius on the defined scale? ✅ — off-scale value? ⚠️ flag it;
- spacing matches the convention? ✅ — outlier? ⚠️ note it.

---

## Step 4 — Write to the UI registry

Open the registry at the path resolved in Step 0. Create it there if missing. Append a new entry, or
update the existing entry if this component type is already registered. Never duplicate.

### Entry format

```markdown
### [Component Name]

File: [filepath]
Type: [component | content block | wraps <library>:<primitive> | external:<source>]
Last updated: [date]

| Property         | Class           | Token-compliant? |
| ---------------- | --------------- | ---------------- |
| Background       | [class]         | yes / exception / ⚠️ no |
| Border           | [class]         | yes / ⚠️ no       |
| Border radius    | [class]         | yes / ⚠️ no       |
| Text — primary   | [class]         | yes / ⚠️ no       |
| Text — secondary | [class]         | yes / ⚠️ no       |
| Spacing          | [class]         | yes / ⚠️ no       |
| Hover state      | [class]         | yes / ⚠️ no       |
| Shadow           | [class or none] | —                |
| Accent usage     | [class or none] | yes / ⚠️ no       |

**Pattern notes:** [why a class was chosen, what this component should always match, allowed variations]
**Token violations:** [list any non-token values found, or "none"]
```

---

## Step 5 — Confirm and flag

```
Imprinted [Component Name] → [registry path]
Captured: bg [class] · border [class] · radius [class] · text [classes] · spacing [classes] · hover [class]
```

If any value bypassed the design system, surface it — never record it silently:

```
⚠️ Token violations in [Component Name]:
- [class/value] should be [token]
Fix these to keep the design system intact.
```

---

## Audit Mode — /imprint audit

### Step 1 — Scan

Resolve the layout (Step 0) and load the tokens (Step 1). Read every file in the declared component
folders, applying the exclusions.

### Step 2 — Identify conflicts against the tokens

```
## UI Consistency Audit

### Conflicts found
**Border radius** — [variants found] → standardise on [token-scale value]
**Background colors** — [classes found; flag any raw hex] → [token classes]
**Text colors** — [classes found; flag any bypassing tokens] → [token classes]
**Spacing** — [variations] → [standard]
**Border colors** — [classes found] → [token class]
**Interactive states** — [variants] → [standard]

### Token violations (must fix)
[Every raw hex / arbitrary value, with file and line]

### Palette warnings (decide)
[Every palette class outside the declared exceptions, with file and line → role, new token, or new exception]

### Recommended baseline
[The correct pattern per property — based on the tokens and what the majority already uses correctly]
```

### Step 3 — Wait for confirmation

Do not fix anything, do not write the registry yet.

```
Audit complete. [X] conflicts, [Z] token violations across [Y] properties.
Confirm the baseline and I will write it to the UI registry.
```

### Step 4 — Write the confirmed baseline

Write it to the registry, labelled `## Baseline — Established [date] via /imprint audit`, then list the
components that deviate: file → what's wrong → what it should be.

---

## The Rule

Build a component. Run `/imprint`. Move on. Every time.
A registry that matches the tokens is a design system that enforces itself.
