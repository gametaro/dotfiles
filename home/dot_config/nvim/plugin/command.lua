local command = vim.api.nvim_create_user_command

command('FloatWinsClose', function()
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, true)
    end
  end
end, { nargs = 0 })
