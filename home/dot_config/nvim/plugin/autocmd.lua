local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup('mine', { clear = true })

autocmd('QuickFixCmdPost', {
  group = 'mine',
  pattern = '[^l]*',
  nested = true,
  command = 'cwindow',
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  group = 'mine',
  pattern = 'l*',
  nested = true,
  command = 'lwindow',
  desc = 'automatically open the location list window',
})

autocmd('FileType', {
  group = 'mine',
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, nowait = true })
  end,
  desc = 'close with `q`',
})

autocmd('TextYankPost', {
  group = 'mine',
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 200 }
  end,
  desc = 'highlight on yank',
})

autocmd('BufWritePost', {
  group = 'mine',
  pattern = '**/.local/share/chezmoi/*',
  command = 'silent !chezmoi apply --source-path %',
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
  group = 'mine',
  command = [[if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
  desc = 'always jump to the last cursor position',
})

autocmd('FocusLost', {
  group = 'mine',
  nested = true,
  command = 'silent! wall',
})

autocmd('BufLeave', {
  group = 'mine',
  callback = function()
    if vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable then
      vim.cmd('silent! update')
    end
  end,
})

autocmd({ 'FocusGained', 'WinEnter' }, {
  group = 'mine',
  command = 'silent! checktime',
})

autocmd('BufWritePost', {
  group = 'mine',
  command = 'if &diff | diffupdate | endif',
})

autocmd('VimResized', {
  group = 'mine',
  command = 'wincmd =',
})

autocmd('TermOpen', {
  group = 'mine',
  pattern = 'term://*',
  command = 'startinsert',
})

autocmd('TermOpen', {
  group = 'mine',
  pattern = 'term://*',
  command = 'setlocal nonumber norelativenumber',
})

autocmd({ 'TermEnter', 'TermLeave' }, {
  group = 'mine',
  pattern = 'term://*',
  callback = function()
    vim.api.nvim_buf_set_var(0, 'term_mode', vim.api.nvim_get_mode().mode)
  end,
})

autocmd('BufEnter', {
  group = 'mine',
  pattern = 'term://*',
  callback = function()
    local ok, term_mode = pcall(vim.api.nvim_buf_get_var, 0, 'term_mode')
    if ok and term_mode == 't' then
      vim.cmd('startinsert')
    end
  end,
})

autocmd('BufEnter', {
  group = 'mine',
  command = 'setlocal formatoptions-=cro',
})
