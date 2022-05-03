require('auto-session').setup {
  pre_save_cmds = {
    function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config_ = vim.api.nvim_win_get_config(win)
        if config_.relative ~= '' then
          vim.api.nvim_win_close(win, false)
        end
      end
    end,
  },
}
