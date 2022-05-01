require('bqf').setup {
  preview = {
    border_chars = { '│', '│', '─', '─', '┌', '┐', '└', '┘', '█' },
  },
  filter = {
    fzf = {
      extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
    },
  },
}
