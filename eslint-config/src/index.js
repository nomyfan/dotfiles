const configBasic = {
  extends: ["eslint:recommended", "plugin:@typescript-eslint/recommended"],
  parser: "@typescript-eslint/parser",
};

const configReact = {
  extends: [
    "plugin:react/recommended",
    "plugin:react/jsx-runtime",
    "plugin:react-hooks/recommended",
  ],
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
