local ok = prequire('tint')
if not ok then
  return
end

require('tint').setup({
  highlight_ignore_patterns = {
    'WinSeparator',
    'Status.*',
  },
  window_ignore_function = function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      return true
    end
    if vim.bo[buf].buftype == 'terminal' then
      return true
    end
    if vim.tbl_contains({ 'qf', 'DiffviewFiles', 'DiffviewFileHistory' }, vim.bo[buf].filetype) then
      return true
    end
    if vim.wo[win].diff then
      return true
    end
    return false
  end,
})
