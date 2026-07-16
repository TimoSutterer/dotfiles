return {
  'smoka7/hop.nvim',
  -- Track the latest commit on the default branch, since this fork does not
  -- publish reliable semver tags.
  version = false,
  keys = {
    -- 's' as a 2-char hop motion in normal, visual, and operator-pending modes.
    -- 's' in operator-pending mode enables motions like 'ys' (yank to hop
    -- target).
    -- NOTE: 's' normally deletes the character under cursor and enters insert
    -- mode, but this can be achieved with 'cl' instead.
    {
      's',
      function()
        require('hop').hint_char2()
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Hop to 2-char match',
    },
    -- Replace the native f/F/t/T single-line char motions with hop equivalents.
    -- 'current_line_only' keeps them line-local like the builtins, and mapping
    -- for operator-pending mode makes df/df/yt/ct etc. work as inclusive motions.
    -- 't'/'T' use hint_offset to stop just before the target, like the builtins.
    {
      'f',
      function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Hop forward to char (this line)',
    },
    {
      'F',
      function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Hop backward to char (this line)',
    },
    {
      't',
      function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Hop before char forward (this line)',
    },
    {
      'T',
      function()
        require('hop').hint_char1({
          direction = require('hop.hint').HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end,
      mode = { 'n', 'x', 'o' },
      desc = 'Hop before char backward (this line)',
    },
  },
  config = function()
    require('hop').setup({
      -- Order the hint labels along the home row (and nearby keys) so the most
      -- common jumps use the strongest fingers and require the least movement.
      keys = 'etovxqpdygfblzhckisuran',
    })
  end,
}
