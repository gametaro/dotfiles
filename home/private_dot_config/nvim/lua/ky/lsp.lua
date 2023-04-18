vim.lsp.set_log_level(vim.log.levels.ERROR)

-- taken from |cmp-nvim-lsp|
local cmp_capabilities = {
  textDocument = {
    completion = {
      dynamicRegistration = false,
      completionItem = {
        snippetSupport = true,
        commitCharactersSupport = true,
        deprecatedSupport = true,
        preselectSupport = true,
        tagSupport = {
          valueSet = {
            1, -- Deprecated
          },
        },
        insertReplaceSupport = true,
        resolveSupport = {
          properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
          },
        },
        insertTextModeSupport = {
          valueSet = {
            1, -- asIs
            2, -- adjustIndentation
          },
        },
        labelDetailsSupport = true,
      },
      contextSupport = true,
      insertTextMode = 1,
      completionList = {
        itemDefaults = {
          'commitCharacters',
          'editRange',
          'insertTextFormat',
          'insertTextMode',
          'data',
        },
      },
    },
    -- for |nvim-ufo|
    foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    },
  },
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = true,
    },
  },
}

local capabilities =
  vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), cmp_capabilities)

vim.lsp.handlers['textDocument/publishDiagnostics'] = (function(fn)
  return function(_, result, ctx, config)
    vim.map(function(item)
      if item.relatedInformation and #item.relatedInformation > 0 then
        vim.map(function(info)
          if info.location then
            info.message = string.format(
              '%s(%d, %d): %s',
              vim.fs.basename(vim.uri_to_fname(info.location.uri)),
              (info.location.range.start.line + 1),
              (info.location.range.start.character + 1),
              info.message
            )
          end
          item.message = item.message .. '\n' .. info.message
        end, item.relatedInformation)
      end
    end, result.diagnostics)
    fn(_, result, ctx, config)
  end
end)(vim.lsp.handlers['textDocument/publishDiagnostics'])

vim.lsp.start = (function(fn)
  return function(config, opts)
    if vim.api.nvim_buf_line_count(0) > vim.g.max_line_count then
      return
    end
    config = config or {}
    local root_dir = config.root_dir or require('ky.util').get_root_by_names(config.root_names)
    config = vim.tbl_deep_extend('force', config, {
      capabilities = capabilities,
      root_dir = root_dir,
    })
    fn(config, opts)
  end
end)(vim.lsp.start)

local function format()
  vim.lsp.buf.format({ async = true })
end

---@param client lsp.Client
---@param buf integer
local function on_attach(client, buf)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'Goto definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buf, desc = 'Goto declaration' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buf, desc = 'References' })
  vim.keymap.set(
    'n',
    'gI',
    vim.lsp.buf.implementation,
    { buffer = buf, desc = 'Goto implementation' }
  )
  -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = buf , desc = 'Goto type definition' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'Hover' })
  vim.keymap.set(
    'i',
    '<C-s>',
    vim.lsp.buf.signature_help,
    { buffer = buf, desc = 'Signature help' }
  )
  vim.keymap.set('n', '<Leader>cr', function()
    require('inc_rename')
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true, buffer = buf, desc = 'Rename' })
  vim.keymap.set({ 'n', 'x' }, '<Leader>ca', function()
    vim.lsp.buf.code_action({ apply = true })
  end, { buffer = buf, desc = 'Code action' })
  vim.keymap.set('n', '<Leader>cl', vim.lsp.codelens.run, { buffer = buf, desc = 'Codelens' })
  vim.keymap.set({ 'n', 'x' }, '<M-f>', format, { buffer = buf, desc = 'Format' })

  if client.name == 'yaml' then
    client.server_capabilities.documentFormattingProvider = true
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('mine__lsp', {}),
  callback = function(a)
    ---@type lsp.Client
    local client = vim.lsp.get_client_by_id(a.data.client_id)
    on_attach(client, a.buf)
  end,
})
