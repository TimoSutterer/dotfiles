return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          desc = desc,
        })
      end

      local function confirm(message, action)
        return function()
          -- Default is 'No', so accidentally pressing Enter will not discard changes.
          local choice = vim.fn.confirm(message, '&Yes\n&No', 2, 'Warning')

          if choice == 1 then
            action()
          end
        end
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, 'Next git hunk')

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, 'Previous git hunk')

      -- Actions
      map('n', '<leader>gs', gitsigns.stage_hunk, 'Stage hunk')
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Stage selected hunk')
      map('n', '<leader>gS', gitsigns.stage_buffer, 'Stage buffer')

      map(
        'n',
        '<leader>gr',
        confirm('Reset current hunk?', function()
          gitsigns.reset_hunk()
        end),
        'Reset hunk'
      )
      map('v', '<leader>gr', function()
        local start_line = vim.fn.line('.')
        local end_line = vim.fn.line('v')

        local choice = vim.fn.confirm('Reset selected hunk lines?', '&Yes\n&No', 2, 'Warning')

        if choice == 1 then
          gitsigns.reset_hunk({ start_line, end_line })
        end
      end, 'Reset selected hunk')
      map(
        'n',
        '<leader>gR',
        confirm('Reset entire buffer?', function()
          gitsigns.reset_buffer()
        end),
        'Reset buffer'
      )

      map('n', '<leader>gp', gitsigns.preview_hunk, 'Preview hunk')
      map('n', '<leader>gi', gitsigns.preview_hunk_inline, 'Preview hunk inline')

      map('n', '<leader>gb', function()
        gitsigns.blame_line({ full = true })
      end, 'Blame line')

      -- These mappings are handled by CodeDiff.
      -- map('n', '<leader>gd', gitsigns.diffthis, 'Diff this')
      -- map('n', '<leader>gD', function()
      --   gitsigns.diffthis('~')
      -- end, 'Diff this against previous commit')

      map('n', '<leader>gq', gitsigns.setqflist, 'Set quickfix list')
      map('n', '<leader>gQ', function()
        gitsigns.setqflist('all')
      end, 'Set quickfix list with all hunks')

      -- Toggles
      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, 'Toggle git blame line')
      map('n', '<leader>gtw', gitsigns.toggle_word_diff, 'Toggle git word diff')

      -- Text object: select the current git hunk.
      -- Example: `dih` deletes the current hunk, `yih` yanks it, `vih` visually selects it.
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Select git hunk')
    end,
  },
}
