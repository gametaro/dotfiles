local lspconfig = require 'lspconfig'
local null_ls = require 'null-ls'
local helpers = require 'null-ls.helpers'
local b = null_ls.builtins

local M = {}

local actionlint = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { 'yaml' },
  generator = null_ls.generator {
    command = 'actionlint',
    args = { '-no-color', '-oneline', '-' },
    to_stdin = true,
    from_stderr = false,
    format = 'line',
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = helpers.diagnostics.from_pattern([[:(%d+):(%d+): (.*)]], { 'row', 'col', 'message' }),
  },
}

local typos = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {},
  generator = null_ls.generator {
    command = 'typos',
    args = { '--color', 'never', '--format', 'Brief', '-' },
    to_stdin = true,
    from_stderr = true,
    format = 'line',
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = helpers.diagnostics.from_pattern([[:(%d+):(%d+): (.*)]], { 'row', 'col', 'message' }),
  },
}

local sources = {
  b.formatting.prettierd.with {
    condition = function()
      return vim.fn.executable 'prettierd' == 1
    end,
    filetypes = { 'html', 'yaml', 'markdown', 'javascript', 'typescript' },
  },
  -- b.formatting.shellharden.with {
  --   condition = function()
  --     return vim.fn.executable 'shellharden' == 1
  --   end,
  -- },
  b.formatting.shfmt.with {
    condition = function()
      return vim.fn.executable 'shfmt' == 1
    end,
    extra_args = { '-i', '2', '-bn', '-ci', '-kp' },
  },
  b.formatting.stylua.with {
    condition = function()
      return vim.fn.executable 'stylua' == 1
    end,
    extra_args = { '--config-path', vim.fn.stdpath 'config' .. '/stylua.toml' },
  },
  b.formatting.autopep8.with {
    condition = function()
      return vim.fn.executable 'autopep8' == 1
    end,
  },
  b.diagnostics.write_good.with {
    condition = function()
      return vim.fn.executable 'write-good' == 1
    end,
  },
  b.diagnostics.markdownlint.with {
    condition = function()
      return vim.fn.executable 'markdownlint' == 1
    end,
  },
  b.diagnostics.shellcheck.with {
    condition = function()
      return vim.fn.executable 'shellcheck' == 1
    end,
  },
  b.diagnostics.flake8.with {
    condition = function()
      return vim.fn.executable 'flake8' == 1
    end,
  },
  b.diagnostics.pylint.with {
    condition = function()
      return vim.fn.executable 'pylint' == 1
    end,
  },
}

function M.setup(on_attach)
  if vim.fn.executable 'actionlint' == 1 then
    null_ls.register(actionlint)
  end
  if vim.fn.executable 'typos' == 1 then
    null_ls.register(typos)
  end
  null_ls.config {
    sources = sources,
  }
  lspconfig['null-ls'].setup { on_attach = on_attach }
end

return M
