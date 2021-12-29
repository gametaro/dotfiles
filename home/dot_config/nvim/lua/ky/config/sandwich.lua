-- disable matchup when operating sandwich
vim.cmd [[autocmd User OperatrSandwichAddPre,OperatorSandwichReplacePre NoMatchParen]]
vim.cmd [[autocmd User OperatorSandwichAddPost,OperatorSandwichReplacePost DoMatchParen]]

vim.cmd [[
      augroup mine_sandwich
      autocmd!
      augroup END
      ]]
-- NOTE: `4` means `$`
vim.cmd [=[
        autocmd mine_sandwich FileType python call sandwich#util#addlocal([
          \   {'buns': ['"""', '"""'], 'nesting': 0, 'input': ['3"']},
          \ ])
        autocmd mine_sandwich FileType sh call sandwich#util#addlocal([
          \   {'buns': ['$(', ')'], 'nesting': 0, 'input': ['4(']},
          \   {'buns': ['"$', '"'], 'nesting': 0, 'input': ['"4']},
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
      ]=]

local map = vim.api.nvim_set_keymap
map('n', '.', '<Plug>(operator-sandwich-dot)', {})
map('n', 's(', '<Plug>(operator-sandwich-add-query1st)(', {})
map('x', 's(', '<Plug>(operator-sandwich-add)(', {})
map('n', 's9', '<Plug>(operator-sandwich-add-query1st)(', {})
map('x', 's9', '<Plug>(operator-sandwich-add)(', {})
map('n', 's)', '<Plug>(operator-sandwich-add-query1st))', {})
map('x', 's)', '<Plug>(operator-sandwich-add))', {})
map('n', 's0', '<Plug>(operator-sandwich-add-query1st))', {})
map('x', 's0', '<Plug>(operator-sandwich-add))', {})
map('n', 's[', '<Plug>(operator-sandwich-add-query1st)[', {})
map('x', 's[', '<Plug>(operator-sandwich-add)[', {})
map('n', 's]', '<Plug>(operator-sandwich-add-query1st)]', {})
map('x', 's]', '<Plug>(operator-sandwich-add)]', {})
map('n', 's{', '<Plug>(operator-sandwich-add-query1st){', {})
map('x', 's{', '<Plug>(operator-sandwich-add){', {})
map('n', 's}', '<Plug>(operator-sandwich-add-query1st)}', {})
map('x', 's}', '<Plug>(operator-sandwich-add)}', {})
map('n', "s'", "<Plug>(operator-sandwich-add-query1st)'", {})
map('x', "s'", "<Plug>(operator-sandwich-add)'", {})
map('n', 's"', '<Plug>(operator-sandwich-add-query1st)"', {})
map('x', 's"', '<Plug>(operator-sandwich-add)"', {})
map('n', 's`', '<Plug>(operator-sandwich-add-query1st)`', {})
map('x', 's`', '<Plug>(operator-sandwich-add)`', {})
map('n', 'sf', '<Plug>(operator-sandwich-add-query1st)f', {})
map('x', 'sf', '<Plug>(operator-sandwich-add)f', {})

map('o', 'im', '<Plug>(textobj-sandwich-literal-query-i)', {})
map('x', 'im', '<Plug>(textobj-sandwich-literal-query-i)', {})
map('o', 'am', '<Plug>(textobj-sandwich-literal-query-a)', {})
map('x', 'am', '<Plug>(textobj-sandwich-literal-query-a)', {})

-- keep cursor position
vim.cmd [[call operator#sandwich#set('all', 'all', 'cursor', 'keep')]]
-- do not highlight target when operating delete action
vim.cmd [[call operator#sandwich#set('delete', 'all', 'highlight', 0)]]
vim.cmd [[call textobj#sandwich#set('all', 'skip_break', 1)]]

vim.cmd [[
  let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
  \   {'buns': ['/', '/'], 'nesting': 0, 'input': ['/']},
  \ ]
]]
