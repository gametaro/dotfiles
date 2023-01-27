local M = {}

M.icons = {
  diagnostic = {
    error = '',
    warn = '',
    hint = '',
    info = '',
  },
  git = {
    add = '',
    change = '',
    remove = '',
    ignore = '',
    rename = '',
    branch = '󰘬',
    ahead = '⇡',
    behind = '⇣',
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
    down = '',
    right = '',
    left = '',
    up = '',
  },
}

M.border = 'none'

return M
