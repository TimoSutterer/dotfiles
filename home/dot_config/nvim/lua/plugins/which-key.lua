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
      { '<leader>gt', group = 'Git toggle' },
      { '<leader>r', group = 'Review' },
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
