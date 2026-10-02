---
name: design-system
description: Construit les fondations visuelles d'un projet (F00) avant toute feature d'interface, en variante provisoire (thème par défaut de la stack + règles de layout, pour avancer la structure) ou complète (brief d'inspiration, extraction des tokens, page témoin, itération corrigée dans le système, gel). Lit les chemins dans CLAUDE.md et le manifeste de stack, ne les écrit jamais en dur. À utiliser quand on démarre l'interface d'un projet, qu'on veut tirer un design system d'une capture, d'une URL, d'un style Refero ou d'un autre projet, qu'on retouche la palette, la typographie ou les espacements, ou que l'utilisateur mentionne design system, tokens, charte graphique, styleguide, page témoin ou F00.
---

# design-system

> Skill **de méthode** original du dépôt aerial33/aerial33-skills (architecture agent-starter).
> Il ne connaît ni la stack ni les chemins : tout est lu dans `CLAUDE.md` et le manifeste de stack.
> Il exécute le déroulé **Fondations visuelles (F00)** défini dans `ai-workflow-rules.md` du projet.

Sans design system fixé avant la première page, chaque écran généré invente ses propres couleurs,
rayons et espacements : l'interface « sent l'IA ». Ce skill fixe le système **une fois**, le valide sur
une vraie page, puis le gèle pour que `/imprint` puisse le faire respecter.

Le principe qui guide tout le skill : **on juge en regardant une page, on corrige dans le système.**

---

## Invocation

```
/design-system                 # F00 complète, reprend à l'étape en cours
/design-system neutral         # F00 provisoire : thème par défaut + règles de layout
/design-system extract <src>   # ajouter / remplacer une source (capture, URL, texte, autre projet) → étapes 1-2
/design-system preview         # (re)construire la page témoin → étape 3
/design-system sync            # remonter les valeurs arbitraires dans le système, réaligner la doc
```

Après le gel de F00, `/design-system` sert aux **évolutions** du système (voir « Après F00 »).

---

## Étape 0 — Résoudre le layout et l'état

Ne jamais supposer un chemin. Résoudre, dans cet ordre :

1. **`CLAUDE.md`** (racine du projet)
   - §1 lecture, lignes *Interface* et *Fondations visuelles* → `ui-tokens`, `ui-rules`, le dossier
     des designs (`brief.md`, `inspiration/`, `mockups/`) ;
   - §4 frontières d'état → chemins du **progress tracker** et du **UI registry**.
2. **Manifeste de stack** (`context/stack/stack.md` ou celui que `CLAUDE.md` désigne)
   - § Dossiers → **fichier de tokens** (source unique des valeurs), **page témoin**, dossiers de composants ;
   - § Design → format des tokens, chargement des polices, pack d'icônes, primitives, règles des
     composants externes ;
   - § Commande de vérification.
3. **`context/build-plan.md`** → l'entrée F00 et ses critères « Terminé quand ». Si aucune entrée ne
   porte l'ID `F00`, chercher la feature **marquée « F00 » dans son titre** (projet commencé avant
   l'adoption de F00, qui garde sa numérotation — ex. `F03 … (F00, variante provisoire)`) : c'est elle
   qui fait foi, y compris pour la variante et les critères. Si aucune feature n'est marquée, demander
   laquelle en tient lieu, ou proposer d'ajouter F00.
4. **Manque une info** → dire laquelle et **demander**. Ne jamais inventer un chemin ni créer un
   fichier ailleurs que là où il est déclaré.

Puis déterminer **où on en est** :

| Indice | Étape |
| ------ | ----- |
| `brief.md` absent ou vide, variante non choisie | demander : provisoire ou complète ? (lire d'abord la variante dans l'entrée F00 du build-plan, ou la feature marquée F00) |
| `brief.md` absent ou vide, variante complète | 1 — Brief |
| brief « provisoire » | F00 provisoire faite → proposer la F00 complète, en partant des pages déjà construites |
| brief « brouillon », tokens encore ceux du template | 2 — Extraction |
| tokens remplis, page témoin absente | 3 — Page témoin |
| page témoin présente, brief non validé | 4 — Itération |
| brief « validé », F00 non coché | 5 — Gel |
| F00 coché | Après F00 |

Annoncer en une ligne : `Tokens : … · Page témoin : … · Brief : … (statut) · Étape : …`

---

## Variante provisoire — `/design-system neutral`  ⏸ validation

Pour avancer la structure quand le design n'est pas défini, ou pour un projet neutre par nature
(boilerplate). Le thème se remplacera plus tard sans toucher aux composants, **à condition** que tout
soit construit avec des rôles de tokens.

1. **Thème** : vérifier que le fichier de tokens suit l'organisation du manifeste § Design et contient
   le thème par défaut qu'il désigne (ex. thème neutre shadcn/ui). Si le fichier hérite d'un ancien
   schéma (fichier de config, directive obsolète, valeurs mal placées), présenter la migration et
   attendre l'accord. Un preset peut remplacer le thème par défaut si le développeur le demande.
2. **Règles de layout** — c'est ce qui coûte cher à changer après coup, donc on le fixe maintenant.
   Proposer, puis écrire dans `ui-rules.md` après accord : largeur max et conteneur, espacement entre
   sections, échelle des titres, densité (aérée / compacte), navigation, états vides / chargement /
   erreur. Remplir aussi la section Accessibilité (elle ne dépend pas de l'habillage) et la section
   **Exceptions palette** : les cas où une classe de palette est permise (overlays, graphiques,
   catégories…), à partir des besoins du build-plan ; rester court, tout le reste passe par les rôles.
3. **`ui-tokens.md`** : documenter les rôles du thème par défaut (rôles et classes, pas de valeurs).
4. **`brief.md`** : statut **provisoire**, intention en une ligne si elle est connue, ressources de la
   stack par défaut (police, icônes) avec leur licence.
5. **Page témoin** : la construire comme à l'étape 3 (fondations + composants), sans page réelle.
6. Rappeler que la F00 complète reste à faire avant la première page montrée au client — sauf projet
   neutre par nature — et proposer d'ajouter au build-plan la feature correspondante.

```
F00 provisoire : thème [nom] · layout fixé (conteneur [x], sections [y], titres [échelle]) · page témoin [route]
F00 complète à planifier avant : [première feature montrée au client | sans objet (projet neutre)]
```

La F00 provisoire passe la gate comme toute feature. Ensuite, `/imprint` s'applique normalement.

---

## Étape 1 — Brief  ⏸ validation

**Entrées acceptées** (aucun outil imposé) :

- captures dans `inspiration/` ou jointes à la conversation → **les regarder réellement** ;
- URL d'un site ou d'une app → la lire si possible ; si la page est rendue en JavaScript et revient
  vide, demander une capture plutôt que deviner ;
- texte de design system (style Refero, export Claude Design / Paper / `/design`, DESIGN.md…) ;
- **un autre projet** déjà livré → lire son fichier de tokens, son `ui-rules` et son brief ;
- la **charte graphique du client** (logo, couleurs, polices imposées) → elle prime sur toute inspiration.

**Questions** — trois à cinq au maximum, seulement si `project-overview.md` n'y répond pas déjà :
intention et public, clair / sombre / les deux, contraintes imposées (charte, référentiel
d'accessibilité), ce qu'il faut éviter.

**Mélanger plutôt que copier** : pour chaque source, noter ce qu'on prend et ce qu'on ne prend pas
(ex. typographie de A, palette de B). Si une seule marque fournit tout, le signaler : reproduire
l'identité d'un tiers pour un client n'est pas acceptable.

**Ressources** (polices, icônes, composants externes, animations) : une source par catégorie, en
respectant le manifeste § Design (pack d'icônes par défaut, etc.). Pour chaque ressource, noter la
licence et ses obligations. **Licence inconnue → « à vérifier », jamais retenue en l'état.**

Écrire `brief.md` (statut **brouillon**), puis s'arrêter :

```
Brief rédigé → [chemin]
Sources : [n] · Ce qu'on prend : [résumé une ligne]
Ressources : [police titres] / [police texte] / [icônes] — licences : [ok | à vérifier : …]
Valide le brief (ou corrige) avant que je passe à l'extraction.
```

---

## Étape 2 — Extraction  ⏸ validation

Traduire le brief en valeurs. **Proposer d'abord, écrire ensuite.**

1. Lire le fichier de tokens actuel : conserver son **format** (ex. OKLCH) et les **noms de variables
   attendus par la bibliothèque de composants** déclarée (ne pas créer de noms parallèles qui
   laisseraient les primitives sur l'ancien thème).
2. Construire la proposition :
   - **couleurs par rôle** (fond, surface, bordure, textes, accent, états…), clair et sombre si demandé ;
   - **contraste** de chaque paire texte / fond, **calculé** (ratio WCAG), comparé au niveau visé dans
     le brief — un rôle qui échoue est corrigé avant présentation ;
   - **typographie** : familles, échelle de tailles, graisses, interlignage ;
   - **rayons**, **ombres**, **espacements** (base de la stack), **durées de motion** si utiles.
3. Présenter un tableau `rôle → valeur → d'où elle vient (source du brief) → contraste`, et s'arrêter :

```
Proposition de tokens : [n] couleurs ([n] paires de contraste OK), [n] tailles de texte, [n] rayons.
Valide (ou corrige) et j'écris le fichier de tokens, ui-tokens et ui-rules.
```

Après validation :

- écrire les valeurs **uniquement** dans le fichier de tokens ; charger les polices comme le prescrit
  le manifeste ;
- `ui-tokens.md` : rôles et classes à utiliser, **jamais de valeurs** ;
- `ui-rules.md` : thème, layout, composants (dont états vides / chargement / erreur), exceptions
  palette, icônes, motion, accessibilité, voix & microcopy, do nots — tirés du brief et des sources.

Jamais de seconde source de valeurs (fichier JSON, fichier de config parallèle). Si un outil fournit
du JSON, il sert à générer le bloc de tokens, puis on l'écarte.

---

## Étape 3 — Page témoin  ⏸ retours

Construire, au chemin déclaré par le manifeste, la **page styleguide** :

- **Fondations** : nuancier par rôle avec le nom du token, échelle typographique, rayons, ombres,
  espacements ;
- **Composants de base** dans tous leurs états : boutons (variantes, hover, focus, désactivé),
  champs (vide, rempli, erreur), carte, badge, alerte, état vide, squelette de chargement ;
- la garde « pas en production » prescrite par le manifeste.

Puis **une page réelle** du projet (demander laquelle ; proposer la plus représentative du
build-plan), avec des données factices, construite avec les seuls tokens. Après une F00 provisoire,
prendre une page **déjà construite** : c'est elle qui montre si le nouveau thème tient.

Lancer la commande de vérification sur ce qui a été écrit. Indiquer les routes à ouvrir ; si un
navigateur est disponible, faire une capture et la regarder avant de rendre la main. S'arrêter :

```
Page témoin : [route] · Page réelle : [route]
Regarde les deux et donne tes retours (espacements, couleurs, hiérarchie, densité…).
```

---

## Étape 4 — Itération (on regarde la page, on corrige le système)

Pour chaque retour, annoncer la traduction **avant** d'appliquer :

```
Retour : « plus d'air entre les sections »
→ Système : espacement de section 24 → 32 (ui-rules § Layout)
→ Fichiers : ui-rules.md, [page si elle n'utilisait pas la règle]
```

- Un retour visuel se corrige dans le **fichier de tokens** ou dans **`ui-rules.md`**, jamais par une
  valeur arbitraire (`bg-[#…]`, `p-[13px]`) dans la page.
- Un réglage propre à une seule page (mise en page) va dans la page, mais avec des tokens.
- Toute ressource ajoutée en cours de route (police, composant externe) passe par `brief.md` et sa
  licence.

Recommencer jusqu'à validation explicite (« c'est bon », « on valide »). En cas de doute, demander.

### Mode `sync`

À lancer après une itération faite à la main, ou avant le gel :

1. chercher les **valeurs arbitraires** (couleurs en dur, tailles entre crochets) et les **classes de
   palette hors Exceptions palette** dans la page témoin, la page réelle et les dossiers de composants
   → proposer pour chacune : token existant, nouveau token, nouvelle exception déclarée, ou suppression ;
2. vérifier que chaque rôle du fichier de tokens est documenté dans `ui-tokens.md`, et qu'aucun rôle
   documenté n'a disparu ;
3. présenter la liste, appliquer après accord.

---

## Étape 5 — Gel

Seulement sur validation explicite :

1. `brief.md` : statut **validé le [date]**, page témoin renseignée, ligne dans l'historique ;
2. `mockups/` : proposer d'y enregistrer la page réelle validée (`<route>.png`) et les captures
   d'inspiration qui deviennent contractuelles — **jamais sans accord** ;
3. lancer `/imprint audit` pour poser la base du UI registry ;
4. F00 est une feature comme une autre : elle passe la **gate** du projet (commande de vérification +
   `/review`) avant d'être cochée dans le progress tracker.

```
F00 gelée. Brief validé · [n] tokens · page témoin [route] · base /imprint posée.
Prochaine feature d'interface : [F0x du build-plan].
```

---

## Après F00 — faire évoluer le système

Un changement de token ou de règle après le gel :

1. lire le UI registry → lister les composants touchés ;
2. présenter `changement → composants impactés`, attendre l'accord ;
3. modifier le fichier de tokens ; `ui-tokens.md` / `ui-rules.md` si un rôle ou une règle change ;
   une ligne dans l'historique du brief ;
4. relancer `/imprint audit`.

---

## Interdits

- Écrire une valeur ailleurs que dans le fichier de tokens.
- Sauter un point d'arrêt (⏸) : brief, tokens et page témoin se valident un par un.
- Reproduire l'identité complète d'une marque tierce.
- Retenir une ressource dont la licence n'est pas vérifiée.
- Dessiner des icônes : utiliser le pack déclaré.
- Corriger un retour visuel par une valeur arbitraire dans une page.
- Dépendre d'un outil de design précis : leur sortie n'est qu'une source parmi d'autres.

## La règle

On fixe le système une fois, on le juge sur une vraie page, on corrige dans le système, on gèle.
Ensuite, `/imprint` le fait respecter composant après composant.
