return {
  'monaqa/dial.nvim',
  keys = {
    { '<C-a>', '<Plug>(dial-increment)', mode = { 'n', 'x' } },
    { '<C-x>', '<Plug>(dial-decrement)', mode = { 'n', 'x' } },
    { 'g<C-a>', 'g<Plug>(dial-increment)', mode = { 'n', 'x' } },
    { 'g<C-x>', 'g<Plug>(dial-decrement)', mode = { 'n', 'x' } },
  },
  config = function()
    local augend = require('dial.augend')

    require('dial.config').augends:on_filetype({
      lua = {
        augend.paren.alias.lua_str_literal,
        augend.constant.new({
          elements = { 'and', 'or' },
        }),
        augend.constant.new({
          elements = { 'pairs', 'ipairs' },
        }),
      },
      python = {
        augend.constant.new({
          elements = { 'True', 'False' },
        }),
      },
      typescript = {
        augend.constant.new({
          elements = { 'let', 'const' },
        }),
        augend.constant.new({
          elements = { '&&', '||', '??' },
        }),
        augend.constant.new({
          elements = { 'console.log', 'console.warn', 'console.error' },
        }),
      },
      markdown = {
        augend.misc.alias.markdown_header,
      },
      gitcommit = {
        augend.constant.new({
          elements = { 'fix', 'feat', 'chore', 'refactor', 'ci' },
        }),
      },
      gitrebase = {
        augend.constant.new({
          elements = { 'pick', 'squash', 'edit', 'reword', 'fixup', 'drop' },
        }),
      },
    })
  end,
}
