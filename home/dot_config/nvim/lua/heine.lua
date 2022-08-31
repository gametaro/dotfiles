-- Inspired by
-- iceberg.vim
-- nightfox.nvim
-- catppuccin
-- tokyonight.nvim
-- and more!

local hsluv = require('ky.hsluv')

local M = {}

local compile_path = vim.fs.normalize(vim.fn.stdpath('cache')) .. '/heine.lua'

---@param value integer
---@param min integer
---@param max integer
local clamp = function(value, min, max)
  if value < min then
    return min
  elseif value > max then
    return max
  end
  return value
end

---@param hex string
---@param v integer
M.saturate = function(hex, v)
  local h, s, l = unpack(hsluv.hex_to_hsluv(hex))
  return hsluv.hsluv_to_hex({ h, clamp(s + v, -100, 100), l })
end

---@param hex string
---@param v integer
M.lighten = function(hex, v)
  local h, s, l = unpack(hsluv.hex_to_hsluv(hex))
  return hsluv.hsluv_to_hex({ h, s, clamp(l + v, -100, 100) })
end

---@param hex string
---@param s integer
---@param l integer
M.saturate_lighten = function(hex, s, l)
  return M.lighten(M.saturate(hex, s), l)
end

---@param c1 string
---@param c2 string
---@param f number
M.blend = function(c1, c2, f)
  local r1, g1, b1 = unpack(hsluv.hex_to_rgb(c1))
  local r2, g2, b2 = unpack(hsluv.hex_to_rgb(c2))
  return hsluv.rgb_to_hex({ (r2 - r1) * f + r1, (g2 - g1) * f + g1, (b2 - b1) * f + b1 })
end

---@type table<string, string>
M.palette = {
  red = hsluv.hsluv_to_hex({ 0, 65, 68 }),
  orange = hsluv.hsluv_to_hex({ 20, 51, 68 }),
  green = hsluv.hsluv_to_hex({ 90, 27, 70 }),
  lgreen = hsluv.hsluv_to_hex({ 140, 27, 68 }),
  cyan = hsluv.hsluv_to_hex({ 190, 38, 67 }),
  blue = hsluv.hsluv_to_hex({ 220, 41, 68 }),
  magenta = hsluv.hsluv_to_hex({ 260, 27, 70 }),
}

local hue_base = 220

local normal_bg = hsluv.hsluv_to_hex({ hue_base, 25, 12 })
local normal_fg = hsluv.hsluv_to_hex({ hue_base, 10, 78 })

local statusline_bg = hsluv.hsluv_to_hex({ hue_base, 20, 10 })
local statusline_fg = hsluv.hsluv_to_hex({ hue_base, 10, 70 })
local statuslinenc_bg = M.lighten(statusline_bg, -3)
local statuslinenc_fg = M.lighten(normal_fg, 10)

local cursorline_bg = M.saturate_lighten(normal_bg, 1, 5)
-- local cursorline_fg = normal_fg:saturate(1):lighten(5)

local pmenu_bg = hsluv.hsluv_to_hex({ hue_base, 20, 20 })
local pmenu_fg = normal_fg
local pmenusel_bg = hsluv.hsluv_to_hex({ hue_base, 20, 35 })
local pmenusel_fg = hsluv.hsluv_to_hex({ hue_base, 20, 95 })

local folded_bg = cursorline_bg
local folded_fg = M.saturate_lighten(folded_bg, 5, 35)

local comment_fg = hsluv.hsluv_to_hex({ hue_base, 18, 48 })

local matchparen_bg = M.saturate_lighten(normal_bg, 3, 20)

local linenr_fg = M.lighten(normal_bg, 20)

local search_bg = M.saturate_lighten(M.palette.orange, 15, 4)
local search_fg = M.saturate_lighten(M.palette.orange, 50, -50)
local visual_bg = M.saturate_lighten(normal_bg, 5, 10)

local whitespace_fg = M.saturate_lighten(normal_bg, 8, 39)
local wildmenu_bg = M.lighten(statusline_bg, 5)
local wildmenu_fg = statusline_fg

local specialkey_fg = M.saturate_lighten(normal_bg, 10, 35)

local green_tint_bg = M.blend(M.palette.green, normal_bg, 0.7)
local blue_tint_bg = M.blend(M.palette.blue, normal_bg, 0.7)
local orange_tint_bg = M.blend(M.palette.orange, normal_bg, 0.7)
local orange_tint_fg = M.blend(M.palette.orange, normal_fg, 0.7)
local red_tint_bg = M.blend(M.palette.red, normal_bg, 0.7)
local lgreen_tint_bg = M.blend(M.palette.lgreen, normal_bg, 0.7)

---@type table<string, table>
M.highlight_groups = {
  -- :help highlight-groups
  ColorColumn = { fg = normal_fg, bg = normal_bg },
  Conceal = { link = 'Comment' },
  CurSearch = { link = 'IncSearch' },
  Cursor = { fg = normal_fg, bg = normal_bg },
  lCursor = { link = 'Cursor' },
  CursorIM = { link = 'Cursor' },
  CursorColumn = { link = 'CursorLine' },
  Cursorline = { bg = cursorline_bg },
  Directory = { fg = M.palette.blue },
  DiffAdd = { bg = green_tint_bg },
  DiffChange = { bg = lgreen_tint_bg },
  DiffDelete = { bg = red_tint_bg },
  DiffText = { bg = M.lighten(lgreen_tint_bg, 10) },
  EndOfBuffer = { fg = normal_bg, bg = normal_bg },
  -- TermCursor = {},
  -- TermCursorNC = {},
  ErrorMsg = { fg = M.palette.red },
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
  Moremsg = { fg = M.palette.green },
  NonText = { fg = whitespace_fg },
  Normal = { fg = normal_fg, bg = normal_bg },
  NormalFloat = { link = 'Pmenu' },
  FloatBorder = { link = 'WinSeparator' },
  Pmenu = { fg = pmenu_fg, bg = pmenu_bg },
  PmenuSel = { fg = pmenusel_fg, bg = pmenusel_bg },
  PmenuSbar = { bg = pmenu_bg },
  PmenuThumb = { bg = pmenusel_bg },
  Question = { link = 'Moremsg' },
  QuickFixLine = { fg = normal_fg, bg = visual_bg },
  Search = { fg = search_fg, bg = search_bg },
  SpecialKey = { fg = specialkey_fg },
  SpellBad = { sp = M.palette.red, undercurl = true },
  SpellCap = { sp = M.palette.orange, undercurl = true },
  SpellLocal = { sp = M.palette.green, undercurl = true },
  SpellRare = { sp = M.palette.green, undercurl = true },
  Statusline = { fg = statusline_fg, bg = statusline_bg },
  StatuslineNC = { fg = statuslinenc_fg, bg = statuslinenc_bg },
  Tabline = { fg = statusline_fg, bg = statusline_bg },
  TablineFill = { bg = M.lighten(normal_bg, 5) },
  TablineSel = { fg = normal_fg },
  Title = { fg = M.palette.cyan },
  Visual = { bg = visual_bg },
  VisualNOS = { bg = visual_bg },
  WarningMsg = { fg = M.palette.orange },
  WhiteSpace = { fg = whitespace_fg },
  WildMenu = { fg = wildmenu_fg, bg = wildmenu_bg },
  -- Winbar = {},
  -- WinbarNC = {},
  -- Menu = {},
  Scrollbar = { fg = statusline_fg, bg = statusline_bg },
  -- Tooltip = {},

  -- diagnostic
  DiagnosticError = { fg = M.palette.red },
  DiagnosticWarn = { fg = M.palette.orange },
  DiagnosticInfo = { fg = M.palette.blue },
  DiagnosticHint = { fg = M.palette.green },

  DiagnosticSignError = { link = 'DiagnosticError' },
  DiagnosticSignWarn = { link = 'DiagnosticWarn' },
  DiagnosticSignInfo = { link = 'DiagnosticInfo' },
  DiagnosticSignHint = { link = 'DiagnosticHint' },

  DiagnosticVirtualTextError = { link = 'DiagnosticError' },
  DiagnosticVirtualTextWarn = { link = 'DiagnosticWarn' },
  DiagnosticVirtualTextInfo = { link = 'DiagnosticInfo' },
  DiagnosticVirtualTextHint = { link = 'DiagnosticHint' },

  DiagnosticUnderlineError = { undercurl = true, sp = M.palette.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = M.palette.orange },
  DiagnosticUnderlineInfo = { undercurl = true, sp = M.palette.green },
  DiagnosticUnderlineHint = { undercurl = true, sp = M.palette.blue },

  -- :help group-name
  Comment = { fg = comment_fg },
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

  Special = { fg = M.palette.orange },
  SpecialChar = { link = 'Special' },
  Tag = { link = 'Special' },
  Delimiter = { fg = whitespace_fg },
  SpecialComment = { link = 'Special' },
  Debug = { link = 'Special' },

  Underlined = { fg = M.palette.blue, underline = true },

  -- Ignore = {},

  Error = { fg = M.palette.red },

  Todo = { fg = orange_tint_fg, bg = orange_tint_bg },

  diffAdded = { link = 'DiffAdd' },
  diffRemoved = { link = 'DiffDelete' },
  diffChanged = { link = 'DiffChange' },
  diffFile = { link = 'Directory' },
  diffOldFile = { fg = M.palette.red },
  diffNewFile = { fg = M.palette.green },
  -- diffFile = {},

  -- health
  healthSuccess = { fg = M.palette.green },
  healthWarning = { fg = M.palette.orange },
  healthError = { fg = M.palette.red },

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
  -- markdownCodeBlock = { link = 'String' },
  markdownCodeDelimiter = { link = 'String' },

  -- typescript
  typescriptParens = { link = 'Delimiter' },

  -- lua
  luaParen = { link = 'Delimiter' },

  -- plugins
  -- telescope.nvim
  TelescopeNormal = { link = 'Pmenu' },
  TelescopePromptNormal = { link = 'Pmenu' },
  TelescopeBorder = { link = 'WinSeparator' },
  TelescopeMatching = { fg = M.palette.blue, bold = true },
  TelescopeSelection = { link = 'PmenuSel' },

  -- nvim-notify
  NotifyERRORBorder = { fg = red_tint_bg, bg = pmenu_bg },
  NotifyWARNBorder = { fg = orange_tint_bg, bg = pmenu_bg },
  NotifyINFOBorder = { fg = blue_tint_bg, bg = pmenu_bg },
  NotifyDEBUGBorder = { fg = green_tint_bg, bg = pmenu_bg },
  NotifyTRACEBorder = { fg = comment_fg, bg = pmenu_bg },

  NotifyERRORTitle = { fg = M.palette.red },
  NotifyWARNTitle = { fg = M.palette.orange },
  NotifyINFOTitle = { fg = M.palette.blue },
  NotifyDEBUGTitle = { fg = M.palette.green },
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
  -- CmpItemAbbr = {},
  CmpItemAbbrDeprecated = { fg = comment_fg, strikethrough = true },
  CmpItemAbbrMatch = { fg = M.palette.blue, bold = true },
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

  -- CmpItemKindKeyword = { fg = normal_bg, bg = M.palette.cyan },
  --
  -- CmpItemKindVariable = { fg = normal_bg, bg = M.palette.lgreen },
  -- CmpItemKindConstant = { fg = normal_bg, bg = M.palette.orange },
  -- CmpItemKindReference = { fg = normal_bg, bg = M.palette.magenta },
  -- CmpItemKindValue = { fg = normal_bg, bg = M.palette.magenta },
  --
  -- CmpItemKindFunction = { fg = normal_bg, bg = M.palette.blue },
  -- CmpItemKindMethod = { fg = normal_bg, bg = M.palette.blue },
  -- CmpItemKindConstructor = { fg = normal_bg, bg = M.palette.blue },
  --
  -- CmpItemKindInterface = { fg = normal_bg, bg = M.palette.orange },
  -- CmpItemKindEvent = { fg = normal_bg, bg = M.palette.orange },
  -- CmpItemKindEnum = { fg = normal_bg, bg = M.palette.orange },
  -- CmpItemKindUnit = { fg = normal_bg, bg = M.palette.orange },
  --
  -- CmpItemKindClass = { fg = normal_bg, bg = M.palette.orange },
  -- CmpItemKindStruct = { fg = normal_bg, bg = M.palette.orange },
  --
  -- CmpItemKindModule = { fg = normal_bg, bg = M.palette.magenta },
  --
  -- CmpItemKindProperty = { fg = normal_bg, bg = M.palette.cyan },
  -- CmpItemKindField = { fg = normal_bg, bg = M.palette.cyan },
  -- CmpItemKindTypeParameter = { fg = normal_bg, bg = M.palette.cyan },
  -- CmpItemKindEnumMember = { fg = normal_bg, bg = M.palette.cyan },
  -- CmpItemKindOperator = { fg = normal_bg, bg = M.palette.magenta },
  -- CmpItemKindSnippet = { fg = normal_bg, bg = M.palette.orange },
  --
  -- CmpItemKindDefault = { fg = normal_bg, bg = M.palette.orange },

  -- nvim-bqf
  BqfPreviewBorder = { link = 'FloatBorder' },

  -- pounce.nvim
  PounceAccept = { fg = M.saturate_lighten(M.palette.cyan, 50, -50), bg = M.palette.cyan },
  PounceAcceptBest = { link = 'IncSearch' },
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

  -- gitsigns.nvim
  GitSignsAdd = { fg = M.palette.green },
  GItSignsChange = { fg = M.palette.orange },
  GItSignsDelete = { fg = M.palette.red },

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
  EftChar = { fg = search_bg, bold = true },
  EftSubChar = { fg = whitespace_fg, bold = true },

  -- marks.nvim
  MarkSignHL = { fg = M.palette.orange },

  -- vim-illuminate
  illuminatedWordText = { link = 'MatchParen' },
  illuminatedWordRead = { link = 'MatchParen' },
  illuminatedWordWrite = { link = 'MatchParen' },

  -- nvim-treehopper
  TSNodeUnmatched = { link = 'Comment' },
  TSNodeKey = { link = 'Search' },
}

M.load = function()
  if vim.loop.fs_stat(compile_path) then
    vim.cmd.source(compile_path)
    return
  end
  for name, val in pairs(M.highlight_groups) do
    vim.api.nvim_set_hl(0, name, val)
  end
end

M.reload = function()
  for k, _ in pairs(package.loaded) do
    if string.match(k, '^heine') then
      package.loaded[k] = nil
    end
  end
end

---@param t table
local inspect = function(t)
  local list = {}
  for k, v in pairs(t) do
    local quote = type(v) == 'string' and [[']] or ''
    list[#list + 1] = string.format([[%s = %s%s%s]], k, quote, v, quote)
  end
  table.sort(list)
  return string.format([[{ %s }]], table.concat(list, ', '))
end

---@param silent boolean
M.compile = function(silent)
  silent = silent or false

  local lines = { 'local set_hl = vim.api.nvim_set_hl' }
  for name, val in pairs(M.highlight_groups) do
    lines[#lines + 1] = string.format([[set_hl(0, '%s', %s)]], name, inspect(val))
  end
  table.sort(lines)
  local file, msg = io.open(compile_path, 'w')
  if file then
    file:write(table.concat(lines, '\n') .. '\n')
    file:close()
    if not silent then
      vim.notify(
        string.format('compiled file was written to %s', compile_path),
        vim.log.levels.INFO,
        { title = 'heine' }
      )
    end
  else
    vim.notify(msg, vim.log.levels.ERROR, { title = 'heine' })
  end
end

M.clean = function()
  local ok, msg = os.remove(compile_path)
  if not ok then
    vim.notify(msg, vim.log.levels.ERROR, { title = 'heine' })
  end
end

return M
