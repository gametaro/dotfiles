local fmt = string.format

-- disable matchup when operating sandwich
vim.cmd([[autocmd User OperatrSandwichAddPre,OperatorSandwichReplacePre NoMatchParen]])
vim.cmd([[autocmd User OperatorSandwichAddPost,OperatorSandwichReplacePost DoMatchParen]])

vim.cmd([=[
      augroup mine_sandwich
        autocmd!
        autocmd FileType python call sandwich#util#addlocal([
          \   {'buns': ['"""', '"""'], 'nesting': 0, 'input': ['3"']},
          \ ])
        autocmd FileType sh call sandwich#util#addlocal([
          \   {'buns': ['$(', ')'], 'nesting': 0, 'input': ['$(']},
          \   {'buns': ['"$', '"'], 'nesting': 0, 'input': ['$"']},
          \   {'buns': ['${', '}'], 'nesting': 0, 'input': ['${']},
          \   {'buns': ['[[', ']]'], 'nesting': 0, 'input': ['2[', '2]']},
          \ ])
        autocmd FileType lua call sandwich#util#addlocal([
          \   {'buns': ['[[', ']]'], 'nesting': 0, 'input': ['2[', '2]']},
          \ ])
        autocmd FileType javascript,typescript,javascriptreact,typescriptreact call sandwich#util#addlocal([
          \   {'buns': ['${', '}'], 'nesting': 0, 'input': ['$']},
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

for _, v in ipairs { '(', ')', '[', ']', '{', '}', "'", '"', '`', 'f' } do
  map('n', fmt('s%s', v), fmt('<Plug>(operator-sandwich-add-query1st)%s', v))
  map('x', fmt('s%s', v), fmt('<Plug>(operator-sandwich-add)%s', v))
end

map({ 'o', 'x' }, 'im', '<Plug>(textobj-sandwich-literal-query-i)')
map({ 'o', 'x' }, 'am', '<Plug>(textobj-sandwich-literal-query-a)')

-- keep cursor position
vim.fn['operator#sandwich#set']('all', 'all', 'cursor', 'keep')
-- do not highlight target when operating delete action
vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
vim.fn['textobj#sandwich#set']('all', 'skip_break', 1)
