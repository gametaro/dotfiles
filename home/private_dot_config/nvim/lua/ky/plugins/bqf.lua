return {
  'kevinhwang91/nvim-bqf',
  dependencies = {
    'junegunn/fzf',
    build = function()
      vim.fn['fzf#install']()
    end,
  },
  ft = 'qf',
  config = function()
    require('bqf').setup({
      auto_resize_height = false,
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
