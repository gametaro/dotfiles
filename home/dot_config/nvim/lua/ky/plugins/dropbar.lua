return {
  'Bekaboo/dropbar.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<Leader>wp',
      function()
        require('dropbar.api').pick()
      end,
    },
  },
}
