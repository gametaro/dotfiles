return {
  'NeogitOrg/neogit',
  dependencies = 'nvim-lua/plenary.nvim',
  cmd = 'Neogit',
  init = function()
    vim.keymap.set('n', '<Leader>gg', vim.cmd.Neogit)
  end,
  config = function()
    local group = vim.api.nvim_create_augroup('Neogit', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'NeogitStatus',
      callback = function()
        vim.wo.list = false
      end,
    })

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'NeogitCommitMessage',
      callback = function()
        local win = vim.api.nvim_get_current_win()
        vim.win[win][0].spell = true
        vim.win[win][0].formatoptions:append({ 't' })
        vim.bo.textwidth = 72
      end,
    })

    require('neogit').setup({
      disable_builtin_notifications = true,
      disable_commit_confirmation = true,
      disable_hint = true,
      disable_insert_on_commit = false,
      integrations = { diffview = true },
    })
  end,
}
