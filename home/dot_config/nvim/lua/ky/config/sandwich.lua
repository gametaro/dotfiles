local fmt = string.format

-- disable matchup when operating sandwich
vim.cmd([[autocmd User OperatrSandwichAddPre,OperatorSandwichReplacePre NoMatchParen]])
vim.cmd([[autocmd User OperatorSandwichAddPost,OperatorSandwichReplacePost DoMatchParen]])

-- keep cursor position
vim.fn['operator#sandwich#set']('all', 'all', 'cursor', 'keep')
-- do not highlight target when operating delete action
vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
vim.fn['textobj#sandwich#set']('all', 'skip_break', 1)

vim.g['sandwich#recipes'] = vim.tbl_extend('force', vim.g['sandwich#default_recipes'], {
  {
    buns = { '**', '**' },
    nesting = 0,
    filetype = { 'markdown' },
    input = { '2*' },
  },
  {
    buns = { '***', '***' },
    nesting = 0,
    filetype = { 'markdown' },
    input = { '3*' },
  },
  {
    buns = { '```\a*', '```' },
    nesting = 0,
    regex = 1,
    filetype = { 'markdown' },
    input = { '3`' },
  },
  {
    buns = { [[^\(#\{1,6}\s+.\+\)]], [[^\(#\{1,6}\s+.\+\)]] },
    nesting = 0,
    regex = 1,
    filetype = { 'markdown' },
    input = {
      '#',
    },
  },
  {
    buns = { [[^\(\s*\(*\|-\)\s\+\)]], '\n' },
    nesting = 0,
    regex = 1,
    filetype = { 'markdown' },
    input = { '-' },
  },
  {
    buns = { '"""', '"""' },
    nesting = 0,
    filetype = { 'python' },
    input = { '3"' },
  },
  {
    buns = { '$(', ')' },
    nesting = 0,
    filetype = { 'sh' },
    input = { '$(' },
  },
  {
    buns = { '"$', '"' },
    nesting = 0,
    filetype = { 'sh' },
    input = { '$"' },
  },
  {
    buns = { '${', '}' },
    nesting = 0,
    filetype = { 'sh', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    input = { '${' },
  },
  {
    buns = { '[[', ']]' },
    nesting = 0,
    filetype = { 'sh', 'lua' },
    input = { '2[', '2]' },
  },
})

local map = vim.keymap.set
map({ 'n', 'x' }, 's', '<Nop>')
map('n', '.', '<Plug>(operator-sandwich-dot)')

for _, v in ipairs { '(', ')', '[', ']', '{', '}', "'", '"', '`', 'f' } do
  map('n', fmt('s%s', v), fmt('<Plug>(operator-sandwich-add-query1st)%s', v))
  map('x', fmt('s%s', v), fmt('<Plug>(operator-sandwich-add)%s', v))
end

map({ 'o', 'x' }, 'im', '<Plug>(textobj-sandwich-literal-query-i)')
map({ 'o', 'x' }, 'am', '<Plug>(textobj-sandwich-literal-query-a)')
