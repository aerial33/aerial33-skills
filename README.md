# aerial33 / skills

Fork des [Agent Skills JavaScript Mastery](https://github.com/JavaScript-Mastery-Pro/skills), adapté
à l'architecture **agent-starter** (kit de contexte en 4 couches : méthode, stack, modules, projet).

Cinq slash-commands qui donnent à un agent IA la discipline d'ingénierie qu'il n'a pas par défaut :
réflexion avant de coder, review structurée, récupération sur incident, cohérence UI, mémoire entre sessions.

## Principe : aucun chemin en dur

Les skills ne connaissent **ni la stack ni l'emplacement des fichiers**. Ils lisent :

| Source | Ce que les skills y prennent |
| ------ | ---------------------------- |
| `CLAUDE.md` du projet — §1 lecture | quels fichiers lire (toujours / selon la tâche) |
| `CLAUDE.md` du projet — §4 frontières d'état | chemins du progress tracker, du fichier memory, du UI registry |
| `context/stack/stack.md` (manifeste de stack) | dossiers de composants, exclusions, fichier de tokens, noms des secrets, commande de vérification |
| `context/build-plan.md` | IDs des features (F01, F02…) |

Conséquence : le même jeu de skills sert toutes les stacks. Changer de stack = changer le manifeste,
pas les skills. Si une information manque, le skill le dit et demande — il n'invente pas de chemin.

## Skills

| Skill | Quand | Statut |
| ----- | ----- | ------ |
| `/architect` | Avant toute feature complexe | Original JSM |
| `/review` | Après chaque feature | Original JSM |
| `/recover` | Quand quelque chose casse | Original JSM |
| `/imprint` | Après un composant UI | **Forké** — contrôle aux tokens, lit le manifeste |
| `/remember` | Fin & début de session | **Forké** — frontière d'état, lit CLAUDE.md et le manifeste |

### Skills de stack

À la différence des skills de méthode, ceux-ci connaissent une stack. Le manifeste de stack du kit
agent-starter (`context/stack/stack.md`) indique lesquels utiliser.

| Skill | Stack | Quand | Statut |
| ----- | ----- | ----- | ------ |
| `nextjs-lint-setup` | Next.js 15+ (conventions Payload) | Initialiser ou mettre à jour ESLint + Prettier | Original aerial33 |

`/architect`, `/review`, `/recover` restent d'origine : ils lisent « les fichiers de contexte » sans
chemin précis, leur adaptation passe par le contenu du contexte (invariants, checklist).
Détail des différences : [`FORK-NOTES.md`](FORK-NOTES.md).

## Installation

### Tant que le dépôt n'est pas publié (local)

Claude Code lit les skills dans `~/.claude/skills/<nom>/SKILL.md` (tous les projets) ou
`.claude/skills/<nom>/SKILL.md` (un projet). Lien symbolique depuis ce dépôt, pour que chaque
modification soit prise en compte :

```bash
for s in architect review recover imprint remember nextjs-lint-setup; do
  ln -sfn ~/Codes/personal-projects/aerial33-skills/skills/$s ~/.claude/skills/$s
done
```

⚠️ Si les skills JSM d'origine sont déjà installés sous les mêmes noms, les retirer d'abord pour
éviter deux versions concurrentes.

### Une fois publié

```bash
npx skills@latest add aerial33/skills
```

## Workflow

```
Feature complexe       → /architect → (valider le plan) → implémenter
Après la feature       → /review
Après un composant UI  → /imprint
Problème (> 1 prompt)  → /recover
Fin de session         → /remember save
Reprise de session     → /remember restore
```

## Crédits & licence

Travail original : **JavaScript Mastery** — https://github.com/JavaScript-Mastery-Pro/skills
Modifications (`/imprint`, `/remember`) : **aerial33**. Licence MIT (voir `LICENSE`).
