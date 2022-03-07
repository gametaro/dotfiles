local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_command
local fn = vim.fn

local name = 'mine'

augroup(name, { clear = true })

autocmd('QuickFixCmdPost', {
  group = name,
  pattern = '[^l]*',
  nested = true,
  callback = function()
    cmd('cwindow')
  end,
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  group = name,
  pattern = 'l*',
  nested = true,
  callback = function()
    cmd('lwindow')
  end,
  desc = 'automatically open the location list window',
})

autocmd('FileType', {
  group = name,
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, nowait = true })
  end,
  desc = 'close with `q`',
})

autocmd('TextYankPost', {
  group = name,
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 200 }
  end,
  desc = 'highlight on yank',
})

autocmd('BufWritePost', {
  group = name,
  pattern = '**/.local/share/chezmoi/*',
  callback = function()
    fn.system { 'chezmoi', 'apply', '--source-path', fn.expand('%:p') }
  end,
  desc = 'run chezmoi apply whenever a dotfile is saved',
})

-- -- show cursor line only in active window
-- vim.cmd [[
-- autocmd mine InsertLeave,WinEnter * set cursorline
-- autocmd mine InsertEnter,WinLeave * set nocursorline
-- ]]

-- PackerCompile on save
-- vim.cmd 'autocmd mine BufWritePost */lua/*.lua source <afile> | PackerCompile'

autocmd('BufReadPost', {
  group = name,
  callback = function()
    autocmd('FileType', {
      buffer = 0,
      once = true,
      callback = function()
        local ft = vim.bo.ft:lower() -- for neogit
        if
          not (ft:find('commit') or (ft:find('rebase')))
          and fn.line('\'"') > 1
          and fn.line('\'"') <= fn.line('$')
        then
          cmd('normal! g`"')
        end
      end,
    })
  end,
  desc = 'always jump to the last cursor position. see :help restore-cursor',
})

autocmd('FocusLost', {
  group = name,
  nested = true,
  callback = function()
    cmd('silent! wall')
  end,
})

autocmd('BufLeave', {
  group = name,
  callback = function()
    if vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable then
      vim.cmd('silent! update')
    end
  end,
})

autocmd({ 'FocusGained', 'WinEnter' }, {
  group = name,
  callback = function()
    cmd('silent! checktime')
  end,
})

autocmd('BufWritePost', {
  group = name,
  callback = function()
    if vim.wo.diff then
      cmd('diffupdate')
    end
  end,
})

autocmd('VimResized', {
  group = name,
  callback = function()
    cmd('wincmd =')
  end,
})

autocmd('TermOpen', {
  group = name,
  pattern = 'term://*',
  callback = function()
    cmd('startinsert')
  end,
})

autocmd('TermOpen', {
  group = name,
  pattern = 'term://*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

autocmd({ 'TermEnter', 'TermLeave' }, {
  group = name,
  pattern = 'term://*',
  callback = function()
    vim.api.nvim_buf_set_var(0, 'term_mode', vim.api.nvim_get_mode().mode)
  end,
})

autocmd('BufEnter', {
  group = name,
  pattern = 'term://*',
  callback = function()
    local ok, term_mode = pcall(vim.api.nvim_buf_get_var, 0, 'term_mode')
    if ok and term_mode == 't' then
      cmd('startinsert')
    end
  end,
})

autocmd('BufEnter', {
  group = name,
  callback = function()
    vim.opt_local.formatoptions:remove {
      'c',
      'o',
      'r',
    }
  end,
})
