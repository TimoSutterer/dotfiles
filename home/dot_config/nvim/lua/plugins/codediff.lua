return {
  'esmuellert/codediff.nvim',
  -- Only load the diff UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  cmd = 'CodeDiff',
  -- Pin below 2.50. Newer codediff versions return typed Path objects from
  -- get_paths, which review.nvim can't consume. Unpin once
  -- georgeguimaraes/review.nvim#37 is merged and released.
  version = '2.49.2',
  keys = {
    { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Git diff' },
    { '<leader>gD', '<cmd>CodeDiff file HEAD<cr>', desc = 'Git diff current buffer' },
    { '<leader>gl', '<cmd>CodeDiff history<cr>', desc = 'Git log' },
    { '<leader>gL', '<cmd>CodeDiff history %<cr>', desc = 'Git log current buffer' },
  },
}
