return {
  'zbirenbaum/neodim',
  event = 'LspAttach',
  config = function()
    require('neodim').setup({
      hide = {
        virtual_text = false,
        signs = false,
        underline = false,
      },
    })
  end,
}
