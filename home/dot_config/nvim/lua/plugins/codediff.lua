return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Git diff' },
    { '<leader>gD', '<cmd>CodeDiff file HEAD<cr>', desc = 'Diff current file' },
    { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = 'Git history' },
  },
}
