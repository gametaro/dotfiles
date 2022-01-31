-- disable matchup when operating sandwich
vim.cmd([[autocmd User OperatrSandwichAddPre,OperatorSandwichReplacePre NoMatchParen]])
vim.cmd([[autocmd User OperatorSandwichAddPost,OperatorSandwichReplacePost DoMatchParen]])

vim.cmd([[
      augroup mine_sandwich
      autocmd!
      augroup END
      ]])
-- NOTE: `4` means `$`
vim.cmd([=[
        autocmd mine_sandwich FileType python call sandwich#util#addlocal([
          \   {'buns': ['"""', '"""'], 'nesting': 0, 'input': ['3"']},
          \ ])
        autocmd mine_sandwich FileType sh call sandwich#util#addlocal([
          \   {'buns': ['$(', ')'], 'nesting': 0, 'input': ['4(']},
          \   {'buns': ['"$', '"'], 'nesting': 0, 'input': ['4"']},
          \   {'buns': ['${', '}'], 'nesting': 0, 'input': ['4{']},
          \   {'buns': ['[[', ']]'], 'nesting': 0, 'input': ['2[', '2]']},
          \ ])
        autocmd mine_sandwich FileType lua call sandwich#util#addlocal([
          \   {'buns': ['[[', ']]'], 'nesting': 0, 'input': ['2[', '2]']},
          \ ])
        autocmd mine_sandwich FileType javascript,typescript,javascriptreact,typescriptreact call sandwich#util#addlocal([
          \   {'buns': ['${', '}'], 'nesting': 0, 'input': ['4']},
          \ ])
        autocmd mine_sandwich FileType markdown call sandwich#util#addlocal([
          \   {'buns': ['```\a*', '```'], 'nesting': 0, 'regex': 1, 'input': ['3`']},
          \   {'buns': ['^\(#\{1,6}\s+.\+\)', '^\(#\{1,6}\s+.\+\)'], 'nesting': 0, 'regex': 1, 'input': ['#']},
          \   {'buns': ['^\(\s*\(*\|-\)\s\+\)', '\n'], 'nesting': 0, 'regex': 1, 'input': ['-']},
          \ ])
      ]=])

vim.keymap.set('n', '.', '<Plug>(operator-sandwich-dot)')
vim.keymap.set('n', 's(', '<Plug>(operator-sandwich-add-query1st)(')
vim.keymap.set('x', 's(', '<Plug>(operator-sandwich-add)(')
vim.keymap.set('n', 's9', '<Plug>(operator-sandwich-add-query1st)(')
vim.keymap.set('x', 's9', '<Plug>(operator-sandwich-add)(')
vim.keymap.set('n', 's)', '<Plug>(operator-sandwich-add-query1st))')
vim.keymap.set('x', 's)', '<Plug>(operator-sandwich-add)(')
vim.keymap.set('n', 's0', '<Plug>(operator-sandwich-add-query1st))')
vim.keymap.set('x', 's0', '<Plug>(operator-sandwich-add))')
vim.keymap.set('n', 's[', '<Plug>(operator-sandwich-add-query1st)[')
vim.keymap.set('x', 's[', '<Plug>(operator-sandwich-add)[')
vim.keymap.set('n', 's]', '<Plug>(operator-sandwich-add-query1st)]')
vim.keymap.set('x', 's]', '<Plug>(operator-sandwich-add)]')
vim.keymap.set('n', 's{', '<Plug>(operator-sandwich-add-query1st){')
vim.keymap.set('x', 's{', '<Plug>(operator-sandwich-add){')
vim.keymap.set('n', 's}', '<Plug>(operator-sandwich-add-query1st)}')
vim.keymap.set('x', 's}', '<Plug>(operator-sandwich-add)}')
vim.keymap.set('n', "s'", "<Plug>(operator-sandwich-add-query1st)'")
vim.keymap.set('x', "s'", "<Plug>(operator-sandwich-add)'")
vim.keymap.set('n', 's"', '<Plug>(operator-sandwich-add-query1st)"')
vim.keymap.set('x', 's"', '<Plug>(operator-sandwich-add)"')
vim.keymap.set('n', 's`', '<Plug>(operator-sandwich-add-query1st)`')
vim.keymap.set('x', 's`', '<Plug>(operator-sandwich-add)`')
vim.keymap.set('n', 'sf', '<Plug>(operator-sandwich-add-query1st)f')
vim.keymap.set('x', 'sf', '<Plug>(operator-sandwich-add)f')

vim.keymap.set({ 'o', 'x' }, 'im', '<Plug>(textobj-sandwich-literal-query-i)')
vim.keymap.set({ 'o', 'x' }, 'am', '<Plug>(textobj-sandwich-literal-query-a)')

-- keep cursor position
vim.fn['operator#sandwich#set']('all', 'all', 'cursor', 'keep')
-- do not highlight target when operating delete action
vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
vim.fn['textobj#sandwich#set']('all', 'skip_break', 1)

vim.cmd([[
  let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
  \   {'buns': ['/', '/'], 'nesting': 0, 'input': ['/']},
  \ ]
]])
