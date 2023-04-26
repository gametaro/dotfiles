---@param options string[]
---@param append? boolean
---@return string
local function list(options, append)
  append = append or false

  local opts = table.concat(vim.tbl_islist(options) and options or vim.iter.map(function(key, value)
    return key .. ':' .. value
  end, options), ',')
  if append then
    opts = ',' .. opts
  end

  return opts
end

vim.o.autowriteall = true
vim.o.backup = true
vim.o.backupdir = list({ vim.fn.stdpath('state') .. '/backup//', '.' })
vim.fn.mkdir(vim.fn.stdpath('state') .. '/backup', 'p')
vim.o.backupskip = vim.o.backupskip .. ',*/.git/*'
vim.o.breakindent = true
-- vim.o.breakindentopt = list({ 'sbr' })
-- vim.o.cmdheight = 0
vim.o.completeopt = list({ 'menu', 'menuone', 'noselect' })
vim.o.confirm = true
vim.o.copyindent = true
vim.o.cursorlineopt = list({ 'screenline', 'number' })
vim.o.diffopt = vim.o.diffopt
  .. list({
    'algorithm:histogram',
    'indent-heuristic',
    'vertical',
    'linematch:60',
  }, true)
vim.o.emoji = false
vim.o.exrc = true
vim.o.fileformats = list({ 'unix', 'dos' })
vim.o.fillchars = list({
  diff = '╱', -- '/',
  eob = ' ',
  fold = ' ',
  foldopen = require('ky.ui').icons.chevron.down,
  foldsep = ' ',
  foldclose = require('ky.ui').icons.chevron.right,
  -- horiz = '━',
  -- horizup = '┻',
  -- horizdown = '┳',
  -- vert = '┃',
  -- vertleft = '┫',
  -- vertright = '┣',
  -- verthoriz = '╋',
})
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 1
vim.o.foldmethod = 'expr'
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.jumpoptions = 'view'
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = list({
  eol = '↵',
  space = ' ',
  extends = '»',
  precedes = '«',
  tab = '>-',
  trail = '·',
})
vim.o.preserveindent = true
vim.o.pumheight = 10
vim.o.report = 99999
vim.o.scrolloff = 4
vim.o.sessionoptions = list({ 'buffers', 'tabpages', 'winpos', 'winsize' })
vim.o.shada = vim.o.shada .. list({ 'r/tmp', 'rterm', 'rhealth' }, true)
vim.o.shiftround = true
vim.o.shortmess = vim.o.shortmess .. 'CIWcs'
vim.o.showbreak = '↳ '
vim.o.showtabline = 2
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spellcapcheck = ''
vim.o.spelllang = list({ 'en', 'cjk' })
vim.o.spelloptions = list({ 'camel', 'noplainbuffer' })
vim.o.splitkeep = 'screen'
vim.o.swapfile = false
vim.o.switchbuf = list({ 'useopen', 'uselast' })
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 150
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wildoptions = 'fuzzy'

if vim.fn.executable('git') == 1 and require('ky.util').is_git_repo() then
  vim.o.grepprg = 'git --no-pager grep -I -E -i --no-color --line-number --column'
  vim.o.grepformat = '%f:%l:%m,%f:%l:%c:%m'
elseif vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep --smart-case --hidden'
end

if vim.fn.executable('zsh') == 1 then
  vim.o.shell = 'zsh'
end

-- neovide
if vim.g.neovide then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_length = 0
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.o.guifont = 'FiraCode NF:style=Regular:h12'
end
