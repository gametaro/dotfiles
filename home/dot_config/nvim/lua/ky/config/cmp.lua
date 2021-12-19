local cmp = require 'cmp'
local compare = require 'cmp.config.compare'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'

MAX_ITEM_COUNT = 5

-- local t = function(str)
--   return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

-- local feedkey = function(key, mode)
--   vim.api.nvim_feedkeys(t(key), mode or '', true)
-- end

local tab = function(fallback)
  if luasnip.jumpable() then
    luasnip.jump(1)
  elseif cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end

local s_tab = function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  elseif cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end

local compare_fuzzy_buffer = function(entry1, entry2)
  return (entry1.source.name == 'fuzzy_buffer' and entry2.source.name == 'fuzzy_buffer')
      and (entry1.completion_item.data.score > entry2.completion_item.data.score)
    or nil
end

local compare_under_comparator = function(entry1, entry2)
  local _, entry1_under = entry1.completion_item.label:find '^_+'
  local _, entry2_under = entry2.completion_item.label:find '^_+'

  return (entry1_under or 0) < (entry2_under or 0)
end

cmp.setup {
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare_fuzzy_buffer,
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
    ['<Tab>'] = cmp.mapping(tab, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(s_tab, { 'i', 's' }),
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
    border = 'single',
  },
  formatting = {
    deprecated = true,
    format = lspkind.cmp_format { with_text = true },
  },

  sources = cmp.config.sources({
    -- { name = 'buffer' },
    { name = 'luasnip', max_item_count = MAX_ITEM_COUNT },
    { name = 'nvim_lsp', max_item_count = MAX_ITEM_COUNT },
    { name = 'nvim_lua', max_item_count = MAX_ITEM_COUNT },
    -- { name = 'path' },=
    { name = 'fuzzy_path', max_item_count = MAX_ITEM_COUNT },
    { name = 'emoji', max_item_count = MAX_ITEM_COUNT },
    { name = 'cmp_git', max_item_count = MAX_ITEM_COUNT },
  }, {
    {
      name = 'fuzzy_buffer',
      max_item_count = MAX_ITEM_COUNT,
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
      name = 'fuzzy_buffer',
      max_item_count = MAX_ITEM_COUNT,
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
    { name = 'fuzzy_path', max_item_count = MAX_ITEM_COUNT },
  }, {
    { name = 'cmdline', max_item_count = MAX_ITEM_COUNT },
  }),
})
