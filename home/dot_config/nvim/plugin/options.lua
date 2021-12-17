local g, opt = vim.g, vim.opt
local indent = 2

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
opt.fillchars = 'diff:/'
opt.foldmethod = 'expr'
opt.ignorecase = true
opt.inccommand = 'split'
opt.list = true
opt.modeline = false
opt.mouse = 'a'
opt.scrolloff = 3
opt.secure = true
opt.sessionoptions = 'buffers,curdir,tabpages,winsize'
opt.shiftround = true
opt.shiftwidth = indent
opt.shortmess:append 'a'
opt.shortmess:append 'c'
opt.showbreak = '↳ '
opt.listchars = { tab = [[]→\]], eol = '↵', trail = '·', extends = '↷', precedes = '↶' }
opt.showmode = false
opt.signcolumn = 'yes'
opt.smartcase = true
opt.smartindent = true
opt.splitbelow = true
-- opt.splitright = true
opt.tabstop = indent
opt.termguicolors = true
opt.undofile = true
opt.updatetime = 250
opt.virtualedit = 'all'
opt.wildignorecase = true

if vim.fn.executable 'fish' > 0 then
  opt.shell = '/usr/bin/fish'
end

if vim.fn.executable 'rg' > 0 then
  opt.grepprg = 'rg --vimgrep --smart-case --hidden --glob=!.git'
end
