return {
  'smoka7/hop.nvim',
  version = '*', 
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
    require('hop').setup()
  end,
}
