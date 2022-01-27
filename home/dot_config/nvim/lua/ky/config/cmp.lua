local cmp = require 'cmp'
local compare = require 'cmp.config.compare'

-- -- @see https://github.com/tzachar/cmp-fuzzy-buffer#sorting-and-filtering
-- local compare_fuzzy_buffer = function(entry1, entry2)
--   return (entry1.source.name == 'fuzzy_buffer' and entry2.source.name == 'fuzzy_buffer')
--       and (entry1.completion_item.data.score > entry2.completion_item.data.score)
--     or nil
-- end

-- @see https://github.com/lukas-reineke/cmp-under-comparator
local compare_under_comparator = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find '^_+'
  local _, entry2_under = entry2.completion_item.label:find '^_+'

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

cmp.setup {
  sorting = {
    priority_weight = 2,
    comparators = {
      -- compare_fuzzy_buffer,
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare_under_comparator,
      compare.kind,
      compare.sort_text,
      compare.length,
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
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert }, { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert }, { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  documentation = {
    border = 'none',
  },
  formatting = {
    deprecated = true,
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

      vim_item.menu = ({
        path = '[Path]',
        buffer = '[Buf]',
        -- fuzzy_path = '[Path]',
        -- fuzzy_buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        luasnip = '[Snip]',
        nvim_lua = '[Lua]',
        -- emoji = '[Emoji]',
        cmp_git = '[Git]',
        cmdline = '[Cmd]',
        nvim_lsp_document_symbol = '[Symbol]',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    -- { name = 'fuzzy_path' },
    -- { name = 'emoji' },
    { name = 'cmp_git' },
  }, {
    {
      -- name = 'fuzzy_buffer',
      name = 'buffer',
      options = {
        get_bufnrs = function()
          local bufs = {}
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
            if buftype ~= 'nofile' and buftype ~= 'prompt' then
              bufs[#bufs + 1] = buf
            end
          end
          return bufs
        end,
      },
    },
  }),
}

local config = {
  sources = cmp.config.sources({
    {
      -- name = 'fuzzy_buffer',
      name = 'buffer',
      options = {
        get_bufnrs = function()
          return { vim.api.nvim_get_current_buf() }
        end,
      },
    },
  }, {
    { name = 'nvim_lsp_document_symbol' },
  }),
}

cmp.setup.cmdline('/', config)
cmp.setup.cmdline('?', config)
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    -- { name = 'fuzzy_path' },
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
