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
  vim.bo[buf].filetype = opts.args
  vim.cmd.buffer(buf)
end, { nargs = 1, complete = 'filetype', desc = 'Create |scratch-buffer|' })
