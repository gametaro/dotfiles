return {
  'kevinhwang91/nvim-bqf',
  dependencies = {
    'junegunn/fzf',
    build = function()
      vim.fn['fzf#install']()
    end,
  },
  config = function()
    require('bqf').setup({
      preview = {
        border_chars = { '│', '│', '─', '─', '┌', '┐', '└', '┘', '█' },
      },
      filter = {
        fzf = {
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
        },
      },
    })
  end,
}
