return {
  'kyazdani42/nvim-web-devicons',
  dependencies = 'DaikyXendo/nvim-material-icon',
  enabled = vim.g.devicons,
  config = function()
    require('nvim-web-devicons').setup({
      override = require('nvim-material-icon').get_icons(),
    })
  end,
}
