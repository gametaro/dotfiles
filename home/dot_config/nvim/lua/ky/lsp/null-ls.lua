local null_ls = require('null-ls')
local f = null_ls.builtins.formatting
local d = null_ls.builtins.diagnostics
local h = null_ls.builtins.hover
local on_attach = require('ky.lsp').on_attach

local M = {}

local function executable(cmd)
  return function()
    return vim.fn.executable(cmd) == 1
  end
end

local sources = {
  f.prettierd.with {
    condition = executable('prettierd'),
    filetypes = { 'html', 'yaml', 'markdown', 'javascript', 'typescript' },
  },
  f.shellharden.with {
    condition = executable('shellharden'),
  },
  f.shfmt.with {
    condition = executable('shfmt'),
    extra_args = { '-i', '2', '-bn', '-ci', '-kp' },
  },
  f.stylua.with {
    condition = executable('stylua'),
  },
  f.autopep8.with {
    condition = executable('autopep8'),
  },
  f.fish_indent.with {
    condition = executable('fish_indent'),
  },
  d.markdownlint.with {
    condition = executable('markdownlint'),
  },
  d.shellcheck.with {
    condition = executable('shellcheck'),
  },
  d.flake8.with {
    condition = executable('flake8'),
  },
  d.pylint.with {
    condition = executable('pylint'),
  },
  d.codespell.with {
    disabled_filetypes = { 'NeogitCommitMessage' },
    condition = executable('codespell'),
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
  },
  h.dictionary,
}

function M.setup()
  null_ls.setup {
    sources = sources,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 500,
    },
  }
end

return M
