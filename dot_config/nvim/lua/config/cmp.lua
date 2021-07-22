local cmp = require 'cmp'
local luasnip = require 'luasnip'

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(t(key), mode or '', true)
end

local function tab()
  if luasnip.jumpable() then
    luasnip.jump(1)
  else
    feedkey '<Plug>(Tabout)'
  end
end

local function s_tab()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    feedkey '<Plug>(TaboutBack)'
  end
end

cmp.setup {
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
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  documentation = {
    border = 'rounded',
  },
  formatting = {
    deprecated = true,
    format = require('lspkind').cmp_format { with_text = false },
  },
  sources = {
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'emoji' },
  },
}
