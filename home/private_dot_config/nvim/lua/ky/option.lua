local g = vim.g
local o = vim.o
local opt = vim.opt
local fn = vim.fn

local indent = 2
local blend = 10

g.mapleader = ' '
g.maplocalleader = ','
g.ts_highlight_lua = true

o.autowriteall = true
o.backup = true
opt.backupdir = { vim.fn.stdpath('state') .. '/backup//', '.' }
vim.fn.mkdir(vim.fn.stdpath('state') .. '/backup', 'p')
opt.backupskip:append({ '*/.git/*' })
-- opt.clipboard = 'unnamedplus'
o.cmdheight = 0
opt.completeopt = { 'menu', 'menuone', 'noselect' }
o.confirm = true
o.copyindent = true
opt.diffopt:append({
  'algorithm:histogram',
  'indent-heuristic',
  'vertical',
  'linematch:60',
})
o.emoji = false
o.expandtab = true
o.fileformat = 'unix'
opt.fileformats = {
  'unix',
  'dos',
  'mac',
}
opt.fillchars = {
  diff = '╱', -- '/',
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
  -- horiz = '━',
  -- horizup = '┻',
  -- horizdown = '┳',
  -- vert = '┃',
  -- vertleft = '┫',
  -- vertright = '┣',
  -- verthoriz = '╋',
}
-- opt.foldexpr = [[nvim_treesitter#foldexpr()]]
-- opt.foldlevelstart = 1
-- opt.foldmethod = 'expr'
-- see :h fo-table
opt.formatoptions:remove({
  'c',
  'o',
  'r',
})
o.ignorecase = true
o.imsearch = 0
o.inccommand = 'split'
opt.isfname:remove({ '=' })
o.jumpoptions = 'view'
o.laststatus = 3
-- o.lazyredraw = true
o.linebreak = true
o.list = true
opt.listchars = {
  -- eol = '↵',
  extends = '»',
  precedes = '«',
  tab = '>-',
  trail = '·',
}
-- opt.modeline = false
-- o.more = false
opt.mousescroll = { 'ver:1', 'hor:3' }
o.preserveindent = true
o.pumblend = blend
o.pumheight = 10
o.report = 99999
-- o.ruler = false
-- opt.shada = { '!', "'0", 'f0', '<50', 's10', 'h' }
-- opt.scrolloff = 5
-- opt.sidescrolloff = 5
o.secure = true
opt.sessionoptions = { 'buffers', 'tabpages', 'winpos', 'winsize' }
o.shiftround = true
o.shiftwidth = indent
opt.shortmess:append({
  C = true,
  I = true,
  -- S = true,
  W = true,
  -- a = true,
  c = true,
  s = true,
})
-- opt.showbreak = '↳ '
-- o.showcmd = false
-- o.showmode = false
o.signcolumn = 'yes'
o.smartcase = true
o.smartindent = true
o.spellcapcheck = ''
opt.spelllang = { 'en', 'cjk' }
opt.spelloptions = { 'camel', 'noplainbuffer' }
o.splitbelow = true
o.splitkeep = 'screen'
o.splitright = true
o.startofline = true
o.swapfile = false
opt.switchbuf = { 'useopen', 'uselast' }
o.tabstop = indent
o.termguicolors = true
o.tildeop = true
o.timeoutlen = 500
o.ttimeoutlen = 10
o.undofile = true
o.undolevels = 10000
o.updatetime = 150
o.virtualedit = 'block'
o.wildignorecase = true
o.wildoptions = 'pum'
o.winblend = blend
o.wrap = false
vim.o.statuscolumn =
  '%=%l%s%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? "" : "") : " " } '

if fn.executable('git') == 1 and require('ky.util').is_git_repo() then
  o.grepprg = 'git --no-pager grep -I -E --no-color --line-number --column'
  o.grepformat = '%f:%l:%m,%f:%l:%c:%m'
elseif fn.executable('rg') == 1 then
  o.grepprg = 'rg --vimgrep --smart-case --hidden'
end

if fn.executable('zsh') == 1 then
  o.shell = 'zsh'
end

-- neovide
if fn.exists('g:neovide') > 0 then
  g.neovide_cursor_animation_length = 0
  g.neovide_cursor_trail_length = 0
  g.neovide_floating_blur_amount_x = 2.0
  g.neovide_floating_blur_amount_y = 2.0
  o.guifont = 'FiraCode NF:style=Regular:h12'
end
