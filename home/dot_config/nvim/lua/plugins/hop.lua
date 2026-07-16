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
  },
  config = function()
    require('hop').setup({
      -- Order the hint labels along the home row (and nearby keys) so the most
      -- common jumps use the strongest fingers and require the least movement.
      keys = 'etovxqpdygfblzhckisuran',
    })
  end,
}
