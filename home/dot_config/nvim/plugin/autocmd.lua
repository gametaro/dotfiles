local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_command
local fn = vim.fn

local group = augroup('mine', { clear = true })

autocmd('QuickFixCmdPost', {
  group = group,
  pattern = '[^l]*',
  nested = true,
  callback = function()
    cmd('cwindow')
  end,
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  group = group,
  pattern = 'l*',
  nested = true,
  callback = function()
    cmd('lwindow')
  end,
  desc = 'automatically open the location list window',
})

autocmd('FileType', {
  group = group,
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, nowait = true })
  end,
  desc = 'close with `q`',
})

autocmd('TextYankPost', {
  group = group,
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 150 }
  end,
  desc = 'highlight on yank',
})

autocmd('BufWritePost', {
  group = group,
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
  group = group,
  callback = function()
    autocmd('FileType', {
      buffer = 0,
      once = true,
      callback = function(t)
        local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
        if
          not vim.tbl_contains({ 'gitcommit', 'gitrebase', 'NeogitCommitMessage' }, t.match)
          and { row, col } ~= { 1, 0 }
        then
          vim.api.nvim_win_set_cursor(0, { row, col })
        end
      end,
    })
  end,
  desc = 'always jump to the last cursor position. see :help restore-cursor',
})

autocmd('FocusLost', {
  group = group,
  nested = true,
  callback = function()
    cmd('silent! wall')
  end,
})

autocmd('BufLeave', {
  group = group,
  callback = function()
    if vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable then
      cmd('silent! update')
    end
  end,
})

autocmd({ 'FocusGained', 'WinEnter' }, {
  group = group,
  callback = function()
    cmd('silent! checktime')
  end,
})

autocmd('BufWritePost', {
  group = group,
  callback = function()
    if vim.wo.diff then
      cmd('diffupdate')
    end
  end,
})

autocmd('VimResized', {
  group = group,
  callback = function()
    cmd('wincmd =')
  end,
})

autocmd('TermOpen', {
  group = group,
  pattern = 'term://*',
  callback = function()
    cmd('startinsert')
  end,
})

autocmd('TermOpen', {
  group = group,
  pattern = 'term://*',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

autocmd({ 'TermEnter', 'TermLeave' }, {
  group = group,
  pattern = 'term://*',
  callback = function()
    vim.api.nvim_buf_set_var(0, 'term_mode', vim.api.nvim_get_mode().mode)
  end,
})

autocmd('BufEnter', {
  group = group,
  pattern = 'term://*',
  callback = function()
    local ok, term_mode = pcall(vim.api.nvim_buf_get_var, 0, 'term_mode')
    if ok and term_mode == 't' then
      cmd('startinsert')
    end
  end,
})

autocmd('BufEnter', {
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove {
      'c',
      'o',
      'r',
    }
  end,
})

autocmd('BufWritePre', {
  group = group,
  callback = function()
    local dir = fn.expand('<afile>:p:h')
    if fn.isdirectory(dir) == 0 then
      fn.mkdir(dir, 'p')
    end
  end,
})
