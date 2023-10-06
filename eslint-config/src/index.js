const configBasic = {
  extends: [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:import/typescript",
  ],
  parser: "@typescript-eslint/parser",
  plugins: ["import"],
  rules: {
    "@typescript-eslint/no-unused-vars": "warn",

    "import/default": "error",
    "import/namespace": "error",
    "import/export": "error",
    "import/first": "error",
    "import/no-default-export": "error",
    "import/consistent-type-specifier-style": ["warn", "prefer-top-level"],
    "import/newline-after-import": "error",
    "import/no-anonymous-default-export": "error",
    "import/no-deprecated": "warn",
    "import/no-empty-named-blocks": "error",
    "import/no-extraneous-dependencies": "error",
    "import/no-named-as-default": "error",
    "import/no-self-import": "error",
    "import/order": [
      "error",
      {
        groups: ["builtin", "external", "parent", "sibling", "index"],
        "newlines-between": "always",
        alphabetize: {
          order: "asc",
          orderImportKind: "asc",
          caseInsensitive: true,
        },
      },
    ],
  },
};

const configReact = {
  extends: [
    "plugin:react/recommended",
    "plugin:react/jsx-runtime",
    "plugin:react-hooks/recommended",
    "plugin:import/react",
  ],
  settings: {
    react: {
      version: "18",
    },
  },
};

const configFormat = {
  extends: ["prettier"],
};

module.exports = {
  configs: {
    basic: configBasic,
    react: configReact,
    format: configFormat,
    recommended: {
      extends: [
        "plugin:nomyfan/basic",
        "plugin:nomyfan/react",
        "plugin:nomyfan/format",
      ],
    },
  },
};
