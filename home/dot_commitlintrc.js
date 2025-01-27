module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Warn if subject is longer than 50 characters
    'header-max-length-warning': [1, 'always', 50],
    // Error if subject is longer than 72 characters
    'header-max-length': [2, 'always', 72],
    // Wrap body at 72 characters
    'body-max-line-length': [2, 'always', 72],
    // Require a blank line before the body
    'body-leading-blank': [2, 'always'],
  },
  plugins: [
    {
      rules: {
        'header-max-length-warning': ({header}) => {
          if (header.length > 50) {
            return [
              false, // Return a warning (1)
              `Warning: The subject exceeds 50 characters (currently ${header.length}). Try to shorten it.`
            ];
          }
          return [true];
        },
      },
    },
  ],
};

