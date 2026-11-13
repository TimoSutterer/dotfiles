-- `base...` diffs the split point with the working tree, `base` the ref's
-- latest state; both include untracked files.
local function against_base_branch(latest)
  return function()
    local base = require('config.git').require_base_branch()
    if base then vim.cmd('CodeDiff ' .. base .. (latest and '' or '...')) end
  end
end

return {
  'esmuellert/codediff.nvim',
  -- Only load the diff UI outside VS Code.
  enabled = function() return not vim.g.vscode end,
  version = '*',
  cmd = 'CodeDiff',
  keys = {
    { '<leader>gd', '<cmd>CodeDiff file HEAD<cr>', desc = 'Diff buffer' },
    { '<leader>gD', '<cmd>CodeDiff<cr>', desc = 'Diff repo' },
    { '<leader>gcl', '<cmd>CodeDiff history %<cr>', desc = 'Log buffer' },
    { '<leader>gcl', ':CodeDiff history<cr>', mode = 'x', desc = 'Log selected lines' },
    { '<leader>gcL', '<cmd>CodeDiff history<cr>', desc = 'Log repo' },
    { '<leader>rb', against_base_branch(), desc = 'Diff since split from base branch' },
    { '<leader>rB', against_base_branch(true), desc = "Diff to base branch's latest" },
  },
  opts = { explorer = { view_mode = 'tree' } },
}
