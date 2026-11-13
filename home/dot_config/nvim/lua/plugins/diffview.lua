-- The maintained fork of diffview.nvim; it keeps the module name and commands,
-- so Neogit finds it.
return {
  'dlyongemallo/diffview-plus.nvim',
  -- Only load the diff UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  version = '*',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gvd', '<cmd>DiffviewOpen HEAD -- %<cr>', desc = 'Diff buffer' },
    { '<leader>gvD', '<cmd>DiffviewOpen<cr>', desc = 'Diff repo' },
    { '<leader>gl', '<cmd>DiffviewFileHistory %<cr>', desc = 'Log buffer' },
    { '<leader>gl', ':DiffviewFileHistory<cr>', mode = 'x', desc = 'Log selected lines' },
    { '<leader>gL', '<cmd>DiffviewFileHistory<cr>', desc = 'Log repo' },
  },
}
