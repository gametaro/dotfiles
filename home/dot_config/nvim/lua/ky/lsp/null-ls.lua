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
  b.formatting.prettierd.with {
    condition = condition 'prettierd',
    filetypes = { 'html', 'yaml', 'markdown', 'javascript', 'typescript' },
  },
  b.formatting.shellharden.with {
    condition = condition 'shellharden',
  },
  b.formatting.shfmt.with {
    condition = condition 'shfmt',
    extra_args = { '-i', '2', '-bn', '-ci', '-kp' },
  },
  b.formatting.stylua.with {
    condition = condition 'stylua',
    extra_args = { '--config-path', vim.fn.stdpath 'config' .. '/stylua.toml' },
  },
  b.formatting.autopep8.with {
    condition = condition 'autopep8',
  },
  b.formatting.fish_indent.with {
    condition = condition 'fish_indent',
  },
  b.diagnostics.markdownlint.with {
    condition = condition 'markdownlint',
  },
  b.diagnostics.shellcheck.with {
    condition = condition 'shellcheck',
  },
  b.diagnostics.flake8.with {
    condition = condition 'flake8',
  },
  b.diagnostics.pylint.with {
    condition = condition 'pylint',
  },
  b.diagnostics.codespell.with {
    disabled_filetypes = { "NeogitCommitMessage" },
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
