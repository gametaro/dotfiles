return {
  'rainbowhxch/accelerated-jk.nvim',
  init = function()
    vim.iter({ 'j', 'k' }):each(function(v)
      vim.keymap.set('n', v, function()
        if vim.v.count == 0 then
          require('accelerated-jk').move_to('g' .. v)
        else
          require('accelerated-jk').move_to(v)
        end
      end, { desc = 'Accelerated ' .. v })
    end)
  end,
}
