return {
  'jose-elias-alvarez/null-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local null_ls = require('null-ls')
    local f = null_ls.builtins.formatting
    local d = null_ls.builtins.diagnostics

    local function executable(cmd)
      return function()
        return vim.fn.executable(cmd) == 1
      end
    end

    local sources = {
      f.prettierd.with({
        condition = executable('prettierd'),
        filetypes = { 'html', 'yaml', 'markdown', 'javascript', 'typescript' },
      }),
      f.shellharden.with({
        condition = executable('shellharden'),
      }),
      f.shfmt.with({
        condition = executable('shfmt'),
        -- extra_args = { '-i', '2', '-bn', '-ci', '-kp' },
      }),
      f.stylua.with({
        condition = executable('stylua'),
      }),
      f.autopep8.with({
        condition = executable('autopep8'),
      }),
      f.fish_indent.with({
        condition = executable('fish_indent'),
      }),
      f.yamlfmt.with({
        condition = executable('yamlfmt'),
      }),
      d.markdownlint.with({
        condition = executable('markdownlint'),
      }),
      d.shellcheck.with({
        condition = executable('shellcheck'),
      }),
      d.flake8.with({
        condition = executable('flake8'),
      }),
      d.pylint.with({
        condition = executable('pylint'),
      }),
      d.vale.with({
        condition = executable('vale'),
      }),
      d.cfn_lint.with({
        condition = executable('cfn-lint'),
      }),
      d.zsh.with({
        condition = executable('zsh'),
      }),
      d.actionlint.with({
        condition = executable('actionlint'),
      }),
      d.gitlint.with({
        condition = executable('gitlint'),
      }),
    }

    null_ls.setup({
      sources = sources,
    })
  end,
}
