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
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'K', vim.lsp.buf.hover)
  -- map('n', 'gi', vim.lsp.buf.implementation)
  -- map('i', '<C-s>', vim.lsp.buf.signature_help)
  map('n', '<LocalLeader>wa', vim.lsp.buf.add_workspace_folder)
  map('n', '<LocalLeader>wr', vim.lsp.buf.remove_workspace_folder)
  map('n', '<LocalLeader>wl', function()
    vim.pretty_print(vim.lsp.buf.list_workspace_folders())
  end)
  map('n', '<LocalLeader>D', vim.lsp.buf.type_definition)
  map('n', '<LocalLeader>rn', vim.lsp.buf.rename)
  map('n', '<LocalLeader>ca', vim.lsp.buf.code_action)
  map('n', 'gr', vim.lsp.buf.references)
  map('n', '<LocalLeader>e', vim.diagnostic.open_float)
  map('n', '[d', vim.diagnostic.goto_prev)
  map('n', ']d', vim.diagnostic.goto_next)
  map('n', '<LocalLeader>lq', vim.diagnostic.setqflist)
  map('n', '<LocalLeader>ll', vim.diagnostic.setloclist)

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
  end

  -- sometimes feel annoyed...
  -- if client.server_capabilities.documentHighlightProvider then
  --   vim.cmd [[
  --     augroup lsp_document_highlight
  --       autocmd! * <buffer>
  --       autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
  --       autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
  --     augroup END
  --     ]]
  -- end
  if client.server_capabilities.documentFormattingProvider then
    vim.keymap.set('n', '<M-f>', function()
      vim.lsp.buf.format { async = true }
    end)
  elseif client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set('n', '<M-f>f', vim.lsp.buf.range_formatting)
  end

  require('lsp-format').on_attach(client)
end
