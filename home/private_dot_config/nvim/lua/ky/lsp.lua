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
}

local capabilities =
  vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), cmp_capabilities)

vim.g.lsp_start = function(config, opts)
  config = config or {}
  local patterns = vim.list_extend(config.root_patterns or {}, { '.git' })
  local root_dir = config.root_dir or require('ky.util').get_root_by_patterns(patterns)
  config = vim.tbl_deep_extend('force', config, {
    capabilities = capabilities,
    root_dir = root_dir,
  })
  vim.lsp.start(config, opts)
end

local function hover()
  if vim.bo.filetype == 'lua' then
    local cword = vim.fn.expand('<cWORD>')
    local subject = string.match(cword, '^|(%S-)|$')
      or string.match(cword, "^'(%S-)'$")
      or string.match(cword, '^`:(%S-)`$')
    if subject then
      vim.cmd.help(subject)
      return
    end
  end

  vim.lsp.buf.hover()
end

local function format()
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return not vim.tbl_contains({ 'sumneko_lua' }, client.name)
    end,
  })
end

---@param client table
---@param buffer integer
local function on_attach(client, buffer)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs function
  ---@param opts? table
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = buffer
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto definition' })
  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
  map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
  map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Goto implementation' })
  -- map('n', 'gt', vim.lsp.buf.type_definition, { desc = 'Goto type definition' })
  map('n', 'K', hover, { desc = 'Hover' })
  map('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
  map('n', '<Leader>cr', function()
    require('inc_rename')
    return ':IncRename ' .. vim.fn.expand('<cword>')
  end, { expr = true, desc = 'Rename' })
  map({ 'n', 'x' }, '<Leader>ca', function()
    vim.lsp.buf.code_action({
      apply = true,
    })
  end, { desc = 'Code action' })
  map('n', '<Leader>cl', vim.lsp.codelens.run, { desc = 'Codelens' })
  map({ 'n', 'x' }, '<M-f>', format, { desc = 'Format' })

  if client.name == 'yaml' then
    client.server_capabilities.documentFormattingProvider = true
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('mine__lsp', {}),
  callback = function(a)
    local client = vim.lsp.get_client_by_id(a.data.client_id)
    on_attach(client, a.buf)
  end,
})
