local ok = prequire('lspconfig') and prequire('cmp_nvim_lsp')
if not ok then
  return
end

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local lsp = vim.lsp

local capabilities = cmp_nvim_lsp.update_capabilities(lsp.protocol.make_client_capabilities())

---@param client table
---@param bufnr integer
local on_attach = function(client, bufnr)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs function
  ---@param opts? table
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- See `:help lsp.*` for documentation on any of the below functions
  map('n', 'gD', lsp.buf.declaration)
  map('n', 'gd', lsp.buf.definition)
  map('n', 'K', lsp.buf.hover)
  map('n', 'gI', lsp.buf.implementation)
  map('i', '<C-s>', lsp.buf.signature_help)
  map('n', '<LocalLeader>wa', lsp.buf.add_workspace_folder)
  map('n', '<LocalLeader>wr', lsp.buf.remove_workspace_folder)
  map('n', '<LocalLeader>wl', function()
    vim.pretty_print(lsp.buf.list_workspace_folders())
  end)
  map('n', '<LocalLeader>D', lsp.buf.type_definition)
  map('n', '<LocalLeader>rN', lsp.buf.rename)
  map('n', '<LocalLeader>rn', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true })
  map({ 'n', 'x' }, '<LocalLeader>ca', function()
    lsp.buf.code_action({
      apply = true,
    })
  end)
  map('n', 'gr', lsp.buf.references)
  map('n', '<LocalLeader>cl', lsp.codelens.run)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  if not client.name == 'null-ls' then
    require('illuminate').on_attach(client)
  end

  -- if client.server_capabilities.documentHighlightProvider then
  --   local group = vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
  --   vim.api.nvim_clear_autocmds {
  --     buffer = bufnr,
  --     group = group,
  --   }
  --   vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  --     group = group,
  --     buffer = bufnr,
  --     callback = function()
  --       local cword = vim.fn.expand('<cword>')
  --       if cword ~= vim.w.document_highlight_cword then
  --         vim.w.document_highlight_cword = cword
  --         lsp.buf.document_highlight()
  --       end
  --     end,
  --   })
  --   vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  --     group = group,
  --     buffer = bufnr,
  --     callback = function()
  --       local cword = vim.fn.expand('<cword>')
  --       if cword ~= vim.w.document_highlight_cword then lsp.buf.clear_references() end
  --     end,
  --   })
  -- end

  map('n', '<M-f>', function()
    lsp.buf.format({
      async = true,
      bufnr = bufnr,
      filter = function(c)
        return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
      end,
    })
  end)
  -- map('n', '<M-f>f', lsp.buf.range_formatting)

  -- local group = vim.api.nvim_create_augroup('lsp_format', { clear = false })
  -- vim.api.nvim_clear_autocmds { buffer = bufnr, group = group }
  -- vim.api.nvim_create_autocmd('BufWritePost', {
  --   group = group,
  --   buffer = bufnr,
  --   callback = function(a) local ok, changedtick = pcall(vim.api.nvim_buf_get_var, a.buf, 'format_changedtick') if ok and changedtick == vim.api.nvim_buf_get_changedtick(a.buf) then
  --       return
  --     end

  --     lsp.buf.format {
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

---@type table<string, function>
local custom_on_attach = {
  eslint = function(client)
    client.server_capabilities.documentFormattingProvider = true
    client.config.settings.format.enable = true
  end,
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = 'mine',
  callback = function(a)
    if not a.data.client_id then
      return
    end

    local client = lsp.get_client_by_id(a.data.client_id)
    on_attach(client, a.buf)
    require('lsp-format').on_attach(client)

    if custom_on_attach[client.name] then
      custom_on_attach[client.name](client)
    end
  end,
})

---@type table<string, table>
local configs = {
  angularls = {},
  bashls = {},
  cssls = {},
  dockerls = {},
  eslint = {
    settings = {
      format = { enable = true },
    },
  },
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },
  marksman = {},
  yamlls = {
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
  },
  sumneko_lua = {
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
          library = {
            vim.fn.expand('$VIMRUNTIME/lua'),
            string.format(
              '%s/site/pack/jetpack/src/github.com/ii14/emmylua-nvim',
              vim.fn.stdpath('data')
            ),
          },
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

for server, config in pairs(configs) do
  config.capabilities = capabilities
  lspconfig[server].setup(config)
end

require('typescript').setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
})
