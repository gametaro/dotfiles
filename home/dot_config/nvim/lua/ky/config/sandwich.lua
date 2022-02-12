-- disable matchup when operating sandwich
vim.cmd([[autocmd User OperatrSandwichAddPre,OperatorSandwichReplacePre NoMatchParen]])
vim.cmd([[autocmd User OperatorSandwichAddPost,OperatorSandwichReplacePost DoMatchParen]])

-- NOTE: `4` means `$`
vim.cmd([=[
      augroup mine_sandwich
        autocmd!
        autocmd FileType python call sandwich#util#addlocal([
          \   {'buns': ['"""', '"""'], 'nesting': 0, 'input': ['3"']},
          \ ])
        autocmd FileType sh call sandwich#util#addlocal([
          \   {'buns': ['$(', ')'], 'nesting': 0, 'input': ['4(']},
          \   {'buns': ['"$', '"'], 'nesting': 0, 'input': ['4"']},
          \   {'buns': ['${', '}'], 'nesting': 0, 'input': ['4{']},
          \   {'buns': ['[[', ']]'], 'nesting': 0, 'input': ['2[', '2]']},
          \ ])
        autocmd FileType lua call sandwich#util#addlocal([
          \   {'buns': ['[[', ']]'], 'nesting': 0, 'input': ['2[', '2]']},
          \ ])
        autocmd FileType javascript,typescript,javascriptreact,typescriptreact call sandwich#util#addlocal([
          \   {'buns': ['${', '}'], 'nesting': 0, 'input': ['4']},
          \ ])
        autocmd FileType markdown call sandwich#util#addlocal([
          \   {'buns': ['```\a*', '```'], 'nesting': 0, 'regex': 1, 'input': ['3`']},
          \   {'buns': ['^\(#\{1,6}\s+.\+\)', '^\(#\{1,6}\s+.\+\)'], 'nesting': 0, 'regex': 1, 'input': ['#']},
          \   {'buns': ['^\(\s*\(*\|-\)\s\+\)', '\n'], 'nesting': 0, 'regex': 1, 'input': ['-']},
          \ ])
      augroup END
      ]=])

local map = vim.keymap.set
map({ 'n', 'x' }, 's', '<Nop>')
map('n', '.', '<Plug>(operator-sandwich-dot)')
map('n', 's(', '<Plug>(operator-sandwich-add-query1st)(')
map('x', 's(', '<Plug>(operator-sandwich-add)(')
map('n', 's9', '<Plug>(operator-sandwich-add-query1st)(')
map('x', 's9', '<Plug>(operator-sandwich-add)(')
map('n', 's)', '<Plug>(operator-sandwich-add-query1st))')
map('x', 's)', '<Plug>(operator-sandwich-add))')
map('n', 's0', '<Plug>(operator-sandwich-add-query1st))')
map('x', 's0', '<Plug>(operator-sandwich-add))')
map('n', 's[', '<Plug>(operator-sandwich-add-query1st)[')
map('x', 's[', '<Plug>(operator-sandwich-add)[')
map('n', 's]', '<Plug>(operator-sandwich-add-query1st)]')
map('x', 's]', '<Plug>(operator-sandwich-add)]')
map('n', 's{', '<Plug>(operator-sandwich-add-query1st){')
map('x', 's{', '<Plug>(operator-sandwich-add){')
map('n', 's}', '<Plug>(operator-sandwich-add-query1st)}')
map('x', 's}', '<Plug>(operator-sandwich-add)}')
map('n', "s'", "<Plug>(operator-sandwich-add-query1st)'")
map('x', "s'", "<Plug>(operator-sandwich-add)'")
map('n', 's"', '<Plug>(operator-sandwich-add-query1st)"')
map('x', 's"', '<Plug>(operator-sandwich-add)"')
map('n', 's`', '<Plug>(operator-sandwich-add-query1st)`')
map('x', 's`', '<Plug>(operator-sandwich-add)`')
map('n', 'sf', '<Plug>(operator-sandwich-add-query1st)f')
map('x', 'sf', '<Plug>(operator-sandwich-add)f')

map({ 'o', 'x' }, 'im', '<Plug>(textobj-sandwich-literal-query-i)')
map({ 'o', 'x' }, 'am', '<Plug>(textobj-sandwich-literal-query-a)')

-- keep cursor position
vim.fn['operator#sandwich#set']('all', 'all', 'cursor', 'keep')
-- do not highlight target when operating delete action
vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
vim.fn['textobj#sandwich#set']('all', 'skip_break', 1)
