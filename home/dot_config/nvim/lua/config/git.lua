-- Git lookups shared by the plugin specs.
local M = {}

-- The first line git prints, or nil when it fails.
function M.first_line(args)
  local out = vim.fn.systemlist(vim.list_extend({ 'git' }, args))
  if vim.v.shell_error ~= 0 then return nil end
  return out[1]
end

-- The base branch and where it came from: branch.<branch>.workmux-base
-- (written by workmux add --base), else main, else master.
function M.base_branch()
  local branch = M.first_line({ 'branch', '--show-current' })
  local base = branch and branch ~= '' and M.first_line({ 'config', '--get', 'branch.' .. branch .. '.workmux-base' })
  if base and base ~= '' then return base, 'workmux base of ' .. branch end
  for _, name in ipairs({ 'main', 'master' }) do
    if M.first_line({ 'rev-parse', '--verify', '--quiet', 'refs/heads/' .. name }) then
      return name, 'fallback, no workmux base'
    end
  end
end

local function short(commit) return M.first_line({ 'rev-parse', '--short', commit }) end

-- The commit a comparison with ref starts from, and a note naming it: ref's
-- latest commit, or the split point (git merge-base ref HEAD) and how far ref
-- moved on since. Nil when there is no such commit.
local function compare_point(ref, latest)
  local tip = M.first_line({ 'rev-parse', '--verify', '--quiet', ref .. '^{commit}' })
  if not tip then return nil end
  if latest then return tip, 'latest ' .. short(tip) end
  local split = M.first_line({ 'merge-base', ref, 'HEAD' })
  if not split then return nil end
  local note = 'split at ' .. short(split)
  if split ~= tip then
    local count = M.first_line({ 'rev-list', '--count', split .. '..' .. tip })
    note = ('%s · %s moved on: %s commit%s (now %s)'):format(note, ref, count, count == '1' and '' or 's', short(tip))
  end
  return split, note
end

-- Calls open(ref, commit) with the commit a comparison with ref starts from:
-- ref's latest commit when latest is set, else the split point. Then notifies
-- "<label> · <that commit>", so every comparison says what it compares against.
function M.compare(ref, latest, label, open)
  local commit, note = compare_point(ref, latest)
  if not commit then
    vim.notify('No split point from ' .. ref, vim.log.levels.WARN)
    return
  end
  open(ref, commit)
  vim.notify(label .. ' · ' .. note, vim.log.levels.INFO)
end

-- M.compare with the base branch, or a warning that there is none.
function M.compare_base_branch(latest, open)
  local base, source = M.base_branch()
  if not base then
    vim.notify('No base branch', vim.log.levels.WARN)
    return
  end
  M.compare(base, latest, ('Base: %s (%s)'):format(base, source), open)
end

return M
