local fmt = string.format

vim.api.nvim_create_autocmd('User', {
  pattern = { 'OperatrSandwichAddPre', 'OperatorSandwichReplacePre' },
  command = 'NoMatchParen',
  desc = 'disable matchup',
})

vim.api.nvim_create_autocmd('User', {
  pattern = { 'OperatorSandwichAddPost', 'OperatorSandwichReplacePost' },
  command = 'DoMatchParen',
  desc = 're-enable matchup',
})

-- keep cursor position
vim.fn['operator#sandwich#set']('all', 'all', 'cursor', 'keep')
-- do not highlight target when operating delete action
vim.fn['operator#sandwich#set']('delete', 'all', 'highlight', 0)
vim.fn['textobj#sandwich#set']('all', 'skip_break', 1)

vim.g['sandwich#recipes'] =
  vim.tbl_extend(
    'force',
    vim.deepcopy(vim.g['sandwich#default_recipes']),
    {
      {
        buns = { '${', '}' },
        filetype = {
          'sh',
          'javascript',
          'typescript',
          'javascriptreact',
          'typescriptreact',
        },
        input = { '$' },
      },
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
    }
  )

local map = vim.keymap.set
map({ 'n', 'x' }, 's', '<Nop>')
map('n', '.', '<Plug>(operator-sandwich-dot)')

for _, v in ipairs { '(', ')', '[', ']', '{', '}', "'", '"', '`', 'f' } do
  map('n', fmt('s%s', v), fmt('<Plug>(operator-sandwich-add-query1st)%s', v))
  map('x', fmt('s%s', v), fmt('<Plug>(operator-sandwich-add)%s', v))
end

map({ 'o', 'x' }, 'im', '<Plug>(textobj-sandwich-literal-query-i)')
map({ 'o', 'x' }, 'am', '<Plug>(textobj-sandwich-literal-query-a)')
