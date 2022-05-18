local cmp = require('cmp')
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

---@type cmp.WindowConfig
local window = {
  border = require('ky.ui').border,
  winhighlight = table.concat({
    'Normal:NormalFloat',
    'FloatBorder:FloatBorder',
    'CursorLine:Visual',
    'Search:None',
  }, ','),
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
  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
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
          return vim.tbl_filter(function(buf)
            local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
            return vim.api.nvim_buf_is_loaded(buf)
              and not vim.tbl_contains({
                'help',
                'nofile',
                'prompt',
                'quickfix',
                'terminal',
              }, buftype)
          end, vim.api.nvim_list_bufs())
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
cmp.setup.cmdline('/', cmdline_config)
cmp.setup.cmdline('?', cmdline_config)
cmp.setup.cmdline(':', {
  mapping = cmdline_mapping,
  view = {
    entries = { name = 'wildmenu', separator = '|' },
  },
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
