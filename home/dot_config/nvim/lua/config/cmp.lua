local cmp = require 'cmp'
local compare = require 'cmp.config.compare'
local luasnip = require 'luasnip'

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(t(key), mode or '', true)
end

local function tab(fallback)
  if luasnip.jumpable() then
    luasnip.jump(1)
  elseif cmp.visible() then
    cmp.select_next_item()
  elseif vim.api.nvim_get_mode().mode == 'c' then
    fallback()
  else
    feedkey '<Plug>(Tabout)'
  end
end

local function s_tab(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  elseif cmp.visible() then
    cmp.select_prev_item()
  elseif vim.api.nvim_get_mode().mode == 'c' then
    fallback()
  else
    feedkey '<Plug>(TaboutBack)'
  end
end

cmp.setup {
  sorting = {
    priority_weight = 2,
    comparators = {
      require 'cmp_fuzzy_buffer.compare',
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
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
    border = 'rounded',
  },
  formatting = {
    deprecated = true,
    format = require('lspkind').cmp_format { with_text = false },
  },
  sources = cmp.config.sources {
    -- { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    -- { name = 'path' },
    { name = 'emoji' },
    {
      name = 'fuzzy_buffer',
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
    { name = 'fuzzy_path' },
  },
}

local config = {
  sources = cmp.config.sources({
    {
      name = 'fuzzy_buffer',
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
    { name = 'fuzzy_path' },
  }, {
    { name = 'cmdline' },
  }),
})
