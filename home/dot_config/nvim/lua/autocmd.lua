local cmd = vim.cmd

cmd [[
augroup mine
autocmd!
augroup END
]]

-- automatically open the quickfix window
cmd [[
autocmd mine QuickFixCmdPost [^l]* nested cwindow
autocmd mine QuickFixCmdPost l* nested lwindow
]]

-- close with "q"
local close_filetypes = { 'help', 'capture', 'lspinfo', 'vim', 'qf' }
cmd(string.format('autocmd mine FileType %s nnoremap <buffer> q <C-w>c', table.concat(close_filetypes, ',')))

-- highlight on yank
cmd 'autocmd mine TextYankPost * lua vim.highlight.on_yank {higroup = "Search", timeout = 250}'

-- configure VIM to run chezmoi apply whenever a dotfile is saved
cmd 'autocmd mine BufWritePost ~/.local/share/chezmoi/* silent !chezmoi apply --source-path %'

-- tweak some colors
cmd 'autocmd mine ColorScheme * highlight DiffDelete guifg=#725272 gui = bold'

-- show cursor line only in active window
cmd [[
autocmd mine InsertLeave,WinEnter * set cursorline
autocmd mine InsertEnter,WinLeave * set nocursorline
]]

-- PackerCompile on save
-- cmd 'autocmd mine BufWritePost */lua/*.lua source <afile> | PackerCompile'

-- always jump to the last cursor position
cmd [[
autocmd mine BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]]

cmd 'autocmd mine FocusLost * wall'
cmd 'autocmd mine BufLeave * lua if require"utils".can_save() then vim.cmd "silent! update" end'

cmd 'autocmd mine BufWritePost * if &diff | diffupdate | endif'

cmd 'autocmd mine FileType qf set nobuflisted'

-- cmd 'autocmd mine CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics { focusable = false }'
