vim.cmd [[
augroup mine
autocmd!
augroup END
]]

-- automatically open the quickfix window
vim.cmd [[
autocmd mine QuickFixCmdPost [^l]* nested cwindow
autocmd mine QuickFixCmdPost l* nested lwindow
]]

-- close with "q"
local close_filetypes = { 'help', 'capture', 'lspinfo', 'qf', 'null-ls-info', 'scratch' }
vim.cmd(
  string.format('autocmd mine FileType %s nnoremap <buffer> <nowait> q <C-w>c', table.concat(close_filetypes, ','))
)

-- highlight on yank
vim.cmd 'autocmd mine TextYankPost * lua vim.highlight.on_yank {higroup = "Search", timeout = 250}'

-- configure VIM to run chezmoi apply whenever a dotfile is saved
vim.cmd 'autocmd mine BufWritePost ~/.local/share/chezmoi/* silent !chezmoi apply --source-path %'

-- -- show cursor line only in active window
-- vim.cmd [[
-- autocmd mine InsertLeave,WinEnter * set cursorline
-- autocmd mine InsertEnter,WinLeave * set nocursorline
-- ]]

-- PackerCompile on save
-- vim.cmd 'autocmd mine BufWritePost */lua/*.lua source <afile> | PackerCompile'

-- always jump to the last cursor position
vim.cmd [[autocmd mine BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]]

vim.cmd 'autocmd mine FocusLost * nested silent! wall'
vim.cmd 'autocmd mine BufLeave * lua if require"ky.utils".can_save() then vim.cmd "silent! update" end'

vim.cmd 'autocmd mine FocusGained,WinEnter * silent! checktime'
vim.cmd 'autocmd mine BufWritePost * if &diff | diffupdate | endif'
vim.cmd 'autocmd mine VimResized * wincmd ='

vim.cmd 'autocmd mine FileType qf set nobuflisted'

-- vim.cmd 'autocmd mine CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics { focusable = false }'
vim.cmd 'autocmd mine TermOpen term://* startinsert'
vim.cmd 'autocmd mine TermOpen term://* setlocal nonumber norelativenumber'

vim.cmd 'autocmd mine BufEnter * setlocal formatoptions-=cro'
