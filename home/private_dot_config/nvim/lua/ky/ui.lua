local M = {}

local icons = {
  diagnostic = {
    error = { '', 'E' },
    warn = { '', 'W' },
    hint = { '', 'H' },
    info = { '', 'I' },
  },
  git = {
    add = { '', '+' },
    change = { '', '~' },
    remove = { '', '-' },
    ignore = { '', '??' },
    rename = { '', '->' },
    branch = { '󰘬', '*' },
    ahead = { '⇡', '⇡' },
    behind = { '⇣', '⇣' },
  },
  vscode_kind = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = '',
    Interface = '',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
  },
  kind = {
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
  },
  chevron = {
    down = { '', '˅' },
    right = { '', '>' },
    left = { '', '<' },
    up = { '', '˄' },
  },
}

if not vim.g.nerd then
  for k, v in pairs(icons) do
    for _k, _v in pairs(v) do
      if not icons[k] then
        icons[k] = v
      end
      icons[k][_k] = _v[2] or ' '
    end
  end
end

M.icons = icons

M.border = {
  none = 'none',
  single = 'single',
  double = 'double',
  rounded = 'rounded',
  solid = 'solid',
  shadow = 'shadow',
  emoji = {
    { '🭽', 'FloatBorder' },
    { '▔', 'FloatBorder' },
    { '🭾', 'FloatBorder' },
    { '▕', 'FloatBorder' },
    { '🭿', 'FloatBorder' },
    { '▁', 'FloatBorder' },
    { '🭼', 'FloatBorder' },
    { '▏', 'FloatBorder' },
  },
}

return M
