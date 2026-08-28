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

-- The buffer namespace complements the direct navigation keys above (see also
-- the fzf-lua buffers section in plugins/fzf.lua).
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { silent = true, desc = "Delete buffer" })

-- Replace the fzf-lua mappings from plugins/fzf.lua with VS Code's native UI.
if vim.g.vscode then
  local vscode = require("vscode")

  vim.keymap.set("n", "<leader>ff", function()
    vscode.action("workbench.action.quickOpen")
  end, { desc = "Find files" })

  vim.keymap.set("n", "<leader>fg", function()
    vscode.action("workbench.action.findInFiles")
  end, { desc = "Grep project" })
end
