local cmp = require('cmp')
local mapping = cmp.mapping
local compare = require('cmp.config.compare')

---@see https://github.com/lukas-reineke/cmp-under-comparator
local compare_under_comparator = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find('^_+')
  local _, entry2_under = entry2.completion_item.label:find('^_+')

  return (entry1_under or 0) < (entry2_under or 0)
end

local kind_icons = {
  Text = '',
  Method = '',
  Function = '',
  Constructor = '',
  Field = '',
  Variable = '',
  Class = 'ﴯ',
  Interface = '',
  Module = '',
  Property = 'ﰠ',
  Unit = '',
  Value = '',
  Enum = '',
  Keyword = '',
  Snippet = '',
  Color = '',
  File = '',
  Reference = '',
  Folder = '',
  EnumMember = '',
  Constant = '',
  Struct = '',
  Event = '',
  Operator = '',
  TypeParameter = '',
}

---@type cmp.ConfigSchema
local config = {
  completion = {
    keyword_pattern = [[\k\+]],
  },
  confirmation = {
    default_behavior = 'replace',
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare_under_comparator,
      -- compare.kind,
      compare.sort_text,
      -- compare.length,
      compare.order,
    },
  },
  experimental = {
    ghost_text = true,
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = mapping(
      mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      { 'i', 'c' }
    ),
    ['<C-n>'] = mapping(
      mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      { 'i', 'c' }
    ),
    ['<C-f>'] = mapping(mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-b>'] = mapping(mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-Space>'] = mapping(mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = mapping {
      i = mapping.abort(),
      c = mapping.close(),
    },
    ['<CR>'] = mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
    ['<C-y>'] = mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    ['<Tab>'] = mapping(function(fallback)
      if cmp.visible() then
        return cmp.complete_common_string()
      end
      fallback()
    end, { 'i', 'c' }),
  },
  documentation = {
    border = require('ky.theme').border,
  },
  formatting = {
    deprecated = true,
    fields = { 'kind', 'abbr' },
    format = function(_, vim_item)
      vim_item.kind = kind_icons[vim_item.kind] or ''

      -- vim_item.menu = ({
      --   path = '[Path]',
      --   buffer = '[Buf]',
      --   -- fuzzy_path = '[Path]',
      --   -- fuzzy_buffer = '[Buffer]',
      --   nvim_lsp = '[LSP]',
      --   luasnip = '[Snip]',
      --   nvim_lua = '[Lua]',
      --   -- emoji = '[Emoji]',
      --   cmp_git = '[Git]',
      --   cmdline = '[Cmd]',
      --   nvim_lsp_document_symbol = '[Symbol]',
      -- })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
  }, {
    {
      name = 'buffer',
      ---@type cmp_buffer.Options
      options = {
        keyword_pattern = [[\k\+]],
        get_bufnrs = function()
          local bufs = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
            if
              buftype ~= 'help'
              and buftype ~= 'nofile'
              and buftype ~= 'prompt'
              and buftype ~= 'quickfix'
              and buftype ~= 'terminal'
            then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
      },
    },
  }),
}

---@type cmp.ConfigSchema
local cmd_config = {
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
  sources = cmp.config.sources({
    {
      ---@type cmp_buffer.Options
      name = 'buffer',
      options = {
        keyword_pattern = [[\k\+]],
        get_bufnrs = function()
          return { vim.api.nvim_get_current_buf() }
        end,
      },
    },
  }, {
    { name = 'nvim_lsp_document_symbol' },
  }),
}

cmp.setup(config)
cmp.setup.cmdline('/', cmd_config)
cmp.setup.cmdline('?', cmd_config)
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
cmp.setup.filetype({ 'gitcommit', 'NeogitCommitMessage' }, {
  sources = {
    { name = 'luasnip' },
    { name = 'cmp_git' },
  },
})
