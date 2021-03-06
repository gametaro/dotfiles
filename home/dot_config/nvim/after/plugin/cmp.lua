local ok = prequire('cmp')
if not ok then return end

local cmp = require('cmp')
local compare = require('cmp.config.compare')

local api = vim.api

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

---@type cmp.WindowConfig
local window = {
  border = require('ky.ui').border,
  winhighlight = table.concat({
    'Normal:NormalFloat',
    'FloatBorder:FloatBorder',
    'CursorLine:PmenuSel',
    'Search:None',
  }, ','),
  col_offset = -3,
  side_padding = 0,
}

---@type cmp.ConfigSchema
local config = {
  completion = {
    keyword_pattern = [[\k\+]],
  },
  confirmation = {
    default_behavior = 'replace',
  },
  window = {
    completion = cmp.config.window.bordered(window),
    documentation = cmp.config.window.bordered(window),
  },
  sorting = {
    priority_weight = 2,
    comparators = {
      compare.offset,
      compare.exact,
      -- compare.scopes,
      compare.score,
      compare.recently_used,
      compare_under_comparator,
      compare.locality,
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
    ['<C-f>'] = { i = cmp.mapping.scroll_docs(4) },
    ['<C-b>'] = { i = cmp.mapping.scroll_docs(-4) },
    ['<C-n>'] = { i = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert } },
    ['<C-p>'] = { i = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert } },
    ['<C-Space>'] = { i = cmp.mapping.complete() },
    ['<C-e>'] = { i = cmp.mapping.abort() },
    ['<CR>'] = { i = cmp.mapping.confirm { select = true, behavior = cmp.SelectBehavior.Replace } },
    ['<C-y>'] = { i = cmp.mapping.confirm { select = true, behavior = cmp.SelectBehavior.Insert } },
  },
  formatting = {
    deprecated = true,
    fields = { 'kind', 'abbr' },
    format = function(_, vim_item)
      vim_item.kind = string.format(' %s ', kind_icons[vim_item.kind]) or '   '
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
      option = {
        keyword_pattern = [[\k\+]],
        get_bufnrs = function()
          return vim.tbl_filter(function(buf)
            local buftype = api.nvim_buf_get_option(buf, 'buftype')
            return api.nvim_buf_is_loaded(buf)
              and not vim.tbl_contains({
                -- 'help',
                'nofile',
                'prompt',
                'quickfix',
                'terminal',
              }, buftype)
          end, api.nvim_list_bufs())
        end,
      },
    },
  }),
}

local cmdline_mapping = cmp.mapping.preset.cmdline {
  ['<C-n>'] = {
    c = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  },
  ['<C-p>'] = {
    c = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  },
}

---@type cmp.ConfigSchema
local cmdline_config = {
  mapping = cmdline_mapping,
  -- view = {
  --   entries = { name = 'wildmenu', separator = '|' },
  -- },
  sources = cmp.config.sources({
    {
      name = 'buffer',
      ---@type cmp_buffer.Options
      option = {
        keyword_pattern = [[\k\+]],
        get_bufnrs = function()
          return { api.nvim_get_current_buf() }
        end,
      },
    },
  }, {
    { name = 'nvim_lsp_document_symbol' },
  }),
}

cmp.setup(config)
cmp.setup.cmdline('/', cmdline_config)
cmp.setup.cmdline('?', cmdline_config)
cmp.setup.cmdline(':', {
  mapping = cmdline_mapping,
  -- view = {
  --   entries = { name = 'wildmenu', separator = '|' },
  -- },
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
cmp.setup.filetype({ 'gitcommit', 'NeogitCommitMessage' }, {
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'git' },
    { name = 'buffer' },
  }, {
    { name = 'spell' },
  }),
})
cmp.setup.filetype({ 'markdown' }, {
  sources = cmp.config.sources {
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'spell' },
    { name = 'emoji' },
    { name = 'buffer' },
  },
})
