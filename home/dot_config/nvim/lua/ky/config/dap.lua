local dap = require('dap')

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= '' then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local value = tonumber(vim.fn.input('Port: '))
      assert(value, 'Please provide a port number')
      return value
    end,
  },
}

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

vim.keymap.set('n', '<LocalLeader>dc', function()
  require('dap').continue()
end)
vim.keymap.set('n', '<LocalLeader>do', function()
  require('dap').step_over()
end)
vim.keymap.set('n', '<LocalLeader>di', function()
  require('dap').step_into()
end)
vim.keymap.set('n', '<LocalLeader>de', function()
  require('dap').step_out()
end)
vim.keymap.set('n', '<LocalLeader>db', function()
  require('dap').toggle_breakpoint()
end)
vim.keymap.set('n', '<LocalLeader>dB', function()
  require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
vim.keymap.set('n', '<LocalLeader>dp', function()
  require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end)
vim.keymap.set('n', '<LocalLeader>dr', function()
  require('dap').repl.open()
end)
vim.keymap.set('n', '<LocalLeader>dl', function()
  require('dap').run_last()
end)
