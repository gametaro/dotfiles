local ok = prequire('illuminate')
if not ok then
  return
end

require('illuminate').configure({
  modes_denylist = { 'i' },
})
