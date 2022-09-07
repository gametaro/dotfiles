local ok = prequire('tint')
if not ok then
  return
end

require('tint').setup({
  highlight_ignore_patterns = {
    'WinSeparator',
    'Status.*',
  },
  window_ignore_function = function(win_id)
    if vim.wo[win_id].diff then
      return true
    end
  end,
})
