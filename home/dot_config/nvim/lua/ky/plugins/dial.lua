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
    require('dial.config').augends:register_group({
      default = {
        augend.constant.alias.bool,
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.date.new({
          pattern = '%Y/%m/%d',
          default_kind = 'day',
        }),
        augend.date.new({
          pattern = '%Y-%m-%d',
          default_kind = 'day',
        }),
        augend.date.new({
          pattern = '%m/%d',
          default_kind = 'day',
          only_valid = true,
        }),
        augend.date.new({
          pattern = '%H:%M',
          default_kind = 'day',
          only_valid = false,
        }),
        augend.constant.alias.ja_weekday_full,
      },
    })
  end,
}
