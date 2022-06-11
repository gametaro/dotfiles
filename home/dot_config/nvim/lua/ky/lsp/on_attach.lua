return function(client, bufnr)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  if client.server_capabilities.declarationProvider then
    map('n', 'gD', vim.lsp.buf.declaration)
  end
  if client.server_capabilities.definitionProvider then
    map('n', 'gd', vim.lsp.buf.definition)
  end
  if client.server_capabilities.hoverProvider then
    map('n', 'K', vim.lsp.buf.hover)
  end
  if client.server_capabilities.implementationProvider then
    map('n', 'gi', vim.lsp.buf.implementation)
  end
  if client.server_capabilities.signatureHelpProvider then
    map('i', '<C-s>', vim.lsp.buf.signature_help)
  end
  map('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder)
  map('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder)
  map('n', '<LocalLeader>wl', function()
    vim.pretty_print(vim.lsp.buf.list_workspace_folders())
  end)
  if client.server_capabilities.typeDefinitionProvider then
    map('n', '<LocalLeader>D', vim.lsp.buf.type_definition)
  end
  if client.server_capabilities.renameProvider then
    map('n', '<LocalLeader>rN', vim.lsp.buf.rename)
    map('n', '<LocalLeader>rn', function()
      return ':IncRename ' .. vim.fn.expand('<cword>')
    end, { expr = true })
  end
  if client.server_capabilities.codeActionProvider then
    map('n', '<LocalLeader>ca', function()
      vim.lsp.buf.code_action {
        apply = true,
      }
    end)
    map('x', '<LocalLeader>ca', vim.lsp.buf.range_code_action)
  end
  if client.server_capabilities.referencesProvider then
    map('n', 'gr', vim.lsp.buf.references)
  end
  if client.server_capabilities.codeLensProvider then
    map('n', '<LocalLeader>cl', vim.lsp.codelens.run)
  end

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

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
  --     end,
  --   })
  -- end
  if client.server_capabilities.documentFormattingProvider then
    map('n', '<M-f>', function()
      vim.lsp.buf.format {
        async = true,
        bufnr = bufnr,
        filter = function(c)
          return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
        end,
      }
    end)
  elseif client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set('n', '<M-f>f', vim.lsp.buf.range_formatting)
  end

  require('lsp-format').on_attach(client)
end
