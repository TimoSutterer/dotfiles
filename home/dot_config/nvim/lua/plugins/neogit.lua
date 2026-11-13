return {
  'NeogitOrg/neogit',
  -- Only load the Git UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  lazy = true,
  dependencies = {
    'dlyongemallo/diffview-plus.nvim',
    'ibhagwan/fzf-lua',
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' }
  },
  -- Explicit, so installing a diff viewer can't switch it silently.
  opts = { diff_viewer = 'diffview' },
}
