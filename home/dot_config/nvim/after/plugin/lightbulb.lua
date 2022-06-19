local ok = prequire('nvim-lightbulb')
if not ok then
  return
end

require('nvim-lightbulb').setup {
  autocmd = { enabled = true },
}
