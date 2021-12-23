local null_ls = require 'null-ls'
local f = null_ls.builtins.formatting
local d = null_ls.builtins.diagnostics
local on_attach = require('ky.lsp').on_attach

local M = {}

local function condition(cmd)
  return function()
    return vim.fn.executable(cmd) == 1
  end
end

local sources = {
  f.prettierd.with {
    condition = condition 'prettierd',
    filetypes = { 'html', 'yaml', 'markdown', 'javascript', 'typescript' },
  },
  f.shellharden.with {
    condition = condition 'shellharden',
  },
  f.shfmt.with {
    condition = condition 'shfmt',
    extra_args = { '-i', '2', '-bn', '-ci', '-kp' },
  },
  f.stylua.with {
    condition = condition 'stylua',
    extra_args = { '--config-path', vim.fn.stdpath 'config' .. '/stylua.toml' },
  },
  f.autopep8.with {
    condition = condition 'autopep8',
  },
  f.fish_indent.with {
    condition = condition 'fish_indent',
  },
  d.markdownlint.with {
    condition = condition 'markdownlint',
  },
  d.shellcheck.with {
    condition = condition 'shellcheck',
  },
  d.flake8.with {
    condition = condition 'flake8',
  },
  d.pylint.with {
    condition = condition 'pylint',
  },
  d.codespell.with {
    disabled_filetypes = { 'NeogitCommitMessage' },
    condition = condition 'codespell',
  },
}

function M.setup()
  null_ls.setup {
    sources = sources,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }
end

return M
