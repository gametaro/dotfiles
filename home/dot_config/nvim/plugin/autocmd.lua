local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup {
  name = 'mine',
  clear = true, -- default
}

autocmd {
  group = 'mine',
  event = 'QuickFixCmdPost',
  pattern = '[^l]*',
  nested = true,
  command = 'cwindow',
  desc = 'automatically open the quickfix window',
}

autocmd {
  group = 'mine',
  event = 'QuickFixCmdPost',
  pattern = 'l*',
  nested = true,
  command = 'lwindow',
  desc = 'automatically open the location list window',
}

autocmd {
  group = 'mine',
  event = 'FileType',
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, nowait = true })
  end,
  desc = 'close with `q`',
}

autocmd {
  group = 'mine',
  event = 'TextYankPost',
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 200 }
  end,
  desc = 'highlight on yank',
}

autocmd {
  group = 'mine',
  event = 'BufWritePost',
  pattern = '**/.local/share/chezmoi/*',
  command = 'silent !chezmoi apply --source-path %',
  desc = 'run chezmoi apply whenever a dotfile is saved',
}

-- -- show cursor line only in active window
-- vim.cmd [[
-- autocmd mine InsertLeave,WinEnter * set cursorline
-- autocmd mine InsertEnter,WinLeave * set nocursorline
-- ]]

-- PackerCompile on save
-- vim.cmd 'autocmd mine BufWritePost */lua/*.lua source <afile> | PackerCompile'

autocmd {
  group = 'mine',
  event = 'BufReadPost',
  command = [[if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
  desc = 'always jump to the last cursor position',
}

autocmd {
  group = 'mine',
  event = 'FocusLost',
  nested = true,
  command = 'silent! wall',
}

autocmd {
  group = 'mine',
  event = 'BufLeave',
  callback = function()
    if vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable then
      vim.cmd('silent! update')
    end
  end,
}

autocmd {
  group = 'mine',
  event = { 'FocusGained', 'WinEnter' },
  command = 'silent! checktime',
}

autocmd {
  group = 'mine',
  event = 'BufWritePost',
  command = 'if &diff | diffupdate | endif',
}

autocmd {
  group = 'mine',
  event = 'VimResized',
  command = 'wincmd =',
}

autocmd {
  group = 'mine',
  event = 'TermOpen',
  pattern = 'term://*',
  command = 'startinsert',
}

autocmd {
  group = 'mine',
  event = 'TermOpen',
  pattern = 'term://*',
  command = 'setlocal nonumber norelativenumber',
}

autocmd {
  group = 'mine',
  event = { 'TermEnter', 'TermLeave' },
  pattern = 'term://*',
  callback = function()
    vim.api.nvim_buf_set_var(0, 'term_mode', vim.api.nvim_get_mode().mode)
  end,
}

autocmd {
  group = 'mine',
  event = 'BufEnter',
  pattern = 'term://*',
  callback = function()
    local ok, term_mode = pcall(vim.api.nvim_buf_get_var, 0, 'term_mode')
    if ok and term_mode == 't' then
      vim.cmd('startinsert')
    end
  end,
}

autocmd {
  group = 'mine',
  event = 'BufEnter',
  command = 'setlocal formatoptions-=cro',
}
