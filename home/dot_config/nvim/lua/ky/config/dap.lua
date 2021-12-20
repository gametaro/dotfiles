local dap = require 'dap'

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local value = vim.fn.input 'Host [127.0.0.1]: '
      if value ~= '' then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local value = tonumber(vim.fn.input 'Port: ')
      assert(value, 'Please provide a port number')
      return value
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>dc',
  '<Cmd>lua require"dap".continue()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>do',
  '<Cmd>lua require"dap".step_over()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>di',
  '<Cmd>lua require"dap".step_into()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>de',
  '<Cmd>lua require"dap".step_out()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>db',
  '<Cmd>lua require"dap".toggle_breakpoint()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>dB',
  '<Cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>dp',
  '<Cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>dr',
  '<Cmd>lua require"dap".repl.open()<CR>',
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<LocalLeader>dl',
  '<Cmd>lua require"dap".run_last()<CR>',
  { noremap = true, silent = true }
)
