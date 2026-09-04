return {
  'georgeguimaraes/review.nvim',
  -- Only load the review UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  version = '*',
  dependencies = {
    'esmuellert/codediff.nvim',
    'MunifTanjim/nui.nvim',
  },
  cmd = { 'Review' },
  keys = {
    { '<leader>rr', '<cmd>Review<cr>', desc = 'Review working tree' },
    { '<leader>rc', '<cmd>Review commits<cr>', desc = 'Review commits' },
  },
  opts = {},
}
