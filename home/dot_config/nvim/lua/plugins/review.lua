local function since_base_branch()
  local git = require('config.git')
  local branch = git.first_line({ 'branch', '--show-current' })
  local base = git.base_branch()
  if not (branch and base) then
    vim.notify('No current branch or base branch', vim.log.levels.WARN)
    return
  end
  vim.cmd(('Review branch %s %s'):format(branch, base))
end

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
    { '<leader>rvu', '<cmd>Review<cr>', desc = 'Review uncommitted' },
    { '<leader>rvc', '<cmd>Review commits<cr>', desc = 'Review commits' },
    { '<leader>rvb', since_base_branch, desc = 'Review since split from base branch' },
  },
  opts = {},
}
