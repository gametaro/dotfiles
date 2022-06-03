local g, opt = vim.g, vim.opt
local fn = vim.fn

local indent = 2

opt.autowriteall = true
-- opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.confirm = true
opt.diffopt:append {
  'algorithm:histogram',
  'indent-heuristic',
  'vertical',
}
opt.emoji = false
opt.expandtab = true
opt.fileformat = 'unix'
opt.fileformats = {
  'unix',
  'dos',
  'mac',
}
opt.fillchars = {
  diff = '╱', -- '/',
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
opt.formatoptions:remove {
  'c',
  'o',
  'r',
}
opt.ignorecase = true
opt.imsearch = 0
opt.inccommand = 'split'
opt.isfname:remove { '=' }
opt.laststatus = 3
opt.lazyredraw = true
-- opt.list = true
opt.listchars = {
  eol = '↵',
  extends = '»',
  precedes = '«',
  tab = '>-',
  trail = '·',
}
-- opt.modeline = false
-- opt.mouse = 'a'
-- opt.number = true
opt.pumblend = 20
opt.pumheight = 10
-- opt.relativenumber = true
-- opt.shada = { '!', "'0", 'f0', '<50', 's10', 'h' }
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.secure = true
opt.sessionoptions:append {
  'winpos',
}
opt.shiftround = true
opt.shiftwidth = indent
opt.shortmess:append {
  S = true,
  a = true,
  c = true,
  s = true,
}
opt.showbreak = '↳ '
-- opt.showcmd = false
opt.showmode = false
opt.signcolumn = 'yes:2'
opt.smartcase = true
opt.smartindent = true
opt.spellcapcheck = ''
opt.spelllang = { 'en', 'cjk', 'programming' }
opt.spelloptions = 'camel'
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.switchbuf = { 'useopen', 'uselast' }
opt.tabstop = indent
opt.termguicolors = true
opt.tildeop = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.undofile = true
opt.updatetime = 250
opt.virtualedit = 'block'
opt.wildignorecase = true
opt.wildoptions = 'pum'
opt.winblend = 10
opt.wrap = false

if fn.executable('fish') > 0 then
  opt.shell = 'fish'
end

if fn.executable('rg') > 0 then
  opt.grepprg = 'rg --vimgrep --smart-case --hidden'
end

-- neovide
if fn.exists('g:neovide') > 0 then
  g.neovide_cursor_animation_length = 0
  g.neovide_cursor_trail_length = 0
  opt.guifont = 'FiraCode NF:style=Regular:h11'
end
