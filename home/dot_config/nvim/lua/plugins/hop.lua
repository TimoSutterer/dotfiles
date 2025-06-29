return {
  'smoka7/hop.nvim',
  version = '*', 
  keys = {
    -- 's' in normal mode: trigger hop with 2-character search
    { 's', '<cmd>HopChar2<CR>' },
    -- 's' in operator-pending mode: enables motions like 'ys' (yank to hop target)
    { 's', '<cmd>HopChar2<CR>', mode = 'o' },
    -- NOTE: 's' normally deletes the character under cursor and enters insert mode,
    -- but this can be achieved with 'cl' instead
  },
  config = function()
    require('hop').setup()
  end,
}
