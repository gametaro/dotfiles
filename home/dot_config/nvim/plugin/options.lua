local g, opt = vim.g, vim.opt
local indent = 2

-- neovide
if vim.fn.exists 'g:neovide' > 0 then
  g.neovide_cursor_animation_length = 0
  g.neovide_cursor_trail_length = 0
  opt.guifont = 'FiraCode NF:style=Regular:h11'
end

opt.autowriteall = true
opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menu', 'menuone', 'noselect', 'noinsert' }
opt.diffopt = {
  'algorithm:histogram',
  'closeoff',
  'filler',
  'indent-heuristic',
  'internal',
  'vertical',
}
opt.expandtab = true
opt.fillchars = { diff = '/' }
-- see :h fo-table
opt.formatoptions:remove {
  'c',
  'o',
  'r',
}
opt.foldmethod = 'expr'
opt.ignorecase = true
opt.imsearch = 0
opt.isfname:remove { '=' }
opt.lazyredraw = true
opt.list = true
opt.listchars = {
  eol = '↵',
  extends = '»',
  precedes = '«',
  tab = [[]→\]],
  trail = '·',
}
opt.modeline = false
-- opt.mouse = 'a'
opt.pumheight = 15
opt.shada = "!,'0,f0,<50,s10,h"
opt.scrolloff = 5
opt.sidescrolloff = 5
opt.secure = true
opt.sessionoptions = {
  'buffers',
  'curdir',
  'tabpages',
  'winsize',
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
opt.showcmd = false
opt.showmode = false
opt.signcolumn = 'yes'
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = indent
opt.termguicolors = true
opt.timeoutlen = 500
opt.ttimeoutlen = 10
opt.undofile = true
opt.updatetime = 250
opt.virtualedit = 'block'
opt.wildignorecase = true
opt.wildoptions = 'pum'
opt.wrap = false

if vim.fn.executable 'fish' > 0 then
  opt.shell = '/usr/bin/fish'
end

if vim.fn.executable 'rg' > 0 then
  opt.grepprg = 'rg --vimgrep --smart-case --hidden --glob=!.git'
end
