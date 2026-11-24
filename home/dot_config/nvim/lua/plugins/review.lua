local function since_base_branch()
  local git = require('config.git')
  local branch = git.first_line({ 'branch', '--show-current' })
  if not branch or branch == '' then
    vim.notify('No current branch', vim.log.levels.WARN)
    return
  end
  -- Review branch on the current branch diffs `base...`, the split point.
  git.compare_base_branch(false, function(base) vim.cmd(('Review branch %s %s'):format(branch, base)) end)
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
