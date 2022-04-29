local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

return {
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      completion = {
        callSnippet = 'Replace',
      },
      format = {
        enable = false,
      },
      hint = {
        setType = true,
      },
      IntelliSense = {
        traceBeSetted = true,
        traceFieldInject = true,
        traceLocalSet = true,
        traceReturn = true,
      },
    },
  },
}
