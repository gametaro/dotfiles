local ls = require('luasnip')
local types = require('luasnip.util.types')
ls.config.set_config {
  history = true,
  update_events = 'InsertLeave',
  region_check_events = 'CursorHold',
  delete_check_events = 'TextChanged,InsertEnter',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
  ext_opts = {
    -- [types.insertNode] = {
    --   active = {
    --     virt_text = { { '●' } },
    --   },
    -- },
    [types.choiceNode] = {
      active = {
        virt_text = { { '■' } },
      },
    },
  },
}

vim.api.nvim_add_user_command('LuaSnipEdit', function()
  require('luasnip.loaders.from_lua').edit_snippet_files()
end, { nargs = 0 })

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if require('luasnip').expand_or_locally_jumpable() then
    require('luasnip').expand_or_jump()
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if require('luasnip').jumpable(-1) then
    require('luasnip').jump(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if require('luasnip').choice_active() then
    require('luasnip').change_choice(1)
  end
end)

require('luasnip.loaders.from_lua').lazy_load()
