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
    branch = { '󰘬', '' },
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

M.icons = vim.iter(icons):fold(vim.defaulttable(), function(acc, k1, v1)
  return vim.iter(v1):fold(nil, function(_, k2, v2)
    if type(v2) == 'table' then
      acc[k1][k2] = vim.g.nerd and v2[1] or v2[2]
    else
      acc[k1][k2] = vim.g.nerd and v2 or k2
    end
    return acc
  end)
end)

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
