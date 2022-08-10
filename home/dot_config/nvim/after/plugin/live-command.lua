local ok = prequire('live_command')
if not ok then
  return
end

require('live_command').setup({
  commands = {
    Norm = { cmd = 'norm' },
  },
})
