local ok = prequire('dial')
if not ok then
  return
end

local augend = require('dial.augend')

local default = {
  augend.integer.alias.decimal,
  augend.integer.alias.hex,
  augend.date.alias['%Y/%m/%d'],
  augend.date.alias['%Y-%m-%d'],
  augend.date.alias['%m/%d'],
  augend.date.alias['%H:%M'],
  augend.constant.alias.bool,
  augend.constant.new {
    elements = { 'TODO', 'WARN', 'NOTE', 'HACK' },
  },
  augend.paren.new {
    patterns = { { "'", "'" }, { '"', '"' }, { '`', '`' } },
    escape_char = [[\]],
  },
}

local with_default = function(group_name)
  group_name = group_name or {}
  for _, v in ipairs(default) do
    table.insert(group_name, v)
  end
  return group_name
end

local lua = {
  augend.paren.alias.lua_str_literal,
  augend.constant.new {
    elements = { 'and', 'or' },
  },
  augend.constant.new {
    elements = { 'pairs', 'ipairs' },
  },
}

local python = {
  augend.constant.new {
    elements = { 'True', 'False' },
  },
}

local markdown = {
  augend.misc.alias.markdown_header,
}

local typescript = {
  augend.constant.new {
    elements = { 'let', 'const' },
  },
  augend.constant.new {
    elements = { '&&', '||', '??' },
  },
  augend.constant.new {
    elements = { 'console.log', 'console.warn', 'console.error' },
  },
}

require('dial.config').augends:register_group {
  default = default,
  lua = with_default(lua),
  python = with_default(python),
  typescript = with_default(typescript),
  markdown = with_default(markdown),
}

vim.keymap.set({ 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)')
vim.keymap.set({ 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)')
vim.keymap.set('x', 'g<C-a>', 'g<Plug>(dial-increment)')
vim.keymap.set('x', 'g<C-x>', 'g<Plug>(dial-decrement)')

local group = vim.api.nvim_create_augroup('DialMapping', { clear = true })
local group_names = { 'lua', 'python', 'typescript', 'markdown' }
for _, group_name in ipairs(group_names) do
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = group_name,
    callback = function()
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = true
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', '<C-a>', require('dial.map').inc_normal(group_name))
      map('x', '<C-a>', require('dial.map').inc_visual(group_name))
      map('n', '<C-x>', require('dial.map').dec_normal(group_name))
      map('x', '<C-x>', require('dial.map').dec_visual(group_name))
      map('x', 'g<C-a>', require('dial.map').inc_gvisual(group_name))
      map('x', 'g<C-x>', require('dial.map').dec_gvisual(group_name))
    end,
  })
end
