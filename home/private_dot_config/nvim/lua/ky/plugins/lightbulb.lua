return {
  'kosayoda/nvim-lightbulb',
  event = 'LspAttach',
  enabled = false,
  config = function()
    vim.api.nvim_create_autocmd('CursorHold', {
      group = vim.api.nvim_create_augroup('mine__lightbulb', {}),
      callback = function()
        require('nvim-lightbulb').setup({
          ignore = { 'sqlls' },
        })
        require('nvim-lightbulb').update_lightbulb({
          sign = {
            enabled = false,
          },
          virtual_text = {
            enabled = true,
          },
        })
      end,
    })
  end,
}
