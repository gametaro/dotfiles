local ok = prequire('project_nvim')
if not ok then
  return
end

require('project_nvim').setup({
  manual_mode = true,
  ignore_lsp = { 'null-ls' },
})
require('telescope').load_extension('projects')
vim.keymap.set('n', '<LocalLeader>fp', '<Cmd>Telescope projects<CR>')

local group = vim.api.nvim_create_augroup('mine__project', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  group = group,
  nested = true,
  callback = function()
    if vim.tbl_contains({ 'nofile', 'prompt' }, vim.bo.buftype) then
      return
    end
    if vim.tbl_contains({ 'help', 'qf' }, vim.bo.filetype) then
      return
    end
    local root = require('project_nvim.project').get_project_root()
    if root then
      vim.cmd.tcd({ root, mods = { silent = true } })
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    require('project_nvim.utils.history').write_projects_to_history()
  end,
})
