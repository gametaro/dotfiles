return {
  'ruifm/gitlinker.nvim',
  init = function()
    for _, v in ipairs({ 'n', 'v' }) do
      vim.keymap.set(v, 'gb', function()
        require('gitlinker').get_buf_range_url(v, { action_callback = vim.fn['openbrowser#open'] })
      end, { desc = 'Goto repo' })
      vim.keymap.set(v, '<Leader>gy', function()
        require('gitlinker').get_buf_range_url(v)
      end, { desc = 'Copy repo url' })
    end
    vim.keymap.set('n', 'gB', function()
      require('gitlinker').get_repo_url({
        action_callback = vim.fn['openbrowser#open'],
      })
    end, { desc = 'Goto repo' })
    vim.keymap.set('n', '<Leader>gY', function()
      require('gitlinker').get_repo_url()
    end, { desc = 'Copy repo url' })
  end,
  config = function()
    require('gitlinker').setup({
      mappings = nil,
    })
  end,
}
