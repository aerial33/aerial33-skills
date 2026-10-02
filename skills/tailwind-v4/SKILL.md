---
name: tailwind-v4
description: Écrire et relire du CSS et des classes Tailwind CSS v4 (configuration CSS-first, sans tailwind.config) sans retomber dans les habitudes v3 — fichier de tokens, classes renommées, comportements changés, règle des couleurs du projet. À utiliser dès qu'on écrit ou modifie des classes Tailwind, un fichier CSS avec @import "tailwindcss" ou @theme, un composant stylé, ou que l'utilisateur mentionne Tailwind, tokens, dark mode, globals.css, shadcn ou une migration v3 → v4.
---

# tailwind-v4

> Skill **de stack** du dépôt aerial33/aerial33-skills. Source : documentation officielle Tailwind CSS v4
> (*Upgrade guide*, *Theme variables*, *Colors*, *Dark mode*). En cas de doute, la doc à jour fait foi
> (Context7 : `/websites/tailwindcss`). L'organisation du fichier de tokens et la règle des couleurs
> propres au projet sont dans le manifeste de stack (`context/stack/stack.md` § Design) : ce skill ne
> les remplace pas, il les applique.

Les modèles ont surtout appris Tailwind v3. L'erreur typique n'est pas une classe inconnue : c'est
une habitude v3 qui compile encore mais fait autre chose, ou un fichier de config qui revient.

---

## 1. Ce projet est en v4 CSS-first — refuser les signaux v3

| Signal v3 (ne jamais écrire) | En v4 |
| ---------------------------- | ----- |
| `tailwind.config.js/ts/mjs`, directive `@config` | configuration dans le CSS (`@theme`, `@custom-variant`, `@utility`, `@plugin`) |
| `@tailwind base; @tailwind components; @tailwind utilities;` | `@import "tailwindcss";` |
| `npx tailwindcss init`, plugin PostCSS `tailwindcss`, `autoprefixer` | plugin PostCSS `@tailwindcss/postcss` (préfixes inclus) |
| `content: [...]` | détection automatique ; ajouter une source avec `@source "…";` |
| `safelist` | `@source inline("…");` |
| `darkMode: 'class'` | `@custom-variant dark (…);` (sélecteur : voir le manifeste) |
| `theme('colors.x')` dans le CSS | variables CSS : `var(--color-x)` |
| `@layer components { .btn {…} }` | `@utility btn {…}` |
| `require('@tailwindcss/…')` | `@plugin "@tailwindcss/…";` |

Si l'un de ces signaux apparaît dans le projet ou dans une suggestion (y compris d'un autre skill),
le signaler et proposer l'équivalent v4 ; ne pas le reproduire.

## 2. Fichier de tokens

Suivre le manifeste de stack (§ Dossiers : quel fichier ; § Design : comment il est organisé). Principes
de la doc officielle qu'il applique :

- **valeurs qui changent avec le thème** dans des variables CSS (`:root`, sélecteur du thème sombre) ;
- **exposition à Tailwind** par `@theme inline` dès qu'un token référence une autre variable
  (`--color-background: var(--background)`) — sans `inline`, la valeur peut se résoudre au mauvais niveau
  du DOM ;
- **tokens fixes** (polices, breakpoints…) dans `@theme`, en surchargeant les noms par défaut
  (`--font-sans`, `--breakpoint-*`) plutôt qu'en en inventant ;
- un token `--color-x` génère `bg-x`, `text-x`, `border-x`… ; `--font-x` génère `font-x`, etc.

## 3. Couleurs

Appliquer la règle du manifeste : **rôles par défaut** (`bg-primary`, `text-muted-foreground`), classes
de palette (`bg-amber-500`) **seulement** dans les Exceptions palette de `ui-rules.md`, **jamais** de
hex ni de valeur arbitraire de couleur. Opacité : modificateur `/` (`bg-primary/10`).

## 4. Classes renommées en v4

Une classe v3 de cette liste compile encore mais donne un **rendu différent** : utiliser la colonne v4.

| Intention (rendu v3) | v3 | v4 |
| -------------------- | -- | -- |
| ombre la plus légère | `shadow-sm` | `shadow-xs` |
| ombre par défaut | `shadow` | `shadow-sm` |
| ombre portée légère | `drop-shadow-sm` | `drop-shadow-xs` |
| ombre portée | `drop-shadow` | `drop-shadow-sm` |
| flou léger | `blur-sm` | `blur-xs` |
| flou | `blur` | `blur-sm` |
| flou d'arrière-plan léger | `backdrop-blur-sm` | `backdrop-blur-xs` |
| flou d'arrière-plan | `backdrop-blur` | `backdrop-blur-sm` |
| arrondi le plus petit | `rounded-sm` | `rounded-xs` |
| arrondi par défaut | `rounded` | `rounded-sm` |
| masquer l'outline (garder l'accessibilité forcée) | `outline-none` | `outline-hidden` |
| anneau de 3px | `ring` | `ring-3` |

Supprimées : `bg-opacity-*`, `text-opacity-*`, `border-opacity-*`, `ring-opacity-*`… → modificateur `/`
(`bg-black/50`) ; `flex-shrink-*` → `shrink-*` ; `flex-grow-*` → `grow-*` ; `overflow-ellipsis` →
`text-ellipsis`.

## 5. Comportements changés

- **Bordures** : couleur par défaut `currentColor` (v3 : gris clair) → toujours préciser la couleur
  (`border border-border`), idem `divide-*`.
- **Anneaux** : `ring` = 1px en `currentColor` → préciser largeur et couleur (`ring-2 ring-ring`).
- **`!important`** : le `!` se place **à la fin** (`bg-primary!`), plus au début.
- **Variable CSS en valeur arbitraire** : parenthèses, `bg-(--brand)`, et non `bg-[--brand]`.
- **`hover:`** ne s'applique que sur les appareils qui gèrent le survol (`@media (hover: hover)`) : ne
  pas porter d'information essentielle uniquement au survol.
- **`space-x-*` / `space-y-*`** : sélecteur modifié en v4 → préférer `gap-*` en flex / grid.
- **`container`** : plus d'options de config (centrage, padding) → `mx-auto px-*` ou `@utility container`.

## 6. Écrire les classes

- **Noms complets uniquement** : jamais `` `text-${color}-500` `` (non détecté). Passer par une table
  `{ success: 'text-success', … }` ou `@source inline()`.
- **Composition conditionnelle** : `cn()` (clsx + tailwind-merge) pour fusionner et laisser une classe
  en écraser une autre ; jamais deux classes contradictoires.
- **Mobile-first** : la classe sans préfixe vaut pour le mobile, `md:` / `lg:` ajoutent au-dessus.
- **L'ordre des classes dans l'attribut ne change pas le CSS** ; le tri est fait par
  `prettier-plugin-tailwindcss`.
- **`@apply`** : pas dans les composants ; réservé au CSS (base, styles de contenu tiers). Dans un CSS
  séparé (module, `<style>`), importer le contexte avec `@reference "…";`.
- **Valeurs arbitraires** (`p-[13px]`) : exception rare ; un besoin qui revient devient un token.
- **Mode sombre** : avec des rôles, rien à faire ; `dark:` seulement pour les exceptions palette.

## 7. Avant de rendre la main

- [ ] Aucun signal v3 de la section 1 introduit.
- [ ] Aucune classe v3 renommée (section 4) ni supprimée.
- [ ] Bordures et anneaux avec une couleur explicite.
- [ ] Couleurs conformes à la règle du manifeste (rôles / exceptions déclarées / pas de hex).
- [ ] Pas de nom de classe construit dynamiquement.
