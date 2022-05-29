require('project_nvim').setup {
  manual_mode = true,
  ignore_lsp = { 'null-ls' },
}
require('telescope').load_extension('projects')
vim.keymap.set('n', '<LocalLeader>fp', '<Cmd>Telescope projects<CR>')

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
  group = vim.api.nvim_create_augroup('ProjectCd', { clear = true }),
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
