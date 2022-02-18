local g, opt = vim.g, vim.opt
local indent = 2

opt.autowriteall = true
opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.confirm = true
opt.diffopt = {
  'algorithm:histogram',
  'closeoff',
  'filler',
  'indent-heuristic',
  'internal',
  'vertical',
}
opt.expandtab = true
opt.fileformat = 'unix'
opt.fileformats = {
  'unix',
  'dos',
  'mac',
}
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
-- opt.modeline = false
-- opt.mouse = 'a'
opt.number = true
opt.pumheight = 10
opt.relativenumber = true
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

-- see https://github.com/kevinhwang91/nvim-bqf#customize-quickfix-window-easter-egg
function _G.qftf(info)
  local items
  local ret = {}
  if info.quickfix == 1 then
    items = fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end
  local limit = 31
  local fname_fmt1, fname_fmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local valid_fmt = '%s │%5d:%-3d│%s %s'
  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str
    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fname_fmt1:format(fname)
        else
          fname = fname_fmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col
      local qtype = e.type == '' and '' or ' ' .. e.type:sub(1, 1):upper()
      str = valid_fmt:format(fname, lnum, col, qtype, e.text)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.opt.quickfixtextfunc = '{info -> v:lua._G.qftf(info)}'

if vim.fn.executable('fish') > 0 then
  opt.shell = '/usr/bin/fish'
end

if vim.fn.executable('rg') > 0 then
  opt.grepprg = 'rg --vimgrep --smart-case --hidden --glob=!.git'
end

-- neovide
if vim.fn.exists('g:neovide') > 0 then
  g.neovide_cursor_animation_length = 0
  g.neovide_cursor_trail_length = 0
  opt.guifont = 'FiraCode NF:style=Regular:h11'
end
