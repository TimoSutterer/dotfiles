local git = require('config.git')

-- neo-tree's git_base runs a two-dot `git diff <base> HEAD`, which compares
-- with the ref's latest state; the split point limits it to what this branch
-- changed since it split off. Lowercase keys use the split point.
local function show(_, commit) vim.cmd('Neotree git_status git_base=' .. commit) end

local function against_base_branch(latest)
  return function() git.compare_base_branch(latest, show) end
end

local function against_picked_branch(latest)
  return function()
    local branches = vim.fn.systemlist({ 'git', 'branch', '-a', '--format=%(refname:short)' })
    require('fzf-lua').fzf_exec(branches, {
      prompt = (latest and 'Differences to latest of> ' or 'Changes since split from> '),
      actions = {
        default = function(selected)
          local ref = selected and selected[1]
          if not ref then return end
          local function compare() git.compare(ref, latest, 'Base: ' .. ref .. ' (picked)', show) end
          -- fzf-lua runs this still in terminal mode; leaving it would clear the notice.
          if vim.api.nvim_get_mode().mode ~= 't' then return compare() end
          vim.api.nvim_create_autocmd('ModeChanged', { pattern = 't:*', once = true, callback = compare })
        end,
      },
    })
  end
end

-- neo-tree skips the diff against git_base when `git status` prints the same
-- as last time, so after <leader>tt, <leader>tb showed only uncommitted files.
-- Remove once neo-tree fixes it.
local function patch_git_base()
  local neotree_git = require('neo-tree.git')
  local status = neotree_git.status
  neotree_git.status = function(path, base_lookup, skip_bubbling, ...)
    local s, root, over_base = status(path, base_lookup, skip_bubbling, ...)
    local base = root and base_lookup and base_lookup[root]
    if base and not over_base then
      over_base = require('neo-tree.git.diff').diff_name_status(root, base, skip_bubbling)
      neotree_git.worktrees[root].status_diff[base] = over_base
    end
    return s, root, over_base
  end
end

return {
  'nvim-neo-tree/neo-tree.nvim',
  -- Only load the file tree outside VS Code.
  enabled = function() return not vim.g.vscode end,
  branch = 'v3.x',
  -- Pinned (v3.x after 3.40.0): patch_git_base above patches neo-tree's git internals.
  commit = '1a14083046d96e88e361d1da00761c40d45012f3',
  dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim', 'nvim-mini/mini.icons' },
  cmd = 'Neotree',
  keys = {
    { '<leader>tt', '<cmd>Neotree filesystem toggle<cr>', desc = 'File tree' },
    -- neo-tree remembers the last git_base per worktree, so without git_base=HEAD
    -- this would reuse the branch from tb or to.
    { '<leader>tu', '<cmd>Neotree git_status git_base=HEAD<cr>', desc = 'Uncommitted changes' },
    { '<leader>tb', against_base_branch(), desc = 'Changes since split from base branch' },
    { '<leader>tB', against_base_branch(true), desc = "Differences to base branch's latest" },
    { '<leader>to', against_picked_branch(), desc = 'Changes since split from other branch' },
    { '<leader>tO', against_picked_branch(true), desc = "Differences to other branch's latest" },
  },
  opts = {
    default_component_configs = {
      -- Show changes with git status -s letters instead of Nerd Font icons.
      -- Unlike git's two columns, neo-tree shows the staged change, then the
      -- unstaged one, then + if all of it is staged or ~ if none is: "M +"
      -- staged, "M ~" unstaged, "M M" partly staged. Against a branch (tb, to),
      -- committed changes count as staged.
      git_status = {
        symbols = {
          added = 'A',
          modified = 'M',
          deleted = 'D',
          renamed = 'R',
          untracked = '??',
          ignored = '!!',
          staged = '+',
          unstaged = '~',
          conflict = 'U',
        },
      },
    },
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
    patch_git_base()
  end,
}
