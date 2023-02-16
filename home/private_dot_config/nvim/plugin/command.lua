vim.api.nvim_create_user_command('FloatWinsClose', function()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, true)
    end
  end
end, { nargs = 0 })

vim.api.nvim_create_user_command('DiagnosticEnable', function()
  vim.diagnostic.enable(0)
end, { desc = 'Enable diagnostics in current buffer' })
vim.api.nvim_create_user_command('DiagnosticDisable', function()
  vim.diagnostic.disable(0)
end, { desc = 'Disable diagnostics in current buffer' })
vim.api.nvim_create_user_command('DiagnosticEnableAll', function()
  vim.diagnostic.enable()
end, { desc = 'Enable diagnostics in all buffers' })
vim.api.nvim_create_user_command('DiagnosticDisableAll', function()
  vim.diagnostic.disable()
end, { desc = 'Disable diagnostics in all buffers' })

vim.api.nvim_create_user_command('Scrach', function(opts)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].filetype = opts.args or ''
  vim.cmd.buffer(buf)
end, { nargs = '?', complete = 'filetype', desc = 'Create |scratch-buffer|' })

vim.api.nvim_create_user_command('LspInfo', function(opts)
  local args = opts.args
  local client = vim.lsp.get_active_clients({ name = args })[1]
  vim.pretty_print(client)
end, {
  desc = 'Inspect language client',
  nargs = 1,
  complete = function()
    return vim.tbl_map(function(client)
      return client.name
    end, vim.lsp.get_active_clients())
  end,
})

vim.api.nvim_create_user_command('LspStop', function(opts)
  local args = opts.args
  local client = vim.lsp.get_active_clients({ name = args })[1]
  client.stop()
end, {
  desc = 'Stop language client',
  nargs = 1,
  complete = function()
    return vim.tbl_map(function(client)
      return client.name
    end, vim.lsp.get_active_clients())
  end,
})

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd.tabedit(vim.lsp.get_log_path())
end, {
  desc = 'Open language client log',
  nargs = 0,
})

vim.api.nvim_create_user_command('WorkspaceAdd', function(opts)
  local args = opts.args ~= '' and opts.args or nil
  vim.lsp.buf.add_workspace_folder(args)
end, { desc = 'Add workspace', nargs = '?', complete = 'dir' })
vim.api.nvim_create_user_command('WorkspaceRemove', function(opts)
  local args = opts.args ~= '' and opts.args or nil
  vim.lsp.buf.remove_workspace_folder(args)
end, { desc = 'Remove workspace', nargs = '?', complete = 'dir' })
vim.api.nvim_create_user_command('WorkspaceList', function()
  vim.pretty_print(vim.lsp.buf.list_workspace_folders())
end, { desc = 'List workspace', nargs = 0 })
