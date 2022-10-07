local ok = prequire('live-command')
if not ok then
  return
end

require('live-command').setup({
  commands = {
    Norm = { cmd = 'norm' },
  },
})
