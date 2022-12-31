return {
  'cshuaimin/ssr.nvim',
  enabled = false,
  config = function()
    require('ssr').setup({
      min_width = 50,
      min_height = 5,
      keymaps = {
        close = 'q',
        next_match = 'n',
        prev_match = 'N',
        replace_all = '<LocalLeader><CR>',
      },
    })
    vim.keymap.set('n', '<LocalLeader>rs', require('ssr').open)
  end,
}
