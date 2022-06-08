---@diagnostic disable: undefined-field

-- Inspired by
-- iceberg.vim
-- nightfox.nvim
-- catppuccin
-- tokyonight.nvim
-- and more!

local ok, C = prequire('nightfox.lib.color')
if not ok then
  return
end

for k, _ in pairs(package.loaded) do
  if string.match(k, '^heine') then
    package.loaded[k] = nil
  end
end

local hsl = function(...)
  return C.from_hsl(...)
end

local hue_base = 220

local hue_red = 0
local hue_orange = 20
local hue_green = 90
local hue_lgreen = 140
local hue_cyan = 190
local hue_blue = 220
local hue_magenta = 260

local palette = {
  red = hsl(hue_red, 65, 68),
  orange = hsl(hue_orange, 51, 68),
  green = hsl(hue_green, 27, 70),
  lgreen = hsl(hue_lgreen, 27, 68),
  cyan = hsl(hue_cyan, 38, 67),
  blue = hsl(hue_blue, 41, 68),
  magenta = hsl(hue_magenta, 27, 70),
}

-- normal
local normal_bg = hsl(hue_base, 25, 12)
local normal_fg = hsl(hue_base, 10, 78)

-- tint
local green_tint_bg = palette.green:blend(normal_bg, 0.7)
-- local green_tint_fg = palette.green:blend(normal_fg, 0.7)
local blue_tint_bg = palette.blue:blend(normal_bg, 0.7)
-- local blue_tint_fg = palette.blue:blend(normal_fg, 0.7)
local orange_tint_bg = palette.orange:blend(normal_bg, 0.7)
local orange_tint_fg = palette.orange:blend(normal_fg, 0.7)
-- local cyan_tint_bg = palette.cyan:blend(normal_bg, 0.7)
-- local cyan_tint_fg = palette.cyan:blend(normal_fg, 0.7)
local red_tint_bg = palette.red:blend(normal_bg, 0.7)
-- local red_tint_fg = palette.red:blend(normal_fg, 0.7)
-- local magenta_tint_bg = palette.magenta:blend(normal_bg, 0.7)
-- local magenta_tint_fg = palette.magenta:blend(normal_fg, 0.7)
local lgreen_tint_bg = palette.lgreen:blend(normal_bg, 0.7)
-- local lgreen_tint_fg = palette.lgreen:blend(normal_fg, 0.7)

-- local difftext_bg = cyan_tint_bg
-- local difftext_fg = normal_fg

local statusline_bg = hsl(hue_base, 20, 22)
local statusline_fg = hsl(hue_base, 10, 70)
local statuslinenc_bg = statusline_bg:lighten(-3)
local statuslinenc_fg = normal_fg:lighten(10)

local cursorline_bg = normal_bg:saturate(1):lighten(5)
-- local cursorline_fg = normal_fg:saturate(1):lighten(5)

local pmenu_bg = normal_bg:saturate(1):lighten(5)
local pmenu_fg = normal_fg
local pmenusel_bg = hsl(hue_base, 20, 45)
local pmenusel_fg = hsl(hue_base, 20, 95)

local folded_bg = cursorline_bg
local folded_fg = folded_bg:saturate(5):lighten(35)

local comment_fg = hsl(hue_base, 18, 48)

local matchparen_bg = normal_bg:saturate(3):lighten(20)

local linenr_fg = normal_bg:lighten(20)

local search_bg = hsl(hue_orange, 65, 72)
local search_fg = hsl(hue_orange, 50, 15)
local visual_bg = normal_bg:saturate(5):lighten(10)

local whitespace_fg = normal_bg:saturate(8):lighten(39)
local wildmenu_bg = statusline_bg:lighten(5)
local wildmenu_fg = statusline_fg

local specialkey_fg = normal_bg:saturate(10):lighten(35)

local all = {
  -- :help highlight-groups
  ColorColumn = { fg = normal_fg, bg = normal_bg },
  Conceal = { link = 'Comment' },
  CurSearch = { link = 'IncSearch' },
  Cursor = { fg = normal_fg, bg = normal_bg },
  lCursor = { link = 'Cursor' },
  CursorIM = { link = 'Cursor' },
  CursorColumn = { link = 'CursorLine' },
  Cursorline = { bg = cursorline_bg },
  Directory = { fg = palette.blue },
  DiffAdd = { bg = green_tint_bg },
  DiffChange = { bg = lgreen_tint_bg },
  DiffDelete = { bg = red_tint_bg },
  DiffText = { bg = lgreen_tint_bg:lighten(10) },
  EndOfBuffer = { fg = normal_bg, bg = normal_bg },
  -- TermCursor = {},
  -- TermCursorNC = {},
  ErrorMsg = { fg = palette.red },
  WinSeparator = { fg = comment_fg, bg = pmenu_bg },
  Folded = { fg = folded_fg, bg = folded_bg },
  FoldColumn = { fg = folded_fg, bg = normal_bg },
  SignColumn = { fg = normal_fg, bg = normal_bg },
  IncSearch = { reverse = true },
  -- Substitute = {},
  LineNr = { fg = linenr_fg },
  -- LineNrAbove = { fg = linenr_fg },
  -- LineNrBelow = { fg = linenr_fg },
  CursorlineNr = { bold = true },
  -- CursorlineSign = { fg = palette.green },
  -- CursorlineFold = { fg = palette.green },
  MatchParen = { bg = matchparen_bg },
  Modemsg = { fg = comment_fg },
  -- MsgArea = {},
  -- MsgSeparator = {},
  Moremsg = { fg = palette.green },
  NonText = { fg = whitespace_fg },
  Normal = { fg = normal_fg, bg = normal_bg },
  NormalFloat = { link = 'Pmenu' },
  FloatBorder = { link = 'WinSeparator' },
  Pmenu = { fg = pmenu_fg, bg = pmenu_bg },
  PmenuSel = { fg = pmenusel_fg, bg = pmenusel_bg },
  -- PmenuSbar = { fg = pmenusel_fg, bg = pmenusel_bg },
  -- PmenuThumb = { fg = pmenusel_fg, bg = pmenusel_bg },
  Question = { link = 'Moremsg' },
  QuickFixLine = { fg = normal_fg, bg = visual_bg },
  Search = { fg = search_fg, bg = search_bg },
  SpecialKey = { fg = specialkey_fg },
  SpellBad = { sp = palette.red, undercurl = true },
  SpellCap = { sp = palette.orange, undercurl = true },
  SpellLocal = { sp = palette.green, undercurl = true },
  SpellRare = { sp = palette.green, undercurl = true },
  Statusline = { fg = statusline_fg, bg = statusline_bg },
  StatuslineNC = { fg = statuslinenc_fg, bg = statuslinenc_bg },
  Tabline = { fg = statusline_fg, bg = statusline_bg },
  TablineFill = { bg = normal_bg:lighten(5) },
  TablineSel = { fg = normal_fg },
  Title = { fg = palette.cyan },
  Visual = { bg = visual_bg },
  VisualNOS = { bg = visual_bg },
  WarningMsg = { fg = palette.orange },
  WhiteSpace = { fg = whitespace_fg },
  WildMenu = { fg = wildmenu_fg, bg = wildmenu_bg },
  -- Winbar = {},
  -- WinbarNC = {},
  -- Menu = {},
  Scrollbar = { fg = statusline_fg, bg = statusline_bg },
  -- Tooltip = {},

  -- diagnostic
  DiagnosticError = { fg = palette.red },
  DiagnosticWarn = { fg = palette.orange },
  DiagnosticInfo = { fg = palette.blue },
  DiagnosticHint = { fg = palette.green },

  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },

  DiagnosticVirtualTextError = { link = 'DiagnosticError' },
  DiagnosticVirtualTextWarn = { link = 'DiagnosticWarn' },
  DiagnosticVirtualTextInfo = { link = 'DiagnosticInfo' },
  DiagnosticVirtualTextHint = { link = 'DiagnosticHint' },

  DiagnosticUnderlineError = { undercurl = true, sp = palette.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = palette.orange },
  DiagnosticUnderlineInfo = { undercurl = true, sp = palette.green },
  DiagnosticUnderlineHint = { undercurl = true, sp = palette.blue },

  -- :help group-name
  Comment = { fg = comment_fg },
  Constant = { fg = palette.orange },
  String = { fg = palette.lgreen },
  Character = { link = 'String' },
  Number = { link = 'Constant' },
  Boolean = { link = 'Constant' },
  Float = { link = 'Number' },

  Identifier = { fg = palette.cyan },
  Function = { fg = palette.blue },

  Statement = { fg = palette.magenta },
  Conditional = { link = 'Statement' },
  Repeat = { link = 'Statement' },
  Label = { link = 'Statement' },
  Operator = { link = 'Statement' },
  Keyword = { link = 'Statement' },
  Exception = { link = 'Statement' },

  PreProc = { fg = palette.magenta },
  Include = { link = 'PreProc' },
  Define = { link = 'PreProc' },
  Macro = { link = 'PreProc' },
  PreCondit = { link = 'PreProc' },

  Type = { fg = palette.green },
  StorageClass = { link = 'Type' },
  Structure = { link = 'Type' },
  Typedef = { link = 'Type' },

  Special = { fg = palette.orange },
  SpecialChar = { link = 'Special' },
  Tag = { link = 'Special' },
  Delimiter = { fg = whitespace_fg },
  SpecialComment = { link = 'Special' },
  Debug = { link = 'Special' },

  Underlined = { fg = palette.blue, underline = true },

  -- Ignore = {},

  Error = { fg = palette.red },

  Todo = { fg = orange_tint_fg, bg = orange_tint_bg },

  diffAdded = { link = 'DiffAdd' },
  diffRemoved = { link = 'DiffDelete' },
  diffChanged = { link = 'DiffChange' },
  diffFile = { link = 'Directory' },
  diffOldFile = { fg = palette.red },
  diffNewFile = { fg = palette.green },
  -- diffFile = {},

  -- health
  healthSuccess = { fg = palette.green },
  healthWarning = { fg = palette.orange },
  healthError = { fg = palette.red },

  -- lsp
  LspReferenceRead = { bg = pmenusel_bg },
  LspReferenceText = { bg = pmenusel_bg },
  LspReferenceWrite = { bg = pmenusel_bg },
  LspCodeLens = { fg = comment_fg },
  -- LspCodeLensSeparator = {},
  -- LspSignatureActiveParameter = {},
  -- LspDiagnosticsDefaultInformation = {},

  -- :help nvim-treesitter-highlights
  -- TSAttribute = {},
  -- TSBoolean = {},
  -- TSCharacter = {},
  -- TSCharacterSpecial = {},
  -- TSComment = {},
  -- TSConditional = {},
  -- TSConstant = {},
  -- TSConstBuiltin = {},
  -- TSConstMacro = {},
  -- TSConstructor = {},
  -- TSDefine = {},
  -- TSDebug = {},
  -- TSError = {},
  -- TSException = {},
  -- TSField = {},
  -- TSFloat = {},
  -- TSFunction = {},
  -- TSFuncBuiltin = {},
  -- TSFunctionBuiltin = {},
  -- TSFuncMacro = {},
  -- TSInclude = {},
  -- TSKeyword = {},
  -- TSKeywordFunction = {},
  -- TSKeywordOperator = {},
  -- TSKeywordReturn = {},
  -- TSLabel = {},
  -- TSMethod = {},
  -- TSNamespace = {},
  -- TSNone = {},
  -- TSNumber = {},
  -- TSOperator = {},
  -- TSParameter = {},
  -- TSParameterReference = {},
  -- TSPreProc = {},
  -- TSProperty = {},
  -- TSPunctDelimiter = {},
  -- TSPunctBracket = {},
  -- TSPunctSpecial = {},
  -- TSRepeat = {},
  -- TSStorageClass = {},
  -- TSString = {},
  -- TSStringRegex = {},
  -- TSStringEscape = {},
  -- TSStringSpecial = {},
  -- TSSymbol = {},
  -- TSTag = {},
  -- TSTagAttribute = {},
  -- TSTagDelimiter = {},
  -- TSText = {},
  -- TSStrong = {},
  -- TSEmphasis = {},
  -- TSUnderline = {},
  -- TSStrike = {},
  -- TSTitle = {},
  -- TSLiteral = {},
  -- TSURI = {},
  -- TSMath = {},
  -- TSTextReference = {},
  -- TSEnvironment = {},
  -- TSEnvironmentName = {},
  -- TSNote = {},
  -- TSWarning = {},
  -- TSDanger = {},
  -- TSTodo = {},
  -- TSType = {},
  -- TSTypeDefinition = {},
  TSVariable = { fg = normal_fg },
  -- TSVariableBuiltin = {},

  -- markdown
  markdownCode = { link = 'String' },
  markdownCodeDelimiter = { link = 'String' },

  -- plugins
  -- telescope.nvim
  TelescopeNormal = { link = 'Pmenu' },
  TelescopePromptNormal = { link = 'Pmenu' },
  TelescopeBorder = { link = 'WinSeparator' },
  TelescopeMatching = { fg = palette.blue, bold = true },
  TelescopeSelection = { link = 'Visual' },

  -- nvim-notify
  NotifyERRORBorder = { fg = red_tint_bg, bg = pmenu_bg },
  NotifyWARNBorder = { fg = orange_tint_bg, bg = pmenu_bg },
  NotifyINFOBorder = { fg = blue_tint_bg, bg = pmenu_bg },
  NotifyDEBUGBorder = { fg = green_tint_bg, bg = pmenu_bg },
  NotifyTRACEBorder = { fg = comment_fg, bg = pmenu_bg },

  NotifyERRORTitle = { fg = palette.red },
  NotifyWARNTitle = { fg = palette.orange },
  NotifyINFOTitle = { fg = palette.blue },
  NotifyDEBUGTitle = { fg = palette.green },
  NotifyTRACETitle = { fg = comment_fg },

  NotifyERRORIcon = { link = 'NotifyERRORTitle' },
  NotifyWARNIcon = { link = 'NotifyWARNTitle' },
  NotifyINFOIcon = { link = 'NotifyINFOTitle' },
  NotifyDEBUGIcon = { link = 'NotifyDEBUGTitle' },
  NotifyTRACEIcon = { link = 'NotifyTRACETitle' },

  NotifyERRORBody = { bg = pmenu_bg },
  NotifyWARNBody = { bg = pmenu_bg },
  NotifyINFOBody = { bg = pmenu_bg },
  NotifyDEBUGBody = { bg = pmenu_bg },
  NotifyTRACEBody = { bg = pmenu_bg },

  -- :help cmp-highlight
  CmpItemAbbr = {},
  CmpItemAbbrDeprecated = { strikethrough = true },
  CmpItemAbbrMatch = { fg = palette.blue, bold = true },
  CmpItemAbbrMatchFuzzy = { link = 'CmpItemAbbrMatch' },
  CmpItemMenu = { link = 'Pmenu' },

  CmpItemKindKeyword = { link = 'Identifier' },

  CmpItemKindVariable = { link = 'TSVariable' },
  CmpItemKindConstant = { link = 'TSConstant' },
  CmpItemKindReference = { link = 'Keyword' },
  CmpItemKindValue = { link = 'Keyword' },

  CmpItemKindFunction = { link = 'Function' },
  CmpItemKindMethod = { link = 'Function' },
  CmpItemKindConstructor = { link = 'Function' },

  CmpItemKindInterface = { link = 'Constant' },
  CmpItemKindEvent = { link = 'Constant' },
  CmpItemKindEnum = { link = 'Constant' },
  CmpItemKindUnit = { link = 'Constant' },

  CmpItemKindClass = { link = 'Type' },
  CmpItemKindStruct = { link = 'Type' },

  CmpItemKindModule = { link = 'TSNamespace' },

  CmpItemKindProperty = { link = 'TSProperty' },
  CmpItemKindField = { link = 'TSField' },
  CmpItemKindTypeParameter = { link = 'TSField' },
  CmpItemKindEnumMember = { link = 'TSField' },
  CmpItemKindOperator = { link = 'Operator' },
  -- CmpItemKindSnippet       = {},

  -- nvim-bqf
  BqfPreviewBorder = { link = 'FloatBorder' },

  -- PounceAccept = {},
  -- PounceAcceptBest = {},
  -- PounceMatch = {},
  -- PounceGap = {}

  -- ts-rainbow
  rainbowcol1 = { fg = palette.magenta },
  rainbowcol2 = { fg = palette.blue },
  rainbowcol3 = { fg = palette.cyan },
  rainbowcol4 = { fg = palette.lgreen },
  rainbowcol5 = { fg = palette.green },
  rainbowcol6 = { fg = palette.orange },
  rainbowcol7 = { fg = palette.red },

  -- gitsigns.nvim
  GitSignsAdd = { fg = palette.green },
  GItSignsChange = { fg = palette.orange },
  GItSignsDelete = { fg = palette.red },

  -- GitSignsAddLn = {},
  -- GitSignsChangeLn = {},
  GitSignsDeleteLn = { link = 'DiffDelete' },

  -- GitSignsAddInline = {},
  -- GitSignsChangeInline = {},
  -- GitSignsDeleteInline = {},

  -- GitSignsAddNr = {},
  -- GitSignsChangeNr = {},
  -- GitSignsDeleteNr = {},

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

  -- vim-eft
  EftChar = { fg = search_fg, bg = search_bg },
  EftSubChar = { fg = search_fg, bg = search_bg:lighten(20) },
}

for name, val in pairs(all) do
  val.fg = val.fg and val.fg:to_css()
  val.bg = val.bg and val.bg:to_css()
  val.sp = val.sp and val.sp:to_css()
  vim.api.nvim_set_hl(0, name, val)
end
