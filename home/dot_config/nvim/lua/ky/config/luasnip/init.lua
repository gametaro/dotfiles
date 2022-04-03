local ls = require('luasnip')
local types = require('luasnip.util.types')

ls.config.setup {
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
  snip_env = {
    ls = require('luasnip'),
    s = require('luasnip.nodes.snippet').S,
    sn = require('luasnip.nodes.snippet').SN,
    t = require('luasnip.nodes.textNode').T,
    f = require('luasnip.nodes.functionNode').F,
    i = require('luasnip.nodes.insertNode').I,
    c = require('luasnip.nodes.choiceNode').C,
    d = require('luasnip.nodes.dynamicNode').D,
    r = require('luasnip.nodes.restoreNode').R,
    l = require('luasnip.extras').lambda,
    rep = require('luasnip.extras').rep,
    p = require('luasnip.extras').partial,
    m = require('luasnip.extras').match,
    n = require('luasnip.extras').nonempty,
    dl = require('luasnip.extras').dynamic_lambda,
    fmt = require('luasnip.extras.fmt').fmt,
    fmta = require('luasnip.extras.fmt').fmta,
    conds = require('luasnip.extras.expand_conditions'),
    types = require('luasnip.util.types'),
    events = require('luasnip.util.events'),
    parse = require('luasnip.util.parser').parse_snippet,
    ai = require('luasnip.nodes.absolute_indexer'),
    ins_generate = require('ky.config.luasnip.helpers').ins_generate,
    rep_generate = require('ky.config.luasnip.helpers').rep_generate,
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
