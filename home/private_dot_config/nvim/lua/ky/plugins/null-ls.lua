return {
  'jose-elias-alvarez/null-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local null_ls = require('null-ls')
    local f = null_ls.builtins.formatting
    local d = null_ls.builtins.diagnostics

    local function wrap(builtin)
      builtin.condition = function()
        return vim.fn.executable(builtin._opts.command) > 0
      end
      return builtin
    end

    local sources = {
      wrap(f.autopep8),
      wrap(f.fish_indent),
      wrap(f.prettierd),
      wrap(f.shellharden),
      wrap(f.shfmt),
      wrap(f.stylua),
      wrap(f.yamlfmt),
      wrap(d.actionlint),
      wrap(d.cfn_lint),
      wrap(d.flake8),
      wrap(d.gitlint),
      wrap(d.markdownlint),
      wrap(d.pylint),
      wrap(d.shellcheck),
      wrap(d.vale),
      wrap(d.zsh),
    }

    null_ls.setup({
      sources = sources,
      border = vim.g.border,
      log_level = 'off',
      should_attach = function(buf)
        if vim.api.nvim_buf_line_count(buf) > vim.g.max_line_count then
          return false
        end
        if vim.startswith(vim.api.nvim_buf_get_name(buf), 'diffview://') then
          return false
        end
        return true
      end,
    })
  end,
}
