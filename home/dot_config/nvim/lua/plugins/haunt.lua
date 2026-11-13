local git = require('config.git')

local function haunt(fn)
  return function() require('haunt.api')[fn]() end
end

local function note_at(file, line)
  for _, b in ipairs(require('haunt.api').get_bookmarks()) do
    if vim.fs.normalize(b.file) == file and b.line == line then return b end
  end
end

-- Drafts by name, each with its buffer and the file buffer it saves into;
-- vim.fn.bufnr() would also match line 12's for line 1.
local drafts = {}

-- Multiline note editor in a bottom split; :w saves the note. A draft closed
-- unsaved stays in a hidden buffer, and the editor on the same line reopens it.
local function edit_note()
  local api = require('haunt.api')
  local src_buf = vim.api.nvim_get_current_buf()
  local file = vim.fs.normalize(vim.api.nvim_buf_get_name(src_buf))
  local line = vim.api.nvim_win_get_cursor(0)[1]
  if file == '' or vim.bo[src_buf].buftype ~= '' then
    vim.notify('haunt notes need a file buffer', vim.log.levels.WARN)
    return
  end

  local name = ('haunt-note://%s:%d'):format(file, line)
  local draft = drafts[name]
  if not (draft and vim.api.nvim_buf_is_valid(draft.buf)) then
    local buf = vim.api.nvim_create_buf(true, false)
    draft = { buf = buf }
    drafts[name] = draft
    vim.api.nvim_buf_set_name(buf, name)
    vim.bo[buf].buftype = 'acwrite'
    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = 'markdown'
    vim.api.nvim_create_autocmd('BufWriteCmd', {
      buffer = buf,
      callback = function()
        local text = vim.trim(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n'))
        -- haunt works on the current buffer and cursor.
        vim.api.nvim_buf_call(draft.src, function()
          local view = vim.fn.winsaveview()
          vim.api.nvim_win_set_cursor(0, { line, 0 })
          if text ~= '' then
            api.annotate(text)
          elseif note_at(file, line) then
            api.delete()
          end
          vim.fn.winrestview(view)
        end)
        vim.bo[buf].modified = false
      end,
    })
  end
  -- The file's buffer may have been wiped and reopened since the draft began.
  draft.src = src_buf
  local buf = draft.buf

  local new = false
  if vim.bo[buf].modified then
    vim.notify('Draft restored')
  else
    local note = note_at(file, line)
    new = not note
    -- Rewriting the lines resets the cursor, so only when the note changed.
    local lines = vim.split(note and note.note or '', '\n', { plain = true })
    if not vim.deep_equal(lines, vim.api.nvim_buf_get_lines(buf, 0, -1, false)) then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modified = false
    end
  end

  local src_win = vim.api.nvim_get_current_win()
  vim.cmd('botright 10split')
  vim.api.nvim_win_set_buf(0, buf)
  -- Closing the split returns to the window it was opened from.
  vim.api.nvim_create_autocmd('WinClosed', {
    pattern = tostring(vim.api.nvim_get_current_win()),
    once = true,
    callback = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(src_win) then vim.api.nvim_set_current_win(src_win) end
      end)
    end,
  })
  vim.wo.winbar = (' Note %s:%d'):format(vim.fn.fnamemodify(file, ':.'), line)
  if new then vim.cmd('startinsert') end
end

-- Every note by file and line, and the worktree root their paths are shown
-- relative to; nil when there are none.
local function sorted_notes()
  local notes = require('haunt.api').get_bookmarks()
  if #notes == 0 then
    vim.notify('No notes', vim.log.levels.WARN)
    return
  end
  table.sort(notes, function(a, b)
    if a.file == b.file then return a.line < b.line end
    return a.file < b.file
  end)
  return notes, git.first_line({ 'rev-parse', '--show-toplevel' }) or vim.fn.getcwd()
end

-- haunt's fzf picker puts a multiline note on several rows, which breaks the
-- list; this one keeps each note on one row.
local function list_notes()
  local notes, root = sorted_notes()
  if not notes then return end
  local entries = {}
  for _, n in ipairs(notes) do
    local path = vim.fs.relpath(root, n.file) or n.file
    local text = vim.trim(n.note or ''):gsub('\n+', ' ⏎ ')
    table.insert(entries, ('%s:%d:1: %s'):format(path, n.line, text))
  end
  local fzf = require('fzf-lua')
  fzf.fzf_exec(entries, {
    prompt = 'Notes> ',
    cwd = root,
    previewer = 'builtin',
    actions = { default = fzf.actions.file_edit },
  })
end

-- Every note as Markdown, by path:line relative to the worktree root, onto
-- the clipboard and, inside tmux, into the tmux paste buffer.
local function copy_notes()
  local notes, root = sorted_notes()
  if not notes then return end
  local out = { '## Review notes', '' }
  for _, n in ipairs(notes) do
    local path = vim.fs.relpath(root, n.file) or n.file
    table.insert(out, ('### `%s:%d`'):format(path, n.line))
    table.insert(out, '')
    vim.list_extend(out, vim.split(vim.trim(n.note or ''), '\n', { plain = true }))
    table.insert(out, '')
  end
  local text = table.concat(out, '\n')
  vim.fn.setreg('+', text)
  vim.fn.setreg('"', text)
  if vim.env.TMUX then vim.fn.system({ 'tmux', 'load-buffer', '-w', '-' }, text) end
  vim.notify(('Copied %d note(s)'):format(#notes))
end

return {
  'TheNoeTrevino/haunt.nvim',
  -- Only load review notes outside VS Code.
  enabled = function() return not vim.g.vscode end,
  -- Pinned: the note editor, list and copy above build on haunt's API.
  version = '1.3.1',
  -- Loaded at startup so notes show as soon as a file opens.
  lazy = false,
  opts = {
    virt_text_pos = 'above',
    per_branch_bookmarks = true,
    picker = 'fzf',
  },
  keys = {
    { '<leader>rr', edit_note, desc = 'Note: add or edit' },
    { '<leader>rd', haunt('delete'), desc = 'Note: delete' },
    { '<leader>rn', haunt('next'), desc = 'Note: next in buffer' },
    { '<leader>rp', haunt('prev'), desc = 'Note: previous in buffer' },
    { '<leader>rl', list_notes, desc = 'Notes: list' },
    { '<leader>rq', haunt('to_quickfix'), desc = 'Notes: quickfix' },
    { '<leader>rt', haunt('toggle_all_lines'), desc = 'Notes: toggle text' },
    { '<leader>ry', copy_notes, desc = 'Notes: copy as Markdown' },
    { '<leader>rD', haunt('clear_all'), desc = 'Notes: delete all' },
  },
}
