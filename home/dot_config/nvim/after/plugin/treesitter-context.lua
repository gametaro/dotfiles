local ok = prequire('treesitter-context')
if not ok then
  return
end

require('treesitter-context').setup()
