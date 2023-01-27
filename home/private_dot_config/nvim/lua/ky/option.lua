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
-- vim.opt.mousescroll = { 'ver:1', 'hor:3' }
vim.o.preserveindent = true
vim.o.pumblend = blend
vim.o.pumheight = 10
vim.o.report = 99999
vim.o.ruler = false
vim.opt.shada:append({ 'r/tmp', 'rterm', 'rhealth' })
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
vim.o.showcmd = false
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spellcapcheck = ''
vim.opt.spelllang = { 'en', 'cjk' }
vim.opt.spelloptions = { 'camel', 'noplainbuffer' }
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.startofline = true
vim.o.swapfile = false
vim.opt.switchbuf = { 'useopen', 'uselast' }
vim.o.tabstop = indent
vim.o.termguicolors = true
vim.o.tildeop = true
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 150
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wildoptions = 'fuzzy'
vim.o.winblend = blend
vim.o.wrap = false
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
