return {
  'TimUntersberger/neogit',
  cmd = 'Neogit',
  init = function()
    vim.keymap.set('n', '<LocalLeader>gg', vim.cmd.Neogit)
  end,
  config = function()
    local group = vim.api.nvim_create_augroup('NeogitFileType', { clear = true })

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
        vim.opt_local.spell = true
        vim.opt_local.formatoptions:append({ 't' })
        vim.bo.textwidth = 72
      end,
    })

    require('neogit').setup({
      disable_builtin_notifications = true,
      disable_commit_confirmation = true,
      disable_hint = true,
      disable_insert_on_commit = false,
      signs = {
        section = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
        item = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
        hunk = { '', '' },
      },
      integrations = { diffview = true },
      sections = {
        recent = {
          folded = false,
        },
      },
    })
  end,
}