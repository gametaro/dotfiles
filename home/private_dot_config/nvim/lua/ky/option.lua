local indent = 2
local blend = 0

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.ts_highlight_lua = true

vim.o.autowriteall = true
vim.o.backup = true
vim.opt.backupdir = { vim.fn.stdpath('state') .. '/backup//', '.' }
vim.fn.mkdir(vim.fn.stdpath('state') .. '/backup', 'p')
vim.opt.backupskip:append({ '*/.git/*' })
-- opt.clipboard = 'unnamedplus'
vim.o.cmdheight = 0
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.o.confirm = true
vim.o.copyindent = true
vim.opt.diffopt:append({
  'algorithm:histogram',
  'indent-heuristic',
  'vertical',
  'linematch:60',
})
vim.o.emoji = false
vim.o.expandtab = true
vim.o.fileformat = 'unix'
vim.opt.fileformats = {
  'unix',
  'dos',
  'mac',
}
vim.opt.fillchars = {
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
vim.opt.formatoptions:remove({
  'c',
  'o',
  'r',
})
vim.o.ignorecase = true
vim.o.imsearch = 0
vim.o.inccommand = 'split'
vim.opt.isfname:remove({ '=' })
vim.o.jumpoptions = 'view'
vim.o.laststatus = 3
-- o.lazyredraw = true
vim.o.linebreak = true
vim.o.list = true
vim.opt.listchars = {
  -- eol = '↵',
  extends = '»',
  precedes = '«',
  tab = '>-',
  trail = '·',
}
vim.opt.modeline = false
-- o.more = false
opt.mousescroll = { 'ver:1', 'hor:3' }
o.preserveindent = true
o.pumblend = blend
o.pumheight = 10
o.report = 99999
o.ruler = false
opt.shada:append({ 'r/tmp', 'rterm', 'rhealth' })
-- opt.scrolloff = 5
-- opt.sidescrolloff = 5
vim.o.secure = true
vim.opt.sessionoptions = { 'buffers', 'tabpages', 'winpos', 'winsize' }
vim.o.shiftround = true
vim.o.shiftwidth = indent
vim.opt.shortmess:append({
  C = true,
  I = true,
  -- S = true,
  W = true,
  -- a = true,
  c = true,
  s = true,
})
-- opt.showbreak = '↳ '
o.showcmd = false
o.showmode = false
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

if vim.fn.executable('git') == 1 and require('ky.util').is_git_repo() then
  vim.o.grepprg = 'git --no-pager grep -I -E --no-color --line-number --column'
  vim.o.grepformat = '%f:%l:%m,%f:%l:%c:%m'
elseif vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep --smart-case --hidden'
end

if vim.fn.executable('zsh') == 1 then
  vim.o.shell = 'zsh'
end

-- neovide
if vim.fn.exists('g:neovide') > 0 then
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_length = 0
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.o.guifont = 'FiraCode NF:style=Regular:h12'
end
