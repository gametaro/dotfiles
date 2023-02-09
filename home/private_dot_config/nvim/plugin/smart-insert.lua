for _, v in ipairs({ 'i', 'A' }) do
  vim.keymap.set('n', v, function()
    local line = vim.trim(vim.api.nvim_get_current_line())
    if line:len() ~= 0 or vim.bo.buftype == 'terminal' then
      return v
    end
    return '"_cc'
  end, { expr = true, desc = string.format('Linewise %s', v) })
end
