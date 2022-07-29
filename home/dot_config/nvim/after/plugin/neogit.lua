local ok = prequire('neogit')
if not ok then return end

vim.keymap.set('n', '<LocalLeader>gg', '<Cmd>Neogit<CR>')
vim.keymap.set('n', '<LocalLeader>gG', '<Cmd>Neogit commit<CR>')

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
    vim.opt_local.formatoptions:append { 't' }
    vim.bo.textwidth = 72
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'JetpackNeogitPost',
  group = group,
  callback = function()
    require('neogit').setup {
      disable_builtin_notifications = true,
      disable_commit_confirmation = true,
      disable_hint = true,
      disable_insert_on_commit = false,
      integrations = { diffview = true },
      sections = {
        recent = {
          folded = false,
        },
      },
    }
  end,
})
