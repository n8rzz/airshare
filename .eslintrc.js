// https://nextjs.org/docs/basic-features/eslint
// https://paulintrognon.fr/blog/typescript-prettier-eslint-next-js

module.exports = {
  plugins: [
    'destructuring', // Uses eslint-plugin-destructuring
    'jest-dom',
    'testing-library',
    'typescript-sort-keys', // Uses typescript-sort-keys
    'unused-imports',
  ],
  extends: [
    'next',
    'next/core-web-vitals',
    'plugin:@typescript-eslint/recommended',
    'plugin:destructuring/recommended',
    'plugin:testing-library/dom',
    'plugin:testing-library/react',
    'plugin:typescript-sort-keys/recommended',
    'plugin:storybook/recommended',
    'plugin:jest-dom/recommended',
    'prettier',
  ],
  rules: {
    '@next/next/no-img-element': 'off', // TODO: change to 'error' when have time to fix issues
    'react-hooks/exhaustive-deps': 'off', // TODO: change to 'error' when have time to fix issues
    '@typescript-eslint/no-explicit-any': 'off', // TODO: change to 'error' when have time to fix issues
    '@typescript-eslint/explicit-module-boundary-types': 'off', // TODO: change to 'error' when have time to fix issues
    '@typescript-eslint/ban-ts-ignore': 'off', // TODO: change to 'error' when have time to fix issues
    '@typescript-eslint/ban-ts-comment': 'off', // TODO: change to 'error' when have time to fix issues
    '@typescript-eslint/no-use-before-define': 'off', // TODO: change to 'error' when have time to fix issues
    '@typescript-eslint/no-unused-vars': ['error', {args: 'none', ignoreRestSiblings: true}],
    '@typescript-eslint/no-empty-interface': 'off',
    '@typescript-eslint/no-inferrable-types': 'off',
    '@typescript-eslint/no-empty-function': 'off',
    '@typescript-eslint/interface-name-prefix': 0,
    '@typescript-eslint/explicit-function-return-type': 0,
    '@typescript-eslint/no-shadow': 2,
    '@typescript-eslint/camelcase': 0, // Would like to use this but cannot because of api data names
    'array-bracket-spacing': [2, 'never'],
    'no-return-await': 2,
    'id-length': ['error', {exceptions: ['_', 'x', 'y', 'a', 'b']}],
    curly: 2,
    'destructuring/no-rename': 0,
    'eol-last': 2,
    'keyword-spacing': [
      2,
      {
        before: true,
        after: true,
      },
    ],
    // This should be upped to errors once circular references are resolved
    'import/no-cycle': [0, {maxDepth: 1}],
    'no-console': [2, {allow: ['warn', 'error', 'info', 'groupCollapsed', 'group', 'groupEnd']}],
    'no-const-assign': 2,
    'no-empty-pattern': 2,
    'no-eval': 2,
    'no-global-assign': 2,
    'no-mixed-spaces-and-tabs': 2,
    'no-multi-assign': 2,
    'no-multi-str': 2,
    'no-trailing-spaces': 2,
    'no-unreachable': 2,
    'no-var': 2,
    'no-whitespace-before-property': 2,
    'object-curly-spacing': [2, 'always'],
    'one-var': [2, 'never'],
    'padded-blocks': [2, 'never'],
    'padding-line-between-statements': [
      2,
      {blankLine: 'always', prev: '*', next: 'return'},
      {blankLine: 'always', prev: ['const', 'let', 'var'], next: 'return'},
      {blankLine: 'any', prev: ['const', 'let', 'var'], next: ['const', 'let', 'var']},
      {blankLine: 'always', prev: '*', next: 'multiline-block-like'},
      {blankLine: 'always', prev: 'multiline-block-like', next: '*'},
      {blankLine: 'never', prev: '*', next: 'case'},
    ],
    'prefer-const': 2,
    'prefer-template': 2,
    'react-hooks/rules-of-hooks': 2,
    // 'react-hooks/exhaustive-deps': 1,
    'react/prop-types': 0,
    'react/jsx-curly-brace-presence': [2, {props: 'always', children: 'never'}],
    'react/jsx-sort-props': [
      2,
      {
        callbacksLast: true,
        ignoreCase: true,
        noSortAlphabetically: false,
        reservedFirst: true,
      },
    ],
    'react/jsx-fragments': [2, 'element'],
    'react/jsx-boolean-value': [2, 'always'],
    'react/jsx-no-target-blank': [2, {allowReferrer: true}],
    'space-before-blocks': [2, 'always'],
    'newline-after-var': [2, 'always'],
    'space-before-function-paren': [
      2,
      {
        anonymous: 'never',
        named: 'never',
        asyncArrow: 'always',
      },
    ],
    'space-infix-ops': 2,
    'space-in-parens': [2, 'never'],
    'testing-library/await-async-query': 'error',
    'testing-library/no-await-sync-query': 'error',
    'testing-library/no-debugging-utils': 'warn',
    'testing-library/no-dom-import': 'off',
    'testing-library/no-render-in-setup': 'error',
    'testing-library/prefer-screen-queries': 'error',
    // TODO: incrementally add these back
    'testing-library/no-node-access': 0,
    'testing-library/prefer-presence-queries': 0,
    'testing-library/render-result-naming-convention': 0,
    'template-curly-spacing': [2, 'never'],
    'destructuring/in-params': ['error', {'max-params': 0}],
    'spaced-comment': [
      2,
      'always',
      {
        line: {
          markers: ['/'],
          exceptions: ['-'],
        },
        block: {
          markers: ['/', '*'],
        },
      },
    ],
    // 'no-nested-ternary': 2,
    'no-param-reassign': [2, {props: false}],
    // 'max-params': [2, 5],
    // 'quote-props': [2, 'as-needed', { keywords: true }],
    'dot-notation': [2, {allowPattern: '^[a-z]+(_[a-z]+)+$'}],
    quotes: [2, 'single', {avoidEscape: true}],
    'unused-imports/no-unused-imports': 2,
  },
  overrides: [
    {
      files: ['src/**/*.stories.tsx', 'src/pages/api/**/*.ts'],
      rules: {
        'import/no-anonymous-default-export': 'off',
      },
    },
    {
      files: ['src/**/*.test.{ts,tsx}'],
      rules: {
        'dot-notation': 'off',
      },
    },
  ],
};
