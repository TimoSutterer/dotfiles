return {
  'NeogitOrg/neogit',
  -- Only load the Git UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  lazy = true,
  dependencies = {
    'esmuellert/codediff.nvim',
    'ibhagwan/fzf-lua',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' }
  },
}
