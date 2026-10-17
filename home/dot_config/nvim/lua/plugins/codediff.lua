return {
  'esmuellert/codediff.nvim',
  -- Only load the diff UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  version = '*',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Git diff' },
    { '<leader>gD', '<cmd>CodeDiff file HEAD<cr>', desc = 'Git diff current buffer' },
    { '<leader>gl', '<cmd>CodeDiff history<cr>', desc = 'Git log' },
    { '<leader>gL', '<cmd>CodeDiff history %<cr>', desc = 'Git log current buffer' },
  },
}
