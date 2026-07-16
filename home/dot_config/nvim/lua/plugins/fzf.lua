return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-mini/mini.icons' },
  keys = {
    { '<leader><space>', '<cmd>FzfLua global<cr>', desc = 'Fzf global picker' },
    { '<leader>f.', '<cmd>FzfLua resume<cr>', desc = 'Resume last picker' },

    -- Files
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
    { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recent files' },

    -- Buffers (see also the <leader>b namespace in config/keymaps.lua)
    { '<leader>bb', '<cmd>FzfLua buffers<cr>', desc = 'Switch buffer' },

    -- Grep
    { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep project' },
    { '<leader>fl', '<cmd>FzfLua lines<cr>', desc = 'Grep open buffers' },
    { '<leader>f/', '<cmd>FzfLua blines<cr>', desc = 'Grep current buffer' },
    -- Same command on two keys: fw is ergonomic, f* mirrors vim's native * motion
    { '<leader>fw', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word under cursor' },
    { '<leader>f*', '<cmd>FzfLua grep_cword<cr>', desc = 'Grep word under cursor' },

    -- Git
    { '<leader>gl', '<cmd>FzfLua git_log<cr>', desc = 'Git log' },
    { '<leader>gL', '<cmd>FzfLua git_bcommits<cr>', desc = 'Git buffer commits' },

    -- Code / LSP
    -- Override Neovim's built-in navigation mappings with searchable FzfLua
    -- pickers. grr/gri/grt preserve their default LSP meanings, while gd/gD
    -- replace Vim's textual searches and therefore require an attached LSP.
    { 'grr', '<cmd>FzfLua lsp_references<cr>', desc = 'References' },
    { 'gri', '<cmd>FzfLua lsp_implementations<cr>', desc = 'Go to implementation' },
    { 'grt', '<cmd>FzfLua lsp_typedefs<cr>', desc = 'Go to type definition' },
    -- { 'gd', '<cmd>FzfLua lsp_definitions<cr>', desc = 'Go to definition' },
    -- { 'gD', '<cmd>FzfLua lsp_declarations<cr>', desc = 'Go to declaration' },
    -- Lowercase = current document, uppercase = whole workspace
    { '<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', desc = 'Document symbols' },
    { '<leader>fS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = 'Workspace symbols' },
    { '<leader>fd', '<cmd>FzfLua diagnostics_document<cr>', desc = 'Document diagnostics' },
    { '<leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>', desc = 'Workspace diagnostics' },

    -- Help / discovery
    { '<leader>fh', '<cmd>FzfLua helptags<cr>', desc = 'Help tags' },
    { '<leader>fk', '<cmd>FzfLua builtin<cr>', desc = 'Fzf-lua builtins' },
  },
  opts = {},
}
