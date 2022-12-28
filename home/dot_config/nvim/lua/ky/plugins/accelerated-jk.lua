return {
  'rainbowhxch/accelerated-jk.nvim',
  keys = { 'j', 'k' },
  config = function()
    for _, v in ipairs({ 'j', 'k' }) do
      vim.keymap.set('n', v, function()
        return vim.v.count == 0 and string.format('<Plug>(accelerated_jk_g%s)', v)
          or string.format('<Plug>(accelerated_jk_%s)', v)
      end, { expr = true })
    end
  end,
}
