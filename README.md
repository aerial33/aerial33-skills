# aerial33-skills

Fork des [Agent Skills JavaScript Mastery](https://github.com/JavaScript-Mastery-Pro/skills), adapté
à l'architecture **agent-starter** (kit de contexte en 4 couches : méthode, stack, modules, projet).

Six slash-commands qui donnent à un agent IA la discipline d'ingénierie qu'il n'a pas par défaut :
réflexion avant de coder, review structurée, récupération sur incident, design system fixé avant la
première page, cohérence UI, mémoire entre sessions.

## Principe : aucun chemin en dur

Les skills ne connaissent **ni la stack ni l'emplacement des fichiers**. Ils lisent :

| Source | Ce que les skills y prennent |
| ------ | ---------------------------- |
| `CLAUDE.md` du projet — §1 lecture | quels fichiers lire (toujours / selon la tâche) |
| `CLAUDE.md` du projet — §4 frontières d'état | chemins du progress tracker, du fichier memory, du UI registry, du dossier de plans |
| `context/stack/stack.md` (manifeste de stack) | dossiers de composants, exclusions, fichier de tokens, noms des secrets, commande de vérification |
| `context/build-plan.md` | IDs des features (F01, F02…) |

Conséquence : le même jeu de skills sert toutes les stacks. Changer de stack = changer le manifeste,
pas les skills. Si une information manque, le skill le dit et demande — il n'invente pas de chemin.

## Skills

| Skill | Quand | Statut |
| ----- | ----- | ------ |
| `/architect` | Avant toute feature complexe | **Forké** — plan persisté (brouillon → validé), étapes atomiques, écarts consignés |
| `/review` | Après chaque feature | **Forké** — compare au plan persisté ou à l'entrée du build-plan |
| `/recover` | Quand quelque chose casse | Original JSM |
| `/design-system` | Avant la première page (F00, provisoire ou complète), puis pour faire évoluer le système | **Original aerial33** — thème par défaut + layout, ou brief, tokens, page témoin, gel ; lit le manifeste |
| `/imprint` | Après un composant UI | **Forké** — contrôle aux tokens, lit le manifeste |
| `/remember` | Fin & début de session | **Forké** — frontière d'état, renvoie au plan actif, lit CLAUDE.md et le manifeste |

### Skills de stack

À la différence des skills de méthode, ceux-ci connaissent une stack. Le manifeste de stack du kit
agent-starter (`context/stack/stack.md`) indique lesquels utiliser.

| Skill | Stack | Quand | Statut |
| ----- | ----- | ----- | ------ |
| `nextjs-lint-setup` | Next.js 15+ (conventions Payload) | Initialiser ou mettre à jour ESLint + Prettier | Original aerial33 |
| `tailwind-v4` | Tailwind CSS v4 (CSS-first) | Écrire ou relire des classes / du CSS Tailwind sans habitudes v3 | Original aerial33 |

`/recover` reste d'origine : il lit « les fichiers de contexte » sans chemin précis, son adaptation
passe par le contenu du contexte (invariants, checklist).
Détail des différences : [`FORK-NOTES.md`](FORK-NOTES.md).

## Installation

### Tant que le dépôt n'est pas publié (local)

Claude Code lit les skills dans `~/.claude/skills/<nom>/SKILL.md` (tous les projets) ou
`.claude/skills/<nom>/SKILL.md` (un projet). Lien symbolique depuis ce dépôt, pour que chaque
modification soit prise en compte :

```bash
for s in architect review recover design-system imprint remember nextjs-lint-setup tailwind-v4; do
  ln -sfn ~/Codes/personal-projects/aerial33-skills/skills/$s ~/.claude/skills/$s
done
```

⚠️ Si les skills JSM d'origine sont déjà installés sous les mêmes noms, les retirer d'abord pour
éviter deux versions concurrentes.

### Une fois publié

```bash
npx skills@latest add aerial33/aerial33-skills
```

## Workflow

```
Début de l'interface   → /design-system neutral (F00 provisoire) ou /design-system (F00 complète)
Feature complexe       → /architect → plan brouillon → (valider) → implémenter étape par étape
Après la feature       → /review
Après un composant UI  → /imprint
Problème (> 1 prompt)  → /recover
Fin de session         → /remember save
Reprise de session     → /remember restore
```

## Crédits & licence

Travail original : **JavaScript Mastery** — https://github.com/JavaScript-Mastery-Pro/skills
Modifications (`/architect`, `/review`, `/imprint`, `/remember`) et skills originaux (`/design-system`, `nextjs-lint-setup`, `tailwind-v4`) : **aerial33**. Licence MIT (voir `LICENSE`).
