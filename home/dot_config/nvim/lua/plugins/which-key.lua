return {
  'folke/which-key.nvim',
  -- Only load the keymap popup outside VS Code.
  enabled = function() return not vim.g.vscode end,
  event = 'VeryLazy',
  opts = {
    delay = 700,
    spec = {
      { '<leader>b', group = 'Buffer' },
      { '<leader>f', group = 'Find' },
      { '<leader>g', group = 'Git' },
      { '<leader>gc', group = 'CodeDiff' },
      { '<leader>gt', group = 'Git toggle' },
      { '<leader>gv', group = 'Diffview' },
      { '<leader>r', group = 'Review' },
      { '<leader>rv', group = 'review.nvim' },
      { '<leader>t', group = 'Tree' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer-local keymaps',
    },
  },
}
