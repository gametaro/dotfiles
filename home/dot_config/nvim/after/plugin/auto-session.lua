local ok = prequire('auto-session')
if not ok then
  return
end

require('auto-session').setup({
  log_level = 'error',
})
