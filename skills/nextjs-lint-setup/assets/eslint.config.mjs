// eslint.config.mjs — Next.js 15+ / ESLint 9 (flat config native), conventions Payload
import { defineConfig, globalIgnores } from 'eslint/config'
import nextVitals from 'eslint-config-next/core-web-vitals'
import nextTs from 'eslint-config-next/typescript'
import prettier from 'eslint-config-prettier/flat'

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,

  // Règles du projet, scopées aux fichiers TS/TSX
  {
    files: ['**/*.{ts,tsx}'],
    rules: {
      // Style
      'prefer-arrow-callback': 'warn',
      'prefer-template': 'error',

      // TypeScript — warn plutôt qu'error pour ne pas bloquer le dev
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/ban-ts-comment': 'warn',
      '@typescript-eslint/no-empty-object-type': 'warn',
      '@typescript-eslint/no-unused-vars': [
        'warn',
        {
          vars: 'all',
          args: 'after-used',
          ignoreRestSiblings: false,
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
          destructuredArrayIgnorePattern: '^_',
          caughtErrorsIgnorePattern: '^(_|ignore)',
        },
      ],
    },
  },

  prettier, // avant-dernier — désactive les règles de formatage ESLint en conflit avec Prettier

  globalIgnores([
    '.next/**',
    'out/**',
    'build/**',
    'next-env.d.ts',
    // Payload — code généré (sans effet si le projet n'utilise pas Payload)
    'src/payload-types.ts',
    'src/payload-generated-schema.ts',
    'src/app/(payload)/admin/importMap.js',
    'src/migrations/**',
    // Ajouter ici les dossiers propres au projet (ex. code de référence : '_reference/**')
  ]),
])

export default eslintConfig
