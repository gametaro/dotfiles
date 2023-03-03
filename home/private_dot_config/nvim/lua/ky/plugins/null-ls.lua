return {
  'jose-elias-alvarez/null-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local null_ls = require('null-ls')
    local f = null_ls.builtins.formatting
    local d = null_ls.builtins.diagnostics

    local sources = {
      f.autopep8,
      f.fish_indent,
      f.prettierd,
      f.shellharden,
      f.shfmt,
      f.stylua,
      f.yamlfmt,
      d.actionlint,
      d.cfn_lint,
      d.flake8,
      d.gitlint,
      d.markdownlint,
      d.pylint,
      d.shellcheck,
      d.vale,
      d.zsh,
    }

    null_ls.setup({
      sources = sources,
      border = vim.g.border,
      should_attach = function()
        return vim.api.nvim_buf_line_count(0) <= vim.g.max_line_count
      end,
    })
  end,
}
