return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  -- only load the colorscheme when not in VSCode
  enabled = function() return not vim.g.vscode end,
  config = function()
--    require('catppuccin').setup({
--      flavour = 'mocha',
--      -- enable integrations
--      integrations = {
--        barbar = true,
--        cmp = true,
--        gitsigns = true,
--        treesitter = true,
--        -- etc.
--      },
--    })
    vim.cmd.colorscheme('catppuccin')
  end,
}
