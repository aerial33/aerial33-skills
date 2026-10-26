# Fork Notes

`/architect`, `/review`, `/imprint` et `/remember` sont des forks des skills JavaScript Mastery ; `/recover` est d'origine.
`/design-system` (skill de méthode), `nextjs-lint-setup` et `tailwind-v4` (skills de stack) sont des skills aerial33
originaux, hors périmètre de ces notes.

## Historique

| Version | Date | Changement |
| ------- | ---- | ---------- |
| v0 | 2026-09 | Premier fork, spécifique Next.js + Payload + Tailwind, chemins et secrets écrits en dur (ancien kit agent-starter). |
| v1 | 2026-10-01 | **Agnostique** : plus aucun chemin, dossier ni nom de secret en dur. Tout est lu dans `CLAUDE.md` et le manifeste de stack (`context/stack/stack.md`). Aligné sur le kit agent-starter en 4 couches (`context/state/`, `ui-tokens`/`ui-rules`, `build-plan`). |
| v1.11.0 | 2026-10-26 | **Relecture : appelants, tests, non vérifié** (repris de ponytail, sans le plugin) : `/review` couche 2 cherche les usages hors du diff d'un code partagé dont le comportement change (un correctif posé chez un seul appelant est un constat) et signale une logique à risque sans test qui échoue quand elle casse (liste et rangement dans les code standards de la stack) ; rapport avec une rubrique **Not verified** jamais omise. |
| v1.10.0 | 2026-10-26 | **Journal des décisions en vigueur, frictions à part** : `/remember save` écrit une décision dans la section de son domaine (`- **<ID>** — décision — pourquoi`, environ 250 caractères), réécrit ou retire la ligne qu'elle remplace au lieu d'ajouter une correction, résume en une ligne avec renvoi une règle déjà écrite dans un fichier de règles, et envoie frictions, contournements et pièges au **journal des frictions** déclaré en §4 (repli : Notes du journal, ancien format). `/architect` ne lit jamais le journal des frictions. Ancien format (lignes datées, append-only) toujours accepté. |
| v1.9.0 | 2026-10-20 | **Réutiliser avant d'ajouter** : `/architect` cherche par rôle ce que la feature peut réutiliser (utilitaires, composants, requêtes, paquets installés) et traite toute nouvelle dépendance comme une décision du plan, justifiée ; `/review` couche 2 signale le code recopié et toute dépendance ajoutée sans justification ou qui doublonne un paquet installé ou ce que la stack fournit. |
| v1.8.1 | 2026-10-18 | **Aucune perte d'information** : l'en-tête des entrées donne la règle de lecture (propriété absente = aucune valeur, classe sans marque = conforme, pas de ligne Token violations = aucune) ; raccourcir les notes ne supprime jamais rien (déplacement mot pour mot avec renvoi, sinon la note reste longue : dix lignes sont une cible) ; `registry.sh keep` prouve que chaque phrase d'avant est encore quelque part après, et clôt toute migration ou audit. `check` ne signale plus un renvoi aux Open Questions comme un point ouvert. |
| v1.8.0 | 2026-10-18 | **Registre UI en deux fichiers** : `ui-registry.md` (en-tête, Index par familles, Baseline, règles transverses — lu en entier, moins de 10 Ko) et `ui-registry-entries.md` (une entrée par composant, lue à la demande par `grep` + environ 40 lignes). Règles d'écriture dans `/imprint` : Index de 160 caractères au plus, Baseline corrigée sur place, tableau sans lignes vides ni colonne de conformité, notes d'une dizaine de lignes sans historique, point ouvert, logique ni règle partagée. `/imprint audit` contrôle l'hygiène du registre (`scripts/registry.sh check`), `/imprint audit registry` seul ; `/imprint migrate` découpe un registre à un fichier, forme seulement, vérifiée par le script. Modes `audit` et `migrate` sortis dans `modes/` (chargés à la demande). Mesuré sur le boilerplate : registre lu à chaque tâche d'interface 83,3 Ko → 8,7 Ko. |
| v1.7.1 | 2026-10-10 | **Modèle fixé dans l'en-tête** (`model:`, valable pour le tour qui lance le skill, la session reprend son modèle ensuite) : `/remember` et `/imprint` en Sonnet (restore testé : même résultat qu'en Opus), `/review` en Opus. Pas `/architect` : c'est un dialogue sur plusieurs tours, le modèle reviendrait à celui de la session dès la première réponse — passer par le mode plan (`opusplan`). |
| v1.7.0 | 2026-10-10 | **Nettoyage** : `/remember` réécrit sans redites (restore 10,6 k → 6,4 k caractères chargés, save 9,9 k → 5,5 k) ; bandeaux de fork réduits à une ligne et prose de motivation condensée dans `/architect`, `/review`, `/imprint` (formats et règles inchangés). |
| v1.6.3 | 2026-10-10 | **Lecture en un appel** : `remember/scripts/read-sections.sh` imprime fichiers et sections déclarés, sans numéros de ligne ; seuls le memory file et le plan actif (édités ensuite) passent par l'outil de lecture. **Handoff corrigé au restore** : en cas d'écart mémoire ↔ plan ↔ git, proposition de corriger ces lignes seulement. Mesuré en 1.6.2 : lire les mêmes fichiers sans skill = 42,2k tokens (l'outil de lecture charge les fichiers entiers : build-plan, architecture, registre) ; restore complet = 50,6k. |
| v1.6.2 | 2026-10-10 | **Restore borné** : lectures déclarées + 3 commandes git au plus, aucune enquête (code, services, recherches) ; ce qui reste à vérifier est proposé (« To check »). **Index du registre UI** : `/imprint` tient une ligne par composant en tête du registre ; les sessions lisent Index + Baseline, l'entrée complète seulement pour le composant concerné. Mesuré en 1.6.1 : restore = 49,8k puis 57,3k tokens sur le même état, dont 25 à 33k d'exploration non demandée. |
| v1.6.1 | 2026-10-10 | Restore **nouvelle feature** allégé : entrée du build-plan + recherche (grep) dans le journal des décisions ; overview, glossaire et journal complet laissés à `/architect`. `/architect` ne relit pas un fichier déjà chargé en entier dans la session. Mesuré sur le boilerplate : 82,6k tokens après un restore *nouvelle feature* en 1.6.0. |
| v1.6 | 2026-10-10 | **Restore allégé** : `/remember` découpé en tronc commun + `modes/save.md` / `modes/restore.md` (un seul chargé) ; restore en deux modes (reprise : plan entier + entrée du build-plan ; nouvelle feature : ligne « Nouvelle feature »), lecture par **sections** (invariants, entrée du build-plan), `CLAUDE.md` non relu s'il est déjà en contexte. Décisions durables → **journal des décisions** (`CLAUDE.md` §4), plus dans le tracker ; `/architect` lit ce journal avant de planifier. |
| v1.5 | 2026-10-07 | **Tags git** : `/review` termine son rapport par le tag à poser (`<id>-jalon-<partie>` au jalon, nom du plan en fin de feature), selon la section *Tags git* de la méthode. |
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
| Rapport terminé par le **tag git** à poser (jalon ou fin de feature), jamais posé pendant la review | L'avancement du plan se lit dans `git tag` ; le tag n'arrive qu'après accord, gate verte et commit. |
| Ne modifie jamais le plan | La review informe, elle ne corrige pas. |
| Couche 2 : **usages hors du diff** d'un code partagé dont le comportement ou la valeur de retour change | TypeScript attrape une signature cassée, pas un comportement changé ; boilerplate F08 B : un correctif a introduit une régression trouvée au tour suivant seulement. |
| Couche 2 : **tests manquants** sur une logique à risque (accès, hook conditionnel, validation, utilitaire à branches, écriture de données, correction de bug) | 91 fichiers de test dans le boilerplate, mais aucune règle ne disait quand une feature doit en ajouter un. |
| Rubrique **Not verified** obligatoire dans le rapport | Un contrôle non fait passait pour réussi ; boilerplate : un état absent de la page témoin (vidéo à 0 px) n'avait pas été vérifié. |

## /imprint — différences avec l'original

| Changement | Pourquoi |
| ---------- | -------- |
| **Step 0 — résolution du layout** : chemins lus dans `CLAUDE.md` (registry, fichiers UI) et le manifeste (dossiers, exclusions, fichier de tokens) | Le skill ne casse plus quand le kit ou la stack changent. |
| **Step 1 — lecture des tokens** avant capture | Passe d'un enregistreur passif à un **vérificateur de conformité**. |
| **Exclusions** (code généré, primitives de bibliothèque) lues dans le manifeste | Ne pas imprinter ce qui n'est pas du code du projet. |
| Conformité marquée **dans la cellule** (`exception (…)`, `⚠️ …`, ratio de contraste) ; ligne **Token violations** seulement s'il y en a une | Conformité visible et actionnable. La colonne « Token-compliant? » valait `yes` ou `—` dans 96 % des lignes (boilerplate). |
| Audit comparé aux tokens | La baseline s'appuie sur la source de vérité, pas seulement sur la majorité. |
| Si une info manque → **demande**, ne crée jamais le registry ailleurs | Évite les registres en double. |
| **Index** en tête du registre (une ligne par composant, 160 caractères au plus, par familles), tenu à chaque écriture | Le registre est relu à chaque tâche d'interface et grossit à chaque composant (19,6 k caractères sur le boilerplate après F08). |
| Registre en **deux fichiers** : principal lu en entier, entrées lues une à une (`grep` + `offset`/`limit`) ; `/imprint` lui-même n'ouvre que l'entrée qu'il écrit | Rien ne disait comment lire « l'Index et la Baseline seulement » : un agent lisait les 83 Ko (32 k tokens) ou une page tronquée. |
| **Règles d'écriture** : tableau sans lignes vides, notes d'une dizaine de lignes ; historique → journal des décisions, points ouverts → tracker, logique → `architecture.md`, règle partagée → section transverse ou `ui-rules.md` ; Baseline corrigée sur place ; entrée retirée quand le composant est supprimé | Les notes recopiaient le journal et les questions ouvertes (28 entrées sur 35) ; 124 lignes de tableau sur 306 étaient vides. |
| **Hygiène** dans `/imprint audit` et `/imprint audit registry`, par `scripts/registry.sh check` (sh + perl) | Contrôles mécaniques sans tokens ; perl car l'awk de macOS compte les octets, pas les caractères accentués. |
| **`/imprint migrate`** : `registry.sh split` + `verify`, puis rapport d'hygiène avant toute réécriture | Le fond ne change pas, et c'est vérifié ligne à ligne. |

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
| **Journal des décisions** séparé du tracker (chemin lu dans §4) ; une décision qui contraint le code est aussi écrite dans son fichier de règles | Le tracker est relu à chaque session : sur le boilerplate il était passé de 3,7 k à 24 k caractères en 8 jours, dont 20 k de décisions et notes. |
| Restore en **modes** (reprise / nouvelle feature), lecture **par sections**, `CLAUDE.md` non relu, un seul fichier de mode chargé | Coût d'entrée stable d'une session à l'autre ; le plan actif reste lu en entier (contrat). |
| Lecture du restore par **script** (`scripts/read-sections.sh`), en un appel | L'outil de lecture de Claude Code charge les fichiers entiers avec numéros de ligne : les extractions par section n'étaient pas appliquées. |
| **Correction du handoff** proposée au restore quand la mémoire contredit git ou le plan | Sinon chaque restore répète les mêmes écarts jusqu'au prochain save. |

## Coût du fork

- Plus de mise à jour automatique depuis JSM : réinstaller `JavaScript-Mastery-Pro/skills` écraserait ces quatre skills.
- Les skills dépendent du **contrat** du kit agent-starter : `CLAUDE.md` avec §1 (lecture) et §4
  (frontières d'état, dont le dossier de plans et les deux fichiers du registre UI), et un manifeste de stack avec les sections Dossiers, Secrets, Commande de
  vérification. Si ce contrat change, mettre à jour les skills.
