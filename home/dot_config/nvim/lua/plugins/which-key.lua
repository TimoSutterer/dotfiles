return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 700,
    spec = {
      { '<leader>b', group = 'Buffer' },
      { '<leader>f', group = 'Find' },
      { '<leader>g', group = 'Git' },
      { '<leader>gt', group = 'Git toggle' },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer keymaps',
    },
  },
}
