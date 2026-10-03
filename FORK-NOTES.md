# Fork Notes

`/architect`, `/review`, `/imprint` et `/remember` sont des forks des skills JavaScript Mastery ; `/recover` est d'origine.
`/design-system` (skill de méthode), `nextjs-lint-setup` et `tailwind-v4` (skills de stack) sont des skills aerial33
originaux, hors périmètre de ces notes.

## Historique

| Version | Date | Changement |
| ------- | ---- | ---------- |
| v0 | 2026-09 | Premier fork, spécifique Next.js + Payload + Tailwind, chemins et secrets écrits en dur (ancien kit agent-starter). |
| v1 | 2026-10-01 | **Agnostique** : plus aucun chemin, dossier ni nom de secret en dur. Tout est lu dans `CLAUDE.md` et le manifeste de stack (`context/stack/stack.md`). Aligné sur le kit agent-starter en 4 couches (`context/state/`, `ui-tokens`/`ui-rules`, `build-plan`). |
| v1.4 | 2026-10-03 | **Parties et jalons** : `/architect` regroupe les étapes en parties au-delà d'environ 6 étapes ; `/review jalon` (couches 1–2 sur une partie) ; `/remember` note la partie courante. |
| v1.3 | 2026-10-03 | **Plans persistés** : `/architect` forké (plan écrit dans le dossier de plans de `CLAUDE.md` §4, brouillon → validé, étapes atomiques `F05.1`…, écarts consignés) ; `/review` forké (référentiel = plan persisté ou entrée du build-plan) ; `/remember` renvoie au plan actif. |
| v1.1 | 2026-10-02 | `/imprint` : la page témoin n'est jamais imprintée ; un composant externe déclaré dans `designs/brief.md` est noté comme tel. Ajout du skill original `/design-system` (variantes provisoire / complète de F00). |

## /architect — différences avec l'original

| Changement | Pourquoi |
| ---------- | -------- |
| **Step 0 — résolution du layout** : dossier de plans (`CLAUDE.md` §4), build-plan, glossaire, commande de vérification | Le plan a un domicile déclaré ; pas de chemin en dur. |
| Plan **écrit dans un fichier** `<ID>-<slug>.md`, statut **brouillon** puis **validé** après confirmation explicite | L'original laissait le plan dans la conversation : perdu à la coupure de session, introuvable pour `/review`. Le brouillon survit à une session coupée avant validation. |
| **Étapes atomiques** `<ID>.<n>` : une frontière, une vérification, commande de vérification au vert | Implémentation pas à pas, reprise possible à une étape précise. |
| **Parties et jalons** au-delà d'environ 6 étapes ; partie livrable seule → feature distincte | Revue et coupure de session à des points testables ; détecte une entrée de build-plan trop grosse. |
| Sections **Hors périmètre** et **Écarts au plan** | `/review` distingue l'écart déclaré de la dérive. |
| Plan validé **figé** ; écart sur une décision → arrêt et accord ; nouveau plan = `-v2` + ancien « remplacé » | La trace de ce qui était prévu reste lisible. |
| Termes alignés reportés au glossaire | Le vocabulaire ne vit pas que dans un plan. |

## /review — différences avec l'original

| Changement | Pourquoi |
| ---------- | -------- |
| Référentiel de la couche 1 : **plan persisté** (étapes, écarts, hors périmètre), à défaut l'**entrée du build-plan** | Une feature sans `/architect` a quand même un critère ; on ne demande au développeur qu'en dernier recours. |
| Dérive non déclarée = sévérité *Important* (*Critical* si elle touche une décision) | La règle « plan figé + écarts » devient vérifiable. |
| Mode **`/review jalon`** : couches 1 et 2 sur une partie et son jalon | Corriger une dérive après 3 étapes plutôt qu'à la fin ; la couche 3 reste globale. |
| Ne modifie jamais le plan | La review informe, elle ne corrige pas. |

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
| Champ **Active plan** ; save vérifie cases et écarts du plan, restore le relit ; « Next session » cite l'étape (`F05.3`) | Le handoff renvoie au plan au lieu de le recopier. |

## Coût du fork

- Plus de mise à jour automatique depuis JSM : réinstaller `JavaScript-Mastery-Pro/skills` écraserait ces quatre skills.
- Les skills dépendent du **contrat** du kit agent-starter : `CLAUDE.md` avec §1 (lecture) et §4
  (frontières d'état, dont le dossier de plans), et un manifeste de stack avec les sections Dossiers, Secrets, Commande de
  vérification. Si ce contrat change, mettre à jour les skills.
