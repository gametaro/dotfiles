local ok = prequire('git-conflict')
if not ok then
  return
end

require('git-conflict').setup()
