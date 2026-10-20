---
name: review
description: After building a feature, verify it matches what was planned, respects the system architecture and design standards, and is ready for production. Reads the persisted /architect plan (steps, deviations) or the build-plan entry as the benchmark. Reports issues clearly so the developer decides what to fix.
model: opus
---

> Fork aerial33 du skill JavaScript Mastery — différences dans FORK-NOTES.md.

Building is done when the code is correct, not when it runs. Run this after every feature, before moving
on: it catches drift from the plan, the architecture and the design system before it compounds.

## How to Invoke

```
/review              # full review, after the feature — all three layers
/review jalon [A]    # milestone review, when a plan part is done — layers 1 and 2, that part only
```

A **milestone review** (`jalon`) applies only to plans split into parts. Scope it to the steps of that
part and its milestone: Layer 1 (plan alignment, milestone check included) and Layer 2 (system
integrity). Skip Layer 3 — production readiness is checked once, on the whole feature. Without a part
letter, take the last part whose milestone is ticked. Without parts in the plan, say so and run a full review.

**It fixes nothing**: it reports, the developer decides.

---

## Step 1 — Understand What Should Have Been Built

Before reviewing anything, establish the benchmark.

Resolve paths first — never assume them: the **plans folder** comes from the state boundaries table of
`CLAUDE.md` (§4), the **build plan** and the context files from its reading list (§1).

Read in this order:

- The **plan** of the feature in the plans folder (`<ID>-*.md`; if several, the one not marked
  `remplacé`). Its **Écarts au plan** are part of the benchmark: a recorded deviation is planned work.
- The feature's **build-plan entry** (its "done when" criterion)
- The feature description or task that was given
- Any relevant context files — architecture boundaries, code standards, design rules

No plan file is normal for a feature that did not go through `/architect`: the build-plan entry is then
the benchmark. If neither exists, ask the developer to describe what the feature was supposed to do
before reviewing. You cannot verify correctness without knowing what correct looks like.

---

## Step 2 — Review in Three Layers

### Layer 1 — Does it match the plan?

Compare what was built against what was planned.

Check:

- Every part of the feature description — is it all there?
- The decisions made during planning — are they reflected in the code?
- The scope — did the implementation stay within bounds or add things that were not asked for?

If a plan file exists, also check:

- **Steps** — every step ticked? For each one, does its written verification still hold?
- **Milestones** — for each part in scope, is the milestone ticked and does its end-to-end check hold?
- **Deviations** — every difference between the code and the plan is covered by a line in
  **Écarts au plan**. An unrecorded difference is **undeclared drift**.
- **Decisions** — a deviation that changes a decision carries the developer's agreement.
- **Out of scope** — nothing listed under **Hors périmètre** was built.

Flag anything that was planned but missing. Flag anything that was built but not planned.

### Layer 2 — Does it respect the system?

This is where AI drift most commonly happens. The feature works, but it violates rules that the project depends on.

Check:

- **Architecture boundaries** — does code in the right place own the right responsibilities? No UI logic in API routes. No DB calls in components. Whatever the project's boundaries are — are they respected?
- **Design system** — are the correct tokens, classes, and patterns used? Any hardcoded values that should be variables? Any raw color classes that should use the design system?
- **Code standards** — naming conventions, file organisation, TypeScript strictness, error handling patterns — do they match what the project established?
- **Existing patterns** — does this feature introduce a new pattern when an existing one should have been used?
- **Duplication and dependencies** — does the diff copy logic that already exists in the repo (a utility, a component, a query) instead of reusing or extending it? Does it add a dependency (`package.json` or equivalent)? If so: is it justified in the plan or the decisions log, and is its role not already covered by an installed package or by the stack itself (the stack's code standards list what it provides)?

### Layer 3 — Is it production ready?

Check:

- Error handling — what happens when things go wrong? Are errors caught and handled or does the feature silently fail?
- Edge cases — empty states, loading states, missing data — are these handled?
- Console errors — any errors or warnings in the browser or terminal?
- Obvious bugs — anything that would clearly break for a real user?

---

## Step 3 — Report What You Found

After completing all three layers, produce a clear report. Do not bury issues. Do not soften them. Report honestly so the developer can make informed decisions.

```
## Review — [Feature Name]

### Layer 1 — Plan alignment
Benchmark: [plan path · status · part reviewed, if milestone review] or [build-plan entry]
[PASS / ISSUES FOUND]
[List any gaps between what was planned and what was built, unticked steps, undeclared drift]

### Layer 2 — System integrity
[PASS / ISSUES FOUND]
[List any architecture, design, or code standard violations]

### Layer 3 — Production readiness
[PASS / ISSUES FOUND]
[List any error handling gaps, edge cases, or obvious bugs]

### Summary
[X] issues found across [Y] layers.

[If no issues: "No issues found. This feature is ready to ship."]
[If issues: "Resolve the above before moving to the next feature."]

### Tag git
To set once the review is settled, the gate is green and the commit is made:
git tag -a <tag> -m "<message>"
```

**Tag git.** Close every report with the tag to set, ready to copy. Name and message follow the
**Tags git** convention of the method file (`ai-workflow-rules.md`, path from the reading list of
`CLAUDE.md` §1). With the agent-starter kit:

- milestone review → `<id>-jalon-<part>` in lowercase (`f06-jalon-a`), message `F06 A — <part title>`;
- full review → the plan file name without `.md` (`f06-media-stockage`), or `<id>-<slug>` of the
  build-plan entry when there is no plan; message `F06 — <feature title> (terminé)`.

If the method file has no such section, use this convention and say so. Run `git tag -l '<id>-*'`
first: a tag that already exists is reported, never moved.

---

## Step 4 — Let the Developer Decide

After the report, stop: no fixes, no fix suggestions unless asked. Wait for the developer to ask for a
fix, mark an issue as intentional, or confirm everything is resolved.

This skill never edits the plan. Once the developer confirms the review is settled and the gate has
passed, the plan's status can move to `terminé` — as part of building, not of reviewing.

The tag works the same way: never set during the review. Once the developer confirms, the issues are
settled, the gate is green and the commit is made, remind them of the tag from the report — or set it
on that commit if they ask (annotated, `git tag -a`). A full review's tag goes on the commit of the
`/remember save` that closes the feature.

---

## Severity Guide

Not all issues are equal. Use this to help the developer prioritise:

**Critical — fix before moving on**

- Architecture boundary violations that will break future features
- Missing error handling that causes silent failures
- Functionality that was planned but completely missing
- Undeclared drift that changes a decision of the plan

**Important — fix soon**

- Design system drift that will cause UI inconsistency
- Code standard violations that will compound across the codebase
- Edge cases that a real user will encounter
- Undeclared drift from the plan (code differs, no line in **Écarts au plan**)

**Minor — fix when convenient**

- Naming inconsistencies that do not affect behaviour
- Missing optimisations
- Style issues that do not affect the design system

Label each issue with its severity so the developer can triage quickly.
