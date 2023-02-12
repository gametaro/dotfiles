for _, v in ipairs({ 'i', 'A' }) do
  vim.keymap.set('n', v, function()
    if vim.bo.buftype == 'terminal' then
      return v
    end
    if not vim.fn.getline('.'):match('^%s*$') then
      return v
    end

    return '"_cc'
  end, { expr = true, desc = string.format('Linewise %s', v) })
end
