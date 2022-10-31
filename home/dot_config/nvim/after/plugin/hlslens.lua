local ok = prequire('hlslens') and prequire('mini.map')
if not ok then
  return
end

local map = {
  ['n'] = 'n',
  ['N'] = 'N',
  ['*'] = 'z*',
  ['#'] = 'z#',
  ['g*'] = 'gz*',
  ['g#'] = 'gz#',
}

for k, v in pairs(map) do
  vim.keymap.set({ 'n', 'x' }, k, function()
    if vim.tbl_contains({ 'n', 'N' }, k) then
      vim.cmd.normal({ vim.v.count1 .. k, bang = true })
    else
      vim.cmd.execute(string.format([["normal \<Plug>(asterisk-%s)"]], v))
    end
    require('hlslens').start()
    require('mini.map').refresh({}, { lines = false, scrollbar = false })
  end)
end

require('hlslens').setup({ calm_down = true })
