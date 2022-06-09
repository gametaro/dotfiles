require('project_nvim').setup {
  manual_mode = true,
  ignore_lsp = { 'null-ls' },
}
require('telescope').load_extension('projects')
vim.keymap.set('n', '<LocalLeader>fp', '<Cmd>Telescope projects<CR>')

local group = vim.api.nvim_create_augroup('ProjectCd', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  group = group,
  callback = function()
    if vim.tbl_contains({ 'nofile', 'prompt' }, vim.bo.buftype) then
      return
    end
    if vim.tbl_contains({ 'help', 'qf' }, vim.bo.filetype) then
      return
    end
    local ok, project = prequire('project_nvim.project')
    if ok then
      local root = project.get_project_root()
      if root and vim.loop.cwd() ~= root then
        vim.api.nvim_cmd({
          cmd = 'tcd',
          args = { root },
          mods = {
            silent = true,
          },
        }, {})
      end
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    require('project_nvim.utils.history').write_projects_to_history()
  end,
})
