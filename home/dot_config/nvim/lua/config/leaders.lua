-- Set <leader> to space key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make bare space do nothing instead of its default cursor-right behavior
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
