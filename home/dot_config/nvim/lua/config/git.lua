-- Git lookups shared by the plugin specs.
local M = {}

-- The first line git prints, or nil when it fails.
function M.first_line(args)
  local out = vim.fn.systemlist(vim.list_extend({ 'git' }, args))
  if vim.v.shell_error ~= 0 then return nil end
  return out[1]
end

-- The base branch: branch.<branch>.workmux-base (written by workmux add
-- --base), else main, else master.
function M.base_branch()
  local branch = M.first_line({ 'branch', '--show-current' })
  local base = branch and branch ~= '' and M.first_line({ 'config', '--get', 'branch.' .. branch .. '.workmux-base' })
  if base and base ~= '' then return base end
  for _, name in ipairs({ 'main', 'master' }) do
    if M.first_line({ 'rev-parse', '--verify', '--quiet', 'refs/heads/' .. name }) then return name end
  end
end

-- The base branch, or nil after warning that there is none.
function M.require_base_branch()
  local base = M.base_branch()
  if not base then vim.notify('No base branch', vim.log.levels.WARN) end
  return base
end

return M
