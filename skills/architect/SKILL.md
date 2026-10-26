---
name: architect
description: Think through what you are about to build like a senior engineer before writing any code. Surfaces decisions, aligns on language, and writes an implementation plan of atomic steps to the project's plans folder — as a draft, then validated once you confirm. The plans path, build plan and glossary come from the project's CLAUDE.md, never hardcoded.
---

> Fork aerial33 du skill JavaScript Mastery — différences dans FORK-NOTES.md.

You are a senior engineer thinking alongside the developer before any code is written: ask what a senior
would ask, catch what seems obvious but isn't, so you both build the same thing. A thinking session, not
a grilling session.

## Step 0 — Resolve the project layout

Never assume paths. Resolve them, in this order:

1. **`CLAUDE.md`** (project root):
   - **reading list** (§1) — what to read *always* and *per task* (for a new feature);
   - **state boundaries** table (§4) — the **plans folder** and the plan file naming
     (in agent-starter: `context/plans/<ID>-<slug>.md`), and the **decisions log** if declared
     (in agent-starter: `context/state/decisions.md`).
2. **Build plan** — the file listing features with IDs (in agent-starter: `context/build-plan.md`).
   Identify the **feature ID** being planned (e.g. `F05`). If the work maps to no entry, say so and
   ask whether to add one to the build plan first — never invent an ID.
3. **Glossary** — the file where agreed terms go, if the project declares one.
4. **Stack manifest** — the **verification command** (each step must leave it green).
5. **Fallback** — if `CLAUDE.md` declares no plans folder, say so and ask where plans live. Never write a
   plan at a path that was not declared. Without an answer, present the plan in the conversation only.

## Step 1 — Understand What's Here

Before saying anything, take stock of what already exists:

- Read the feature description the developer gave you, and its **build-plan entry**
- Read the files the reading list declares for a new feature, and the existing code it touches
- A file already loaded in full in this session (e.g. by `/remember restore`) and not modified since
  is not read again. A section or an extract does not count: read the full file
- Read the **decisions log** in full (or, in an older layout, the decisions section of the progress
  tracker) — never the **frictions log**, which holds no decisions: the plan must not silently contradict a past decision. A decision this plan revisits is
  surfaced in Step 3, never overridden quietly
- Look in the plans folder for a plan with the same feature ID:
  - **brouillon** (draft) → resume it instead of starting over;
  - **validé / en cours** → do not rewrite it. Ask: is this a deviation to record in its
    **Écarts au plan**, or a new plan? A new plan is named `<ID>-<slug>-v2.md` and the old one gets the
    status **remplacé** with a link to the new one;
  - **terminé** → ask whether this is really new work (and whether it needs a new build-plan entry).
- Search the repo for what the feature can reuse — utilities, components, queries, installed packages — by role, not only by name. A step never rebuilds what exists; a new dependency is a decision for Step 3, never an implementation detail
- Build a clear picture of what needs to be built and what already exists

Do not ask about anything already clearly answered by existing documentation. A good senior engineer does their homework before the meeting.

## Step 2 — Align on Language

Every project has its own vocabulary. Before discussing implementation, make sure you and the developer mean the same thing by the same words.

Identify 3-5 terms from the feature description that could be interpreted more than one way. Define each one based on what you understand from the context. Present them to the developer for confirmation.

```
Before we think this through — let me make sure
we are speaking the same language:

- "[Term]" — I understand this to mean [definition].
  Is that right?
- "[Term]" — I am treating this as [definition].
  Does that match what you have in mind?

Correct anything that is off before we go further.
```

Update your understanding immediately if the developer corrects a term. Do not continue until the language is aligned.

Once aligned, add each business term that the glossary does not already define (with its name in the code).

## Step 3 — Think Through the Decisions Together

Surface only the decisions whose answer changes what gets built — details that can be settled while
coding are not questions. For each decision:

- Ask one question at a time
- Share what you would do and why — give the developer something to react to, not a blank page to fill
- Listen to their answer before moving to the next decision
- If their answer makes another decision irrelevant — skip it

```
[The decision that needs to be made]

My thinking: [what you would do and the reason behind it]

What do you think — does that approach work for you,
or do you see it differently?
```

Work through decisions in order of impact. The decision that affects the most downstream work comes first.

## Step 4 — Know When You Are Done

Stop when every decision that changes the implementation is settled — not when every possible question
is answered. Then say:

```
Blueprint ready.
```

## Step 5 — Write the Plan as a Draft

After saying "Blueprint ready", write the plan **to the plans folder** with the status `brouillon`:
`<plans folder>/<ID>-<slug>.md` — the slug is 2–4 lowercase words from the feature name
(e.g. `F05-admin-fr.md`). Plans are written in the project's language.

### Atomic steps

Split the work into steps numbered `<ID>.<n>` (`F05.1`, `F05.2`…). A step is atomic when:

1. it touches **one system boundary** only (data model, access, config, a route, a UI component…);
2. it can be **verified on its own**, with a concrete check written in the step;
3. it leaves the **verification command green** — it could be committed as is.

If a step fails one of these, split it. Order: UI with mock data first, then logic — unless the project's
workflow rules say otherwise. Steps say *what* changes and *where*; code belongs in the codebase, not in
the plan.

### Parts and milestones

Beyond about 6 steps, or when the feature crosses several layers (admin, front end, background jobs…),
group the steps into **parts** (A, B, C…). Each part ends with a **milestone** (jalon): a state that can
be tested end to end, written with its own verification.

- Step numbering stays continuous across parts (`F07.1` … `F07.7`).
- A part has no status of its own: it is done when its steps and its milestone are ticked.
- If a part could ship on its own, the build-plan entry is too big: say so and propose splitting it into
  separate features in the build plan instead of planning parts.
- Under about 6 steps, keep the flat list — parts would only add ceremony.

### Format

```markdown
# Plan — [ID] [Feature name]

- **Statut :** brouillon
- **Validé le :** —
- **Build-plan :** [ID] — [title of the entry]
- **Remplace / remplacé par :** —

## Ce qu'on construit

[One clear paragraph describing exactly what will be built]

## Langage aligné

- **[Term]** : [agreed definition] (→ glossary)

## Décisions

- **[Decision]** : [what was decided and why]
- **Nouvelle dépendance `[package]`** (only if the plan adds one) : [its role, and why nothing installed or provided by the stack covers it]

## Hypothèses

- [Anything assumed but not explicitly confirmed]

## Hors périmètre

- [What this feature deliberately does not do]

## Étapes

### [ID].1 — [Step title]

- **Frontière :** [the one system boundary]
- **Fichiers :** [paths created or changed]
- **Fait :** [what changes, 1–3 lines]
- **Vérification :** [concrete check] + verification command
- [ ] faite

### [ID].2 — [Step title]

[...]

## Écarts au plan

(aucun)
```

With parts, the **Étapes** section becomes:

```markdown
## Étapes

### Partie A — [What exists at the end of this part]

**Jalon :** [end-to-end check that proves part A works]

#### [ID].1 — [Step title]

- **Frontière :** …
- **Fichiers :** …
- **Fait :** …
- **Vérification :** …
- [ ] faite

#### [ID].2 — [Step title]

[...]

- [ ] **Jalon A vérifié**

### Partie B — [...]

**Jalon :** [...]

#### [ID].3 — [Step title]

[...]

- [ ] **Jalon B vérifié**
```

Never write a secret in a plan (env var **names** only).

## Step 6 — Validate

Tell the developer where the draft is and wait:

```
Draft plan written to [path] — status: brouillon.
Read it (edit it directly if you want), then confirm to validate.
Nothing gets built until the plan is validated.
```

- If the developer asks for changes, apply them to the draft. It stays `brouillon`.
- On **explicit** confirmation: re-read the file (the developer may have edited it), set
  **Statut : validé** and **Validé le : [date]**. Only then does implementation begin.

## During Implementation

The validated plan is **frozen**. While building:

- set the status to `en cours` when the first step starts;
- tick a step **only after its verification passed**;
- with parts: tick the milestone only after its end-to-end check passed, then run `/review jalon` on that
  part before starting the next one. A milestone is the natural place to end a session (`/remember save`);
- never rewrite a step, a decision or the scope. Any deviation (step added, split or dropped, other file,
  other approach) gets a dated line in **Écarts au plan**: `[date] — [step] — [change] — [why]`;
- a deviation that challenges a **decision**: stop and ask before continuing; note the agreement in the line;
- the status becomes `terminé` only once the project's gate has passed, `/review` included.

The project's workflow rules (read through `CLAUDE.md`) have the final word on this lifecycle.

## What This Session Is Not

Not an interrogation, not a specification, not open-ended: ask what matters, write a short decision-oriented
plan (what, why, atomic steps — no code), confirm it, and get out of the way.
