return {
  'kosayoda/nvim-lightbulb',
  event = 'LspAttach',
  config = function()
    vim.api.nvim_create_autocmd('CursorHold', {
      group = vim.api.nvim_create_augroup('mine__lightbulb', {}),
      callback = function()
        require('nvim-lightbulb').update_lightbulb()
      end,
    })
  end,
}
