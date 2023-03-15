return {
  'jackMort/ChatGPT.nvim',
  cmd = { 'ChatGPT' },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('chatgpt').setup({
      yank_register = '"',
      openai_params = {
        max_tokens = 1000,
      },
      keymaps = {
        submit = '<M-Enter>',
      },
    })
  end,
}
