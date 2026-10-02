# Fork Notes

`/imprint` et `/remember` sont des forks des skills JavaScript Mastery ; `/architect`, `/review`, `/recover` sont d'origine.
`/design-system` (skill de méthode), `nextjs-lint-setup` et `tailwind-v4` (skills de stack) sont des skills aerial33
originaux, hors périmètre de ces notes.

## Historique

| Version | Date | Changement |
| ------- | ---- | ---------- |
| v0 | 2026-09 | Premier fork, spécifique Next.js + Payload + Tailwind, chemins et secrets écrits en dur (ancien kit agent-starter). |
| v1 | 2026-10-01 | **Agnostique** : plus aucun chemin, dossier ni nom de secret en dur. Tout est lu dans `CLAUDE.md` et le manifeste de stack (`context/stack/stack.md`). Aligné sur le kit agent-starter en 4 couches (`context/state/`, `ui-tokens`/`ui-rules`, `build-plan`). |
| v1.1 | 2026-10-02 | `/imprint` : la page témoin n'est jamais imprintée ; un composant externe déclaré dans `designs/brief.md` est noté comme tel. Ajout du skill original `/design-system` (variantes provisoire / complète de F00). |

## /imprint — différences avec l'original

| Changement | Pourquoi |
| ---------- | -------- |
| **Step 0 — résolution du layout** : chemins lus dans `CLAUDE.md` (registry, fichiers UI) et le manifeste (dossiers, exclusions, fichier de tokens) | Le skill ne casse plus quand le kit ou la stack changent. |
| **Step 1 — lecture des tokens** avant capture | Passe d'un enregistreur passif à un **vérificateur de conformité**. |
| **Exclusions** (code généré, primitives de bibliothèque) lues dans le manifeste | Ne pas imprinter ce qui n'est pas du code du projet. |
| Colonne **Token-compliant?** + section **Token violations** | Conformité visible et actionnable. |
| Audit comparé aux tokens | La baseline s'appuie sur la source de vérité, pas seulement sur la majorité. |
| Si une info manque → **demande**, ne crée jamais le registry ailleurs | Évite les registres en double. |

## /remember — différences avec l'original

| Changement | Pourquoi |
| ---------- | -------- |
| **Frontière d'état** : durable → progress tracker, handoff → memory | L'original mettait tout dans memory. |
| Chemins des fichiers d'état lus dans `CLAUDE.md` §4 | Plus de `memory.md` recréé à la racine. |
| **Restore suit la liste de lecture de `CLAUDE.md` §1** (toujours + fichiers de la prochaine tâche) | Une seule liste de lecture dans le projet ; le skill n'en maintient pas une copie. |
| Progression cochée avec les **IDs du build-plan** ; jamais d'ID inventé | Tracker et build-plan restent alignés. |
| Secrets : liste générique + **noms déclarés par le manifeste** | Sécurité adaptée à la stack sans l'écrire dans le skill. |
| Champ **Gate status** (commande lue dans le manifeste) | La session suivante connaît la baseline. |

## Coût du fork

- Plus de mise à jour automatique depuis JSM : réinstaller `JavaScript-Mastery-Pro/skills` écraserait ces deux skills.
- Les skills dépendent du **contrat** du kit agent-starter : `CLAUDE.md` avec §1 (lecture) et §4
  (frontières d'état), et un manifeste de stack avec les sections Dossiers, Secrets, Commande de
  vérification. Si ce contrat change, mettre à jour les skills.
