---
name: nextjs-lint-setup
description: Configure ESLint 9 (flat config native) + Prettier pour un projet Next.js 15+ en TypeScript et Tailwind CSS v4, avec les conventions Payload CMS — tri automatique des imports, tri des classes Tailwind, exclusion du code généré, script format:check pour la vérification, intégration VSCode/Cursor. À utiliser dès qu'on initialise ou met à jour le linting d'un projet Next.js (avec ou sans Payload), ou que l'utilisateur mentionne ESLint, Prettier, eslint.config.mjs, "lint setup", tri des imports ou un conflit ESLint/Prettier.
allowed-tools: Read, Write, Edit, Bash
---

# nextjs-lint-setup

> Skill **de stack** (Next.js, conventions Payload) du dépôt aerial33/skills — à la différence des
> skills de méthode, il connaît la stack. Il remplit la convention de lint de la stack `next-payload`
> du kit agent-starter (`context/stack/stack.md`).

## Vue d'ensemble

Configure ESLint + Prettier dans un projet Next.js (App Router, TypeScript, Tailwind CSS v4) :
tri des imports, tri des classes Tailwind, exclusion du code généré, intégration éditeur.

Les fichiers prêts à l'emploi vivent dans `assets/` : **les copier tels quels**, puis fusionner deux
fichiers existants (`package.json`, `.vscode/settings.json`). Copier plutôt que régénérer évite les
coquilles : `assets/` est la source de vérité.

## Stack cible

- Next.js 15+ (App Router), ESLint 9 — `next lint` n'existe plus en Next.js 16 : on lance `eslint .`
- TypeScript, Tailwind CSS v4
- Payload CMS (facultatif : les exclusions Payload sont sans effet sur un projet sans Payload)
- pnpm (adapter les commandes si npm/yarn), VSCode / Cursor

## Conventions retenues

- **Nommage des fichiers et dossiers : convention Payload / Next**, pas de règle de lint dédiée
  (`collections/Pages/index.ts`, `blocks/CallToAction/Component.tsx`, `utilities/getURL.ts`, dossiers
  App Router `(frontend)`, `[slug]`). La convention est documentée dans les standards de code du projet.
- **Style Prettier : celui de Payload** (`singleQuote`, `semi: false`, `trailingComma: all`,
  `printWidth: 100`) — le code généré et le code de référence Payload ne sont pas reformatés.

---

## Fichiers fournis (`assets/`)

| Asset | Destination (racine projet) | Mode |
| ----- | --------------------------- | ---- |
| `assets/eslint.config.mjs` | `./eslint.config.mjs` | Remplace la config existante (souvent en `FlatCompat`, obsolète) — reporter d'abord ses `ignores` propres au projet |
| `assets/prettierrc.json` | `./.prettierrc.json` | Remplace ; ajuster `tailwindStylesheet` (voir étape 2) |
| `assets/prettierignore` | `./.prettierignore` | Copie, puis ajouter les dossiers propres au projet |
| `assets/vscode-settings.json` | `./.vscode/settings.json` | **Fusion**, pas écrasement |

---

## Workflow d'installation

### 1. Installer les dépendances

`eslint` et `typescript-eslint` sont fournis par `eslint-config-next` : ne pas les réinstaller.

```bash
pnpm add --save-dev \
  eslint-config-prettier \
  @ianvs/prettier-plugin-sort-imports \
  prettier \
  prettier-plugin-tailwindcss
```

Si le projet avait `@eslint/eslintrc` uniquement pour `FlatCompat`, le retirer après l'étape 2.

### 2. Copier les fichiers de config

```bash
cp <skill>/assets/eslint.config.mjs ./eslint.config.mjs
cp <skill>/assets/prettierrc.json   ./.prettierrc.json
cp <skill>/assets/prettierignore    ./.prettierignore
```

Puis adapter au projet :

- **`tailwindStylesheet`** dans `.prettierrc.json` : chemin du fichier CSS qui contient `@theme`
  (template Payload website : `./src/app/(frontend)/globals.css` ; projet Next seul : souvent
  `./src/app/globals.css`). Dans un projet agent-starter, c'est le « fichier de tokens » du manifeste
  `context/stack/stack.md`. Sans cette option, Tailwind v4 trie mal les classes du thème (`bg-card`…).
- **Exclusions propres au projet** (ex. `_reference/`) : les ajouter à la fois dans `globalIgnores`
  d'`eslint.config.mjs` et dans `.prettierignore`.

### 3. Ajouter les scripts à `package.json`

**N'ajouter que ces scripts** — ne pas toucher `dev`, `build`, `start` (Payload les préfixe de
`cross-env NODE_OPTIONS=…`). Si `lint` existe déjà, le garder.

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write src",
    "format:check": "prettier --check src"
  }
}
```

`format:check` sert à la commande de vérification (CI, gate du kit) : il échoue si un fichier n'est
pas formaté, sans rien modifier.

### 4. Fusionner `.vscode/settings.json`

Fusionner les clés de `assets/vscode-settings.json` dans le fichier existant (ne pas l'écraser).
Les préférences personnelles (police, taille, curseur, enregistrement automatique) vont dans les
**réglages utilisateur** de l'éditeur, jamais dans le dépôt.

### 5. Vérifier

```bash
pnpm lint && pnpm format:check
```

Puis, dans l'éditeur, enregistrer un fichier `.tsx` : imports triés, classes Tailwind réordonnées.
Un premier `pnpm format` reformate tout le projet : le faire dans un commit séparé.

---

## Explication des choix

L'agent doit comprendre **pourquoi** la config est structurée ainsi, pour l'adapter sans la casser.

### `eslint.config.mjs`

| Choix | Raison |
| ----- | ------ |
| `defineConfig` + `globalIgnores` | API native ESLint 9 |
| `...nextVitals` + `...nextTs` | Flat configs natives exportées par `eslint-config-next` 15+ : `core-web-vitals` promeut les règles CWV en `error`, `typescript` ajoute `typescript-eslint` recommended |
| Pas de `FlatCompat` | Obsolète pour Next.js depuis l'export natif ; ne le garder que pour un plugin tiers non migré |
| `files: ['**/*.{ts,tsx}']` | Les règles du projet ne s'appliquent pas aux `.js` / `.mjs` de config |
| `no-unused-vars` avec `^_` | Permet de marquer volontairement une variable ou un argument inutilisé |
| `prettier` en avant-dernier | Désactive les règles de formatage ESLint en conflit avec Prettier |
| `globalIgnores` en dernier | Exclut builds et code généré (types Payload, schéma, importMap, migrations) |

**Pas de règles `@typescript-eslint/no-unsafe-*`** : elles exigent le lint typé (`parserOptions.projectService`).
Sans lui, ESLint plante au chargement. Si on veut le lint typé un jour : activer `projectService` et
utiliser la config `recommendedTypeChecked` de `typescript-eslint` — plus lent, à décider en connaissance de cause.

### Tri des imports : `@ianvs/prettier-plugin-sort-imports`

Choisi plutôt que `@trivago` : il **ne réordonne pas les imports à effet de bord** (ex. `import './globals.css'`),
ce qui préserve la cascade CSS ; il est aussi mieux maintenu. Différences de configuration :

- séparation entre groupes par des chaînes vides `""` dans `importOrder` (pas d'`importOrderSeparation`) ;
- pas d'`importOrderSortSpecifiers` (tri des specifiers par défaut) ;
- `importOrderParserPlugins: ["typescript", "jsx"]` pour parser TS/TSX ;
- 1er groupe `^(react|react-dom|next)(/.*)?$` : React, React DOM et toute la famille `next/*`.

### Plugins Prettier

`prettier-plugin-tailwindcss` toujours **en dernier** dans `plugins` (il passe après le tri des imports).

### Réglages VSCode

- `source.organizeImports` **absent** : il entre en conflit avec le tri par Prettier (boucles de formatage).
- `source.fixAll.eslint` plutôt que `source.fixAll` : plus ciblé.

---

## Résolution de problèmes

| Symptôme | Solution |
| -------- | -------- |
| `You have used a rule which requires type information` | Une règle typée (ex. `no-unsafe-*`) est active sans `projectService` : la retirer ou activer le lint typé |
| Erreurs sur `payload-types.ts`, `importMap.js` ou des migrations | Vérifier `globalIgnores` et `.prettierignore` |
| Lint lent ou erreurs dans un dossier de référence | Ajouter le dossier aux exclusions ESLint, Prettier **et** `tsconfig.json` |
| Conflits ESLint ↔ Prettier | `prettier` doit être placé avant `globalIgnores` dans `defineConfig` |
| Imports non triés à l'enregistrement | Retirer `source.organizeImports` des réglages, redémarrer l'éditeur |
| Classes Tailwind mal triées | `prettier-plugin-tailwindcss` en dernier ; `tailwindStylesheet` pointe vers le bon CSS |
| Erreur d'import `eslint-config-next/*` | Vérifier la version d'`eslint-config-next` (15+) |
| `defineConfig` introuvable | `eslint` doit être en version 9 |
