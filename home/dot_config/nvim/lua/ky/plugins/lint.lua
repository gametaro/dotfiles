return {
  'mfussenegger/nvim-lint',
  config = function()
    require('lint').linters_by_ft = {
      yaml = { 'actionlint' },
      sh = { 'shellcheck' },
      bash = { 'shellcheck' },
      zsh = { 'shellcheck' },
    }
    vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
      callback = function()
        require('lint').try_lint()
      end,
    })
  end,
}
