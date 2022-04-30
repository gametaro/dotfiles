vim.api.nvim_set_hl(0, 'BqfPreviewBorder', {
  default = true,
  link = 'FloatBorder',
})
require('bqf').setup {
  filter = {
    fzf = {
      extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
    },
  },
}
