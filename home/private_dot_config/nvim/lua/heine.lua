local hsluv = require('ky.hsluv')

local M = {}

---@class Config
---@field compile_path string
---@field debug boolean
---@field hue_base integer
---@field non_current boolean
---@field transparent boolean

---|attr-list|
---@class Highlight
---@field fg? string
---@field bg? string
---@field sp? string
---@field blend? integer
---@field bold? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field italic? boolean
---@field reverse? boolean
---@field nocombine? boolean
---@field link? string
---@field default? boolean

---@type Config
M.config = {
  compile_path = vim.fs.normalize(vim.fn.stdpath('cache') .. '/heine.lua'),
  debug = true,
  hue_base = 220,
  non_current = true,
  transparent = false,
}

---@param value integer
---@param min integer
---@param max integer
local function clamp(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  end
  return value
end

---@param hex string
---@param v integer
---@return string
function M.saturate(hex, v)
  local h, s, l = unpack(hsluv.hex_to_hsluv(hex))
  return hsluv.hsluv_to_hex({ h, clamp(s + v, -100, 100), l })
end

---@param hex string
---@param v integer
---@return string
function M.lighten(hex, v)
  local h, s, l = unpack(hsluv.hex_to_hsluv(hex))
  return hsluv.hsluv_to_hex({ h, s, clamp(l + v, -100, 100) })
end

---@param hex string
---@param s integer
---@param l integer
---@return string
function M.saturate_lighten(hex, s, l)
  return M.lighten(M.saturate(hex, s), l)
end

---@param c1 string
---@param c2 string
---@param f number
---@return string
function M.blend(c1, c2, f)
  local r1, g1, b1 = unpack(hsluv.hex_to_rgb(c1))
  local r2, g2, b2 = unpack(hsluv.hex_to_rgb(c2))
  return hsluv.rgb_to_hex({ (r2 - r1) * f + r1, (g2 - g1) * f + g1, (b2 - b1) * f + b1 })
end

---@param highlight Highlight
---@return Highlight
function M.transparent(highlight)
  return vim.tbl_extend(
    'force',
    highlight,
    { bg = M.config.transparent and 'NONE' or highlight.bg }
  )
end

---@type table<string, string>
M.palette = {
  red = hsluv.hsluv_to_hex({ 0, 55, 70 }),
  orange = hsluv.hsluv_to_hex({ 20, 51, 68 }),
  green = hsluv.hsluv_to_hex({ 90, 33, 70 }),
  lgreen = hsluv.hsluv_to_hex({ 140, 34, 68 }),
  cyan = hsluv.hsluv_to_hex({ 180, 38, 67 }),
  blue = hsluv.hsluv_to_hex({ 220, 41, 68 }),
  magenta = hsluv.hsluv_to_hex({ 260, 38, 70 }),
}

-- Normal
local bg1 = hsluv.hsluv_to_hex({ M.config.hue_base, 25, 12 })
-- Statusline
local bg2 = M.saturate_lighten(bg1, 0, -4)
-- Pmenu
local bg3 = M.saturate_lighten(bg1, 0, 6)
-- CursorLine
local bg4 = M.saturate_lighten(bg1, 25, 4)
-- MatchParen
local bg5 = M.saturate_lighten(bg1, 8, 13)
-- PmenuSel
local bg6 = M.saturate_lighten(bg1, 5, 17)

-- Normal
local fg1 = hsluv.hsluv_to_hex({ M.config.hue_base, 10, 75 })
-- Statusline
local fg2 = M.saturate_lighten(fg1, 2, -6)
-- PmenuSel
local fg3 = M.saturate_lighten(fg1, 10, 13)
-- Comment
local fg4 = M.saturate_lighten(fg1, 8, -25)
-- NonText, WhiteSpace, SpecialKey
local fg5 = M.saturate_lighten(fg1, 18, -45)

---@type table<string, Highlight>
M.tint = {
  red = { bg = M.saturate(M.blend(M.palette.red, bg1, 0.8), 15) },
  orange = {
    bg = M.saturate(M.blend(M.palette.orange, bg1, 0.8), 15),
    fg = M.blend(M.palette.orange, fg1, 0.9),
  },
  green = { bg = M.saturate(M.blend(M.palette.green, bg1, 0.8), 15) },
  lgreen = { bg = M.saturate(M.blend(M.palette.lgreen, bg1, 0.8), 15) },
  cyan = { bg = M.saturate(M.blend(M.palette.cyan, bg1, 0.8), 15) },
  blue = { bg = M.saturate(M.blend(M.palette.blue, bg1, 0.8), 15) },
  magenta = { bg = M.saturate(M.blend(M.palette.magenta, bg1, 0.8), 15) },
}

---|terminal-config|
---@type table<string, string>
M.terminal = {
  terminal_color_0 = bg1,
  terminal_color_8 = fg5,

  terminal_color_7 = fg1,
  terminal_color_15 = fg1,

  terminal_color_1 = M.palette.red,
  terminal_color_9 = M.palette.red,

  terminal_color_2 = M.palette.green,
  terminal_color_10 = M.palette.green,

  terminal_color_3 = M.palette.orange,
  terminal_color_11 = M.palette.orange,

  terminal_color_4 = M.palette.blue,
  terminal_color_12 = M.palette.blue,

  terminal_color_5 = M.palette.magenta,
  terminal_color_13 = M.palette.magenta,

  terminal_color_6 = M.palette.cyan,
  terminal_color_14 = M.palette.cyan,
}

M.colors = {
  fg1 = fg1,
  fg2 = fg2,
  fg3 = fg3,
  fg4 = fg4,
  bg1 = bg1,
  bg2 = bg2,
  bg3 = bg3,
  bg4 = bg4,
  bg5 = bg5,
  bg6 = bg6,
}

---@type table<string, Highlight>
M.groups = {
  ---|highlight-groups|
  ColorColumn = { fg = fg1, bg = bg1 },
  Conceal = { link = 'Comment' },
  CurSearch = { link = 'IncSearch' },
  Cursor = { fg = bg1, bg = fg1 },
  lCursor = { link = 'Cursor' },
  CursorIM = { link = 'Cursor' },
  CursorColumn = { link = 'CursorLine' },
  CursorLine = { bg = bg4 },
  Directory = { fg = M.palette.blue },
  DiffAdd = { bg = M.tint.blue.bg },
  DiffChange = { bg = M.tint.blue.bg },
  DiffDelete = { bg = M.tint.red.bg },
  DiffText = { bg = M.lighten(M.tint.blue.bg, 10) },
  EndOfBuffer = { link = 'NonText' },
  -- TermCursor = {},
  -- TermCursorNC = {},
  ErrorMsg = { fg = M.palette.red },
  WinSeparator = M.transparent({ fg = M.palette.blue, bg = bg1 }),
  Folded = { fg = M.saturate_lighten(bg4, 5, 35), bg = M.tint.blue.bg },
  FoldColumn = { fg = M.saturate_lighten(bg4, 5, 35), bg = bg1 },
  SignColumn = { fg = fg1 },
  SignColumnSB = { link = 'SignColumn' },
  IncSearch = { fg = fg3, bg = M.lighten(M.tint.orange.bg, 12) },
  Substitute = { link = 'IncSearch' },
  LineNr = { fg = fg5 },
  LineNrAbove = { link = 'LineNr' },
  LineNrBelow = { link = 'LineNr' },
  CursorLineNr = {},
  CursorLineSign = { link = 'SignColumn' },
  CursorLineFold = { link = 'FoldColumn' },
  MatchParen = { bg = bg5 },
  Modemsg = { fg = fg5 },
  MsgArea = { link = 'Pmenu' },
  MsgSeparator = { link = 'WinSeparator' },
  Moremsg = { fg = M.palette.green },
  NonText = { fg = fg5 },
  Normal = M.transparent({ fg = fg1, bg = bg1 }),
  NormalFloat = { link = 'Pmenu' },
  NormalNC = M.transparent({ bg = M.config.non_current and M.lighten(bg1, -4) or bg1 }),
  FloatTitle = M.transparent({ fg = M.palette.blue, bg = bg3, bold = true }),
  FloatBorder = M.transparent({ fg = M.palette.blue, bg = bg3 }),
  Pmenu = M.transparent({ fg = fg1, bg = bg3 }),
  PmenuSel = { bg = bg6 },
  PmenuSbar = { bg = bg3 },
  PmenuThumb = { bg = bg6 },
  Question = { link = 'Moremsg' },
  QuickFixLine = { bg = bg6 },
  Search = { bg = M.lighten(M.tint.orange.bg, 3) },
  SpecialKey = { fg = fg5 },
  SpellBad = { sp = M.palette.red, undercurl = true },
  SpellCap = { sp = M.palette.orange, undercurl = true },
  SpellLocal = { sp = M.palette.green, undercurl = true },
  SpellRare = { sp = M.palette.lgreen, undercurl = true },
  Statusline = M.transparent({ fg = fg2, bg = bg2 }),
  StatuslineNC = { fg = M.lighten(fg1, -10), bg = M.lighten(bg2, -3) },
  Tabline = M.transparent({ fg = fg2, bg = bg2 }),
  TablineFill = M.transparent({ bg = bg2 }),
  TablineSel = { link = 'Winbar' },
  Title = { fg = M.palette.blue, bold = true },
  Visual = { bg = M.tint.lgreen.bg },
  VisualNOS = { bg = M.blend(M.palette.lgreen, bg1, 0.5) },
  WarningMsg = { fg = M.palette.orange },
  WhiteSpace = { fg = fg5 },
  WildMenu = { fg = fg2, bg = M.lighten(bg2, 5) },
  Winbar = M.transparent({ fg = fg3, bg = bg1 }),
  WinbarNC = { link = 'NormalNC' },
  -- Menu = {},
  Scrollbar = { fg = fg2, bg = bg2 },
  -- Tooltip = {},

  ---|diagnostic-highlights|
  DiagnosticError = { fg = M.palette.red },
  DiagnosticWarn = { fg = M.palette.orange },
  DiagnosticInfo = { fg = M.palette.green },
  DiagnosticHint = { fg = M.palette.lgreen },
  DiagnosticOk = { fg = M.palette.cyan },

  DiagnosticVirtualTextError = { fg = M.palette.red, bg = M.tint.red.bg },
  DiagnosticVirtualTextWarn = { fg = M.palette.orange, bg = M.tint.orange.bg },
  DiagnosticVirtualTextInfo = { fg = M.palette.green, bg = M.tint.blue.bg },
  DiagnosticVirtualTextHint = { fg = M.palette.lgreen, bg = M.tint.green.bg },
  DiagnosticVirtualTextOk = { fg = M.palette.cyan, bg = M.tint.lgreen.bg },

  DiagnosticUnderlineError = { sp = M.palette.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = M.palette.orange, undercurl = true },
  DiagnosticUnderlineInfo = { sp = M.palette.green, undercurl = true },
  DiagnosticUnderlineHint = { sp = M.palette.lgreen, undercurl = true },
  DiagnosticUnderlineOk = { sp = M.palette.cyan, undercurl = true },

  DiagnosticFloatingError = { link = 'DiagnosticError' },
  DiagnosticFloatingWarn = { link = 'DiagnosticWarn' },
  DiagnosticFloatingInfo = { link = 'DiagnosticInfo' },
  DiagnosticFloatingHint = { link = 'DiagnosticHint' },
  DiagnosticFloatingOk = { link = 'DiagnosticOk' },

  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },
  DiagnosticSignOk = { link = 'DiagnosticOk' },

  DiagnosticDeprecated = { fg = fg4, strikethrough = true },

  ---|group-name|
  Comment = { fg = fg4 },
  Constant = { fg = M.palette.orange },
  String = { fg = M.palette.lgreen },
  Character = { link = 'String' },
  Number = { link = 'Constant' },
  Boolean = { link = 'Constant' },
  Float = { link = 'Number' },

  Identifier = { fg = M.palette.cyan },
  Function = { fg = M.palette.blue },

  Statement = { fg = M.palette.magenta },
  Conditional = { link = 'Statement' },
  Repeat = { link = 'Statement' },
  Label = { link = 'Statement' },
  Operator = { link = 'Statement' },
  Keyword = { link = 'Statement' },
  Exception = { link = 'Statement' },

  PreProc = { fg = M.palette.magenta },
  Include = { link = 'PreProc' },
  Define = { link = 'PreProc' },
  Macro = { link = 'PreProc' },
  PreCondit = { link = 'PreProc' },

  Type = { fg = M.palette.green },
  StorageClass = { link = 'Type' },
  Structure = { link = 'Type' },
  Typedef = { link = 'Type' },

  Special = { fg = M.palette.green },
  SpecialChar = { link = 'Special' },
  Tag = { link = 'Special' },
  Delimiter = { link = 'Special' },
  SpecialComment = { link = 'Special' },
  Debug = { link = 'Special' },

  Underlined = { underline = true },
  Bold = { bold = true },
  Italic = { italic = true },

  -- Ignore = {},

  Error = { fg = M.palette.red },

  Todo = { fg = M.tint.orange.fg, bg = M.tint.orange.bg },

  diffAdded = { link = 'DiffAdd' },
  diffRemoved = { link = 'DiffDelete' },
  diffChanged = { link = 'DiffChange' },
  diffFile = { link = 'Directory' },
  diffOldFile = { fg = M.palette.red },
  diffNewFile = { fg = M.palette.green },

  ---|health|
  healthSuccess = { link = 'DiagnosticOk' },
  healthWarning = { link = 'DiagnosticWarn' },
  healthError = { link = 'DiagnosticError' },
  helpCommand = { link = 'MatchParen' },

  ---|lsp-highlight|
  LspReferenceRead = { bg = bg5 },
  LspReferenceText = { bg = bg5 },
  LspReferenceWrite = { bg = bg5 },
  LspCodeLens = { fg = fg5 },
  -- LspCodeLensSeparator = {},
  -- LspSignatureActiveParameter = {},
  -- LspDiagnosticsDefaultInformation = {},

  ---|treesitter-highlight-groups|
  ['@annotation'] = { link = 'PreProc' },
  ['@attribute'] = { link = 'PreProc' },
  ['@boolean'] = { link = 'Boolean' },
  ['@character'] = { link = 'Character' },
  ['@character.special'] = { link = 'SpecialChar' },
  ['@comment'] = { link = 'Comment' },
  ['@conditional'] = { link = 'Conditional' },
  ['@constant'] = { link = 'Constant' },
  ['@constant.builtin'] = { link = 'Special' },
  ['@constant.macro'] = { link = 'Define' },
  ['@constructor'] = { link = 'Special' },
  ['@debug'] = { link = 'Debug' },
  ['@define'] = { link = 'Define' },
  -- ['@error'] = {},
  ['@exception'] = { link = 'Exception' },
  ['@field'] = { link = 'Identifier' },
  ['@float'] = { link = 'Float' },
  ['@function'] = { link = 'Function' },
  ['@function.builtin'] = { link = 'Special' },
  ['@function.call'] = { link = '@function' },
  ['@function.macro'] = { link = 'Macro' },
  ['@include'] = { link = 'Include' },
  ['@keyword'] = { link = 'Keyword' },
  ['@keyword.function'] = { link = '@keyword' },
  ['@keyword.coroutine'] = { link = '@keyword' },
  ['@keyword.operator'] = { link = '@operator' },
  ['@keyword.return'] = { link = '@keyword' },
  ['@label'] = { link = 'Label' },
  ['@method'] = { link = 'Function' },
  ['@method.call'] = { link = '@method' },
  ['@namespace'] = { link = 'Include' },
  ['@none'] = {},
  ['@number'] = { link = 'Number' },
  ['@operator'] = { link = 'Operator' },
  ['@parameter'] = { link = 'Identifier' },
  ['@parameter.reference'] = { link = '@parameter' },
  ['@preproc'] = { link = 'PreProc' },
  ['@property'] = { link = 'Identifier' },
  ['@punctuation'] = { link = 'Delimiter' },
  ['@punctuation.bracket'] = { link = 'Delimiter' },
  ['@punctuation.delimiter'] = { link = 'Delimiter' },
  ['@punctuation.special'] = { link = 'Delimiter' },
  ['@repeat'] = { link = 'Repeat' },
  ['@storageclass'] = { link = 'StorageClass' },
  ['@string'] = { link = 'String' },
  ['@string.escape'] = { link = 'SpecialChar' },
  ['@string.regex'] = { link = 'SpecialChar' },
  ['@string.special'] = { link = 'SpecialChar' },
  ['@symbol'] = { link = 'Identifier' },
  ['@tag'] = { link = 'Label' },
  ['@tag.attribute'] = { link = '@property' },
  ['@tag.delimiter'] = { link = 'Delimiter' },
  ['@text'] = { link = '@none' },
  ['@text.danger'] = { link = 'WarningMsg' },
  ['@text.diff.add'] = { link = 'DiffAdd' },
  ['@text.diff.delete'] = { link = 'DiffDelete' },
  ['@text.emphasis'] = { italic = true },
  ['@text.environment'] = { link = 'Macro' },
  ['@text.environment.name'] = { link = 'Type' },
  ['@text.literal'] = { link = 'String' },
  ['@text.math'] = { link = 'Special' },
  ['@text.note'] = { link = 'SpecialComment' },
  ['@text.reference'] = { link = 'Identifier' },
  ['@text.strike'] = { strikethrough = true },
  ['@text.strong'] = { bold = true },
  ['@text.title'] = { link = 'Title' },
  ['@text.todo'] = { link = 'Todo' },
  ['@text.todo.checked'] = { link = 'DiagnosticOk' },
  ['@text.todo.unchecked'] = { link = 'DiagnosticWarn' },
  ['@text.underline'] = { underline = true },
  ['@text.uri'] = { link = 'Underlined' },
  ['@text.warning'] = { link = 'WarningMsg' },
  ['@type'] = { link = 'Type' },
  ['@type.bulitin'] = { link = 'Typedef' },
  ['@type.definition'] = { link = 'Typedef' },
  ['@type.qualifier'] = { link = 'Type' },
  ['@variable'] = { link = '@none' },
  ['@variable.builtin'] = { link = 'Special' },

  -- ['@text.literal.markdown_inline'] = { link = 'MatchParen' },
  -- ['@text.literal.markdown'] = { link = 'Normal' },

  ---|lsp-semantic-highlight|
  ['@lsp.mod.defaultLibrary'] = { link = '@function.builtin' },
  ['@lsp.mod.documentation'] = { fg = M.palette.blue },
  ['@lsp.type.comment'] = { link = '@comment' },
  ['@lsp.type.enum'] = { link = '@type' },
  ['@lsp.type.interface'] = { link = 'Identifier' },
  ['@lsp.type.keyword'] = { link = '@keyword' },
  ['@lsp.type.namespace'] = { link = '@namespace' },
  ['@lsp.type.parameter'] = { link = '@parameter' },
  ['@lsp.type.property'] = { link = '@property' },
  ['@lsp.type.variable'] = { link = '@variable' },

  -- plugins
  ---|telescope.nvim|
  TelescopeNormal = { link = 'Pmenu' },
  -- TelescopePromptNormal = { link = 'Pmenu' },
  TelescopeBorder = { link = 'FloatBorder' },
  -- TelescopeMatching = { link = 'Special' },
  TelescopeSelection = { link = 'PmenuSel' },

  ---|nvim-notify|
  NotifyERRORBorder = { fg = M.tint.red.bg, bg = bg3 },
  NotifyWARNBorder = { fg = M.tint.orange.bg, bg = bg3 },
  NotifyINFOBorder = { fg = M.tint.blue.bg, bg = bg3 },
  NotifyDEBUGBorder = { fg = M.tint.green.bg, bg = bg3 },
  NotifyTRACEBorder = { fg = fg5, bg = bg3 },

  NotifyERRORTitle = { fg = M.palette.red },
  NotifyWARNTitle = { fg = M.palette.orange },
  NotifyINFOTitle = { fg = M.palette.blue },
  NotifyDEBUGTitle = { fg = M.palette.green },
  NotifyTRACETitle = { fg = fg5 },

  NotifyERRORIcon = { link = 'NotifyERRORTitle' },
  NotifyWARNIcon = { link = 'NotifyWARNTitle' },
  NotifyINFOIcon = { link = 'NotifyINFOTitle' },
  NotifyDEBUGIcon = { link = 'NotifyDEBUGTitle' },
  NotifyTRACEIcon = { link = 'NotifyTRACETitle' },

  NotifyERRORBody = { bg = bg3 },
  NotifyWARNBody = { bg = bg3 },
  NotifyINFOBody = { bg = bg3 },
  NotifyDEBUGBody = { bg = bg3 },
  NotifyTRACEBody = { bg = bg3 },

  ---|cmp-highlight|
  CmpItemAbbr = { fg = fg1, bg = 'NONE' },
  CmpItemAbbrDeprecated = { link = 'DiagnosticDeprecated' },
  CmpItemAbbrMatch = { link = 'Special' },
  CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
  CmpItemMenu = { fg = fg1 },

  CmpItemKindKeyword = { link = '@keyword' },

  CmpItemKindVariable = { link = '@variable' },
  CmpItemKindConstant = { link = '@constant' },
  CmpItemKindReference = { link = '@text.reference' },
  CmpItemKindValue = { link = '@keyword' },

  CmpItemKindFunction = { link = '@function' },
  CmpItemKindMethod = { link = '@method' },
  CmpItemKindConstructor = { link = '@constructor' },

  CmpItemKindInterface = { link = '@constant' },
  CmpItemKindEvent = { link = '@constant' },
  CmpItemKindEnum = { link = '@constant' },
  CmpItemKindUnit = { link = '@constant' },

  CmpItemKindClass = { link = '@type' },
  CmpItemKindStruct = { link = '@type' },

  CmpItemKindModule = { link = '@namespace' },

  CmpItemKindProperty = { link = '@property' },
  CmpItemKindField = { link = '@field' },
  CmpItemKindTypeParameter = { link = '@field' },
  CmpItemKindEnumMember = { link = '@field' },
  CmpItemKindOperator = { link = '@operator' },
  CmpItemKindSnippet = { link = '@type' },

  ---|nvim-bqf|
  BqfPreviewBorder = { link = 'FloatBorder' },
  -- BqfPreviewRange = { link = 'Search' },

  ---|pounce|
  PounceAccept = { bg = M.blend(M.palette.blue, bg1, 0.5), bold = true },
  PounceAcceptBest = { reverse = true, bold = true },
  PounceMatch = { link = 'Search' },
  PounceUnmatched = { link = 'Comment' },
  PounceGap = { link = 'Comment' },

  -- ts-rainbow
  rainbowcol1 = { fg = M.palette.magenta },
  rainbowcol2 = { fg = M.palette.blue },
  rainbowcol3 = { fg = M.palette.cyan },
  rainbowcol4 = { fg = M.palette.lgreen },
  rainbowcol5 = { fg = M.palette.green },
  rainbowcol6 = { fg = M.palette.orange },
  rainbowcol7 = { fg = M.palette.red },

  ---|gitsigns-highlight-groups|
  GitSignsAdd = { fg = M.palette.blue },
  GitSignsChange = { fg = M.palette.orange },
  GitSignsDelete = { fg = M.palette.red },

  -- GitSignsAddLn = {},
  -- GitSignsChangeLn = {},
  -- GitSignsDeleteLn = {},

  GitSignsAddInline = { bg = M.lighten(M.tint.blue.bg, 10) },
  GitSignsChangeInline = { bg = M.lighten(M.tint.blue.bg, 10) },
  GitSignsDeleteInline = { bg = M.lighten(M.tint.red.bg, 10) },

  GitSignsAddNr = { bg = M.tint.blue.bg },
  GitSignsChangeNr = { bg = M.tint.orange.bg },
  GitSignsDeleteNr = { bg = M.tint.red.bg },

  -- GitSignsAddVertInline = {},
  -- GitSignsChangeVertInline = {},
  -- GitSignsDeleteVertInline = {},

  -- GitSignsAddLnVertInline = {},
  -- GitSignsChangeLnVertInline = {},
  -- GitSignsDeleteLnVertInline = {},

  -- GitSignsAddLnVirtLnInLine = {},
  -- GitSignsChangeLnVirtLnInLine = {},
  -- GitSignsDeleteLnVirtLnInLine = {},

  -- GitSignsCurrenLineBlame

  ---|vim-eft|
  EftChar = { fg = M.palette.orange, bold = true },
  EftSubChar = { fg = fg5, bold = true },

  -- marks.nvim
  MarkSignHL = { fg = M.palette.orange },

  ---|illuminate-highlight-groups|
  illuminatedWordText = { link = 'LspReferenceText' },
  illuminatedWordRead = { link = 'LspReferenceRead' },
  illuminatedWordWrite = { link = 'LspReferenceWrite' },

  -- hlargs.nvim
  Hlargs = { fg = M.lighten(M.palette.orange, -6) },

  ---|highlighturl|
  HighlightUrl = { link = 'Underlined' },

  ---|nvim-surround.config.highlight|
  NvimSurroundHighlight = { link = 'IncSearch' },

  ---|noice.nvim-highlight-groups|
  NoiceCmdlinePopup = { link = 'NormalFloat' },
  NoiceConfirm = { link = 'NormalFloat' },
}

function M.load()
  vim.g.colors_name = 'heine'

  if vim.loop.fs_stat(M.config.compile_path) then
    vim.cmd.source(M.config.compile_path)
    return
  end
  for name, val in pairs(M.groups) do
    vim.api.nvim_set_hl(0, name, val)
  end
  for name, val in pairs(M.terminal) do
    vim.g[name] = val
  end
end

function M.invalidate()
  for k, _ in pairs(package.loaded) do
    if string.match(k, '^heine') then
      package.loaded[k] = nil
    end
  end
end

---@param t table
local function inspect(t)
  local list = {}
  for k, v in pairs(t) do
    local quote = type(v) == 'string' and [[']] or ''
    list[#list + 1] = string.format([[%s = %s%s%s]], k, quote, v, quote)
  end
  table.sort(list)
  return string.format([[{ %s }]], table.concat(list, ', '))
end

function M.compile()
  local lines = {}
  for name, val in pairs(M.groups) do
    lines[#lines + 1] = string.format([[vim.api.nvim_set_hl(0, '%s', %s)]], name, inspect(val))
  end
  for name, val in pairs(M.terminal) do
    lines[#lines + 1] = string.format([[vim.g.%s = '%s']], name, val)
  end
  table.sort(lines)
  local file, msg = io.open(M.config.compile_path, 'w')
  if file then
    file:write(table.concat(lines, '\n') .. '\n')
    file:close()
  end
  if msg then
    vim.notify(msg, vim.log.levels.ERROR, { title = 'heine.nvim' })
  end
end

function M.clean()
  local _, msg = os.remove(M.config.compile_path)
  if msg then
    vim.notify(msg, vim.log.levels.ERROR, { title = 'heine.nvim' })
  end
end

function M.reload()
  M.invalidate()
  vim.cmd.colorscheme('heine')
  vim.cmd.doautoall('ColorScheme')
end

vim.api.nvim_create_user_command('HeineCompile', M.compile, {})
vim.api.nvim_create_user_command('HeineClean', M.clean, {})
vim.api.nvim_create_user_command('HeineReload', M.reload, {})

if M.config.debug then
  vim.api.nvim_create_user_command('HeineDebugEnable', function()
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = vim.api.nvim_create_augroup('HeineDebug', {}),
      pattern = 'heine.lua',
      callback = function()
        vim.defer_fn(M.reload, 150)
      end,
    })
  end, {})

  vim.api.nvim_create_user_command('HeineDebugDisable', function()
    vim.api.nvim_del_augroup_by_name('HeineDebug')
  end, {})

  vim.cmd.HeineDebugEnable()
end

return M
