-- Repurpose ',' and ';' for buffer navigation.
--
-- By default these repeat the last f/F/t/T character search. But hop.nvim now
-- shadows f/F/t/T (see lua/plugins/hop.lua), and hop jumps to a label rather
-- than a remembered character, so it never sets the "last char search" state.
-- That leaves ',' and ';' with nothing to repeat, so we reclaim them here.
vim.keymap.set("n", ",", "<cmd>bprevious<cr>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", ";", "<cmd>bnext<cr>", { silent = true, desc = "Next buffer" })

-- Alternate (last-used) buffer, i.e. the native <C-^>.
vim.keymap.set("n", "<BS>", "<C-^>", { silent = true, desc = "Alternate buffer" })
