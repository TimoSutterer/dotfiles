-- Show absolute line number on the current line
vim.opt.number = true
-- Show relative line numbers on all other lines
vim.opt.relativenumber = true

-- Show symbols for tabstops and EOLs
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', eol = '¬' }

-- Keep long lines aligned between codediff.nvim conflict panes during
-- horizontal scrolling. Only affects windows with scrollbind enabled.
vim.opt.scrollopt:append("hor")
