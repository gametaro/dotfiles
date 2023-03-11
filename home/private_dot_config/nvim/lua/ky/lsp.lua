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
---@param buffer integer
local function on_attach(client, buffer)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buffer, desc = 'Goto definition' })
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = buffer, desc = 'Goto declaration' })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buffer, desc = 'References' })
  vim.keymap.set(
    'n',
    'gI',
    vim.lsp.buf.implementation,
    { buffer = buffer, desc = 'Goto implementation' }
  )
  -- vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = buffer , desc = 'Goto type definition' })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buffer, desc = 'Hover' })
  vim.keymap.set(
    'i',
    '<C-s>',
    vim.lsp.buf.signature_help,
    { buffer = buffer, desc = 'Signature help' }
  )
  vim.keymap.set('n', '<Leader>cr', function()
    require('inc_rename')
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true, buffer = buffer, desc = 'Rename' })
  vim.keymap.set({ 'n', 'x' }, '<Leader>ca', function()
    vim.lsp.buf.code_action({ apply = true })
  end, { buffer = buffer, desc = 'Code action' })
  vim.keymap.set('n', '<Leader>cl', vim.lsp.codelens.run, { buffer = buffer, desc = 'Codelens' })
  vim.keymap.set({ 'n', 'x' }, '<M-f>', format, { buffer = buffer, desc = 'Format' })

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
