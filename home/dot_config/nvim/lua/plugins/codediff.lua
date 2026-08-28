return {
  'esmuellert/codediff.nvim',
  cmd = 'CodeDiff',
  -- Pin below 2.50. Newer codediff versions return typed Path objects from
  -- get_paths, which review.nvim can't consume. Unpin once
  -- georgeguimaraes/review.nvim#37 is merged and released.
  version = '2.49.2',
  keys = {
    { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Git diff' },
    { '<leader>gD', '<cmd>CodeDiff file HEAD<cr>', desc = 'Diff current file' },
    { '<leader>gh', '<cmd>CodeDiff history<cr>', desc = 'Git history' },
  },
}
