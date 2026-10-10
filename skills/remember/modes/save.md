# /remember save

> Prerequisite: Step 0 of `SKILL.md`.

**Secrets.** Never write one: redact (`[REDACTED]`) every name listed under Secrets in the stack
manifest and anything credential-like (connection strings, API keys, tokens, OAuth secrets, storage
credentials, webhook secrets, cookies, auth headers, passwords, private keys, certificates, one-time
codes). In doubt, treat it as sensitive.

## Step 1 — Progress tracker (status only)

- Tick completed features with **build-plan IDs** (`F04`); never invent one — work with no entry: say so,
  ask whether to add it to the build plan.
- Update **Current Status** (phase, last completed, next); add new **open questions**, remove the ones
  answered (the answer is a decision → Step 2).
- The tracker keeps its three sections only. If it still holds a decisions or notes section and §4
  declares a decisions log, propose moving them there verbatim — never without agreement.

## Step 2 — Durable decisions

- One line per decision in the **decisions log**: `AAAA-MM-JJ — <ID> — <decision> — <why>`.
- A decision that **constrains future code** (convention, boundary, library, UI rule) is also written in
  the rule file that governs it (method § "Keeping docs in sync"), where tasks will read it.
- Decisions already in the active plan stay there; at feature end, only those that outlive it go to the log.
- Frictions, workarounds, traps → the log's **Notes** (a library trap also to its library docs).

## Step 3 — Active plan (status `en cours`)

Every step **verified** this session is ticked (never an unverified one; same for a milestone), and
every deviation has its dated line in **Écarts au plan** — never rewrite the plan. Fix or report what is
missing before the handoff.

## Step 4 — Handoff (memory file)

For an equally skilled colleague who knows nothing of today. **About 60 lines**: point to the plan,
tracker and log instead of restating them. Never: details visible in the code, decisions already
recorded, how it was built, a secret.

```markdown
# Memory — [Feature or Session Name]
Last updated: [date and time]

## What was built          ← precise: files, entities, routes, components; commits
## Data-model / schema changes   ← and whether a migration was generated and applied
## Env vars needed         ← names only
## Problems solved         ← one line each; details in the log's Notes
## Current state           ← works / partial / broken
## Gate status             ← result of the manifest's gate command at save time; failing step
## Active plan             ← path, status, current part, last ticked step — or "none"
## Next session starts with ← next action with build-plan ID and plan step (e.g. "F07.5, part B"), and
##                            its kind (UI, data model, code…) so restore loads the right files
## Open questions          ← or a pointer to the tracker
```

Re-read for secrets before writing. If the file has content, summarise it in one line and ask
`Overwrite with this session's memory? (yes / no)` — no → "No changes made."

Then: `Memory saved to [path]. Status in [tracker], decisions in [log]. Next session: /remember restore.`
