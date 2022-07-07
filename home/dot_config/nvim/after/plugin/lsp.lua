local ok = prequire('lspconfig')
if not ok then return end

local lsp_config = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'K', vim.lsp.buf.hover)
  map('n', 'gi', vim.lsp.buf.implementation)
  map('i', '<C-s>', vim.lsp.buf.signature_help)
  map('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder)
  map('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder)
  map('n', '<LocalLeader>wl', function()
    vim.pretty_print(vim.lsp.buf.list_workspace_folders())
  end)
  map('n', '<LocalLeader>D', vim.lsp.buf.type_definition)
  map('n', '<LocalLeader>rN', vim.lsp.buf.rename)
  map('n', '<LocalLeader>rn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true })
  map('n', '<LocalLeader>ca', function()
    vim.lsp.buf.code_action {
      apply = true,
    }
  end)
  map('x', '<LocalLeader>ca', vim.lsp.buf.range_code_action)
  map('n', 'gr', vim.lsp.buf.references)
  map('n', '<LocalLeader>cl', vim.lsp.codelens.run)

  if client.config.flags then client.config.flags.allow_incremental_sync = true end

  -- sometimes feel annoyed...
  -- if client.server_capabilities.documentHighlightProvider then
  --   local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = true })
  --   vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  --     group = group,
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.document_highlight()
  --     end,
  --   })
  --   vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  --     group = group,
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.clear_references()
  --     end, })
  -- end
  map('n', '<M-f>', function()
    vim.lsp.buf.format {
      async = true,
      bufnr = bufnr,
      filter = function(c)
        return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
      end,
    }
  end)
  -- map('n', '<M-f>f', vim.lsp.buf.range_formatting)

  -- local group = vim.api.nvim_create_augroup('lsp_format', { clear = false })
  -- vim.api.nvim_clear_autocmds { buffer = bufnr, group = group }
  -- vim.api.nvim_create_autocmd('BufWritePost', {
  --   group = group,
  --   buffer = bufnr,
  --   callback = function(a) local ok, changedtick = pcall(vim.api.nvim_buf_get_var, a.buf, 'format_changedtick') if ok and changedtick == vim.api.nvim_buf_get_changedtick(a.buf) then
  --       return
  --     end

  --     vim.lsp.buf.format {
  --       async = true,
  --       bufnr = a.buf,
  --       filter = function(c)
  --         return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
  --       end,
  --     }

  --     vim.defer_fn(function()
  --       vim.api.nvim_command('update')
  --       vim.api.nvim_buf_set_var(a.buf, 'format_changedtick', vim.b.changedtick)
  --     end, 150)
  --   end,
  -- })
end

local custom_on_attach = {
  tsserver = function(client)
    local ts = require('nvim-lsp-ts-utils')
    ts.setup {
      update_imports_on_move = true,
      require_confirmation_on_move = true,
      auto_inlay_hints = false,
    }
    ts.setup_client(client)
  end,
  eslint = function(client)
    client.server_capabilities.documentFormattingProvider = true
    client.config.settings.format.enable = true
  end,
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = 'mine',
  callback = function(a)
    if not a.data.client_id then return end

    local bufnr = a.buf
    local client = vim.lsp.get_client_by_id(a.data.client_id)

    on_attach(client, bufnr)

    require('lsp-format').on_attach(client)

    if custom_on_attach[client.name] then custom_on_attach[client.name](client) end
  end,
})

local configs = {
  eslint = function()
    return {
      settings = {
        format = { enable = true },
      },
    }
  end,
  jsonls = function()
    return {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    }
  end,
  yamlls = function()
    return {
      settings = {
        yaml = {
          schemas = require('schemastore').json.schemas(),
          -- for cloudformation
          -- see https://github.com/aws-cloudformation/cfn-lint-visual-studio-code/issues/69
          customTags = {
            '!And',
            '!And sequence',
            '!If',
            '!If sequence',
            '!Not',
            '!Not sequence',
            '!Equals',
            '!Equals sequence',
            '!Or',
            '!Or sequence',
            '!FindInMap',
            '!FindInMap sequence',
            '!Base64',
            '!Join',
            '!Join sequence',
            '!Cidr',
            '!Ref',
            '!Sub',
            '!Sub sequence',
            '!GetAtt',
            '!GetAZs',
            '!ImportValue',
            '!ImportValue sequence',
            '!Select',
            '!Select sequence',
            '!Split',
            '!Split sequence',
          },
        },
      },
    }
  end,
  sumneko_lua = function()
    return require('lua-dev').setup {
      lspconfig = {
        cmd = { 'lua-language-server' },
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'missing-parameter', 'redundant-parameter' },
              neededFileStatus = {
                -- ['codestyle-check'] = 'Any',
                -- ['type-check'] = 'Any',
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              -- preloadFileSize = 1000,
            },
            completion = {
              callSnippet = 'Replace',
            },
            format = {
              enable = false,
            },
            hint = {
              setType = true,
            },
          },
        },
      },
    }
  end,
}

for _, server in ipairs(lsp_installer.get_installed_servers()) do
  local config = configs[server.name] and configs[server.name]() or {}
  config.capabilities = capabilities
  lsp_config[server.name].setup(config)
end
