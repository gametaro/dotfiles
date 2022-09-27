local ok = prequire('hlslens')
if not ok then
  return
end

for _, v in ipairs({ 'n', 'N' }) do
  vim.keymap.set('n', v, function()
    local ok, msg = pcall(vim.cmd.normal, { vim.v.count1 .. v, bang = true })
    if ok then
      require('hlslens').start()
    else
      vim.notify(msg, vim.log.levels.INFO, { title = 'nvim-hlslens' })
    end
  end)
end
vim.keymap.set('', '*', '<Plug>(asterisk-z*)<Cmd>lua require("hlslens").start()<CR>')
vim.keymap.set('', '#', '<Plug>(asterisk-z#)<Cmd>lua require("hlslens").start()<CR>')
vim.keymap.set('', 'g*', '<Plug>(asterisk-gz*)<Cmd>lua require("hlslens").start()<CR>')
vim.keymap.set('', 'g#', '<Plug>(asterisk-gz#)<Cmd>lua require("hlslens").start()<CR>')

require('hlslens').setup({ calm_down = true })
