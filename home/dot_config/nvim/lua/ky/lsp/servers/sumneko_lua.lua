return require('lua-dev').setup {
  lspconfig = {
    cmd = { 'lua-language-server' },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          -- path = runtime_path,
        },
        diagnostics = {
          globals = { 'vim' },
          disable = { 'missing-parameter', 'redundant-parameter' },
        },
        -- workspace = {
        --   library = vim.api.nvim_get_runtime_file('', true),
        --   preloadFileSize = 1000,
        -- },
        completion = {
          callSnippet = 'Replace',
        },
        format = {
          enable = true,
        },
        hint = {
          setType = true,
        },
      },
    },
  },
}
