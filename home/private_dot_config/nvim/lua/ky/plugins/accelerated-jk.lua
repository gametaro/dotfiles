return {
  'rainbowhxch/accelerated-jk.nvim',
  init = function()
    for _, v in ipairs({ 'j', 'k' }) do
      vim.keymap.set('n', v, function()
        if vim.v.count == 0 then
          require('accelerated-jk').move_to('g' .. v)
        else
          require('accelerated-jk').move_to(v)
        end
      end, { desc = 'Accelerated ' .. v })
    end
  end,
}
