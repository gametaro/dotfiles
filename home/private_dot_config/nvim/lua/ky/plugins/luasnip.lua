return {
  'L3MON4D3/LuaSnip',
  dependencies = 'rafamadriz/friendly-snippets',
  event = 'InsertEnter',
  config = function()
    local ls = require('luasnip')
    local types = require('luasnip.util.types')

    local function ins_generate(nodes)
      return setmetatable(nodes or {}, {
        __index = function(table, key)
          local idx = tonumber(key)
          if idx then
            local val = ls.i(idx)
            rawset(table, key, val)
            return val
          end
        end,
      })
    end

    local function rep_generate(nodes)
      return setmetatable(nodes or {}, {
        __index = function(table, key)
          local idx = tonumber(key)
          if idx then
            local val = ls.r(idx, key)
            rawset(table, key, val)
            return val
          end
        end,
      })
    end

    ls.setup({
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
        ls = ls,
        s = require('luasnip.nodes.snippet').S,
        sn = require('luasnip.nodes.snippet').SN,
        isn = require('luasnip.nodes.snippet').ISN,
        c = require('luasnip.nodes.choiceNode').C,
        d = require('luasnip.nodes.dynamicNode').D,
        f = require('luasnip.nodes.functionNode').F,
        i = require('luasnip.nodes.insertNode').I,
        r = require('luasnip.nodes.restoreNode').R,
        t = require('luasnip.nodes.textNode').T,
        ai = require('luasnip.nodes.absolute_indexer'),
        l = require('luasnip.extras').lambda,
        m = require('luasnip.extras').match,
        n = require('luasnip.extras').nonempty,
        p = require('luasnip.extras').partial,
        dl = require('luasnip.extras').dynamic_lambda,
        fmt = require('luasnip.extras.fmt').fmt,
        fmta = require('luasnip.extras.fmt').fmta,
        postfix = require('luasnip.extras.postfix').postfix,
        rep = require('luasnip.extras').rep,
        conds = require('luasnip.extras.expand_conditions'),
        types = require('luasnip.util.types'),
        events = require('luasnip.util.events'),
        parse = require('luasnip.util.parser').parse_snippet,
        ins_generate = ins_generate,
        rep_generate = rep_generate,
      },
    })

    vim.api.nvim_create_user_command('LuaSnipEdit', function()
      require('luasnip.loaders.from_lua').edit_snippet_files()
    end, { nargs = 0 })

    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if ls.expand_or_locally_jumpable() then
        ls.expand_or_jump()
      end
    end, { desc = 'Expand or Goto Next Snippet' })
    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { desc = 'Expand or Goto Previous Snippet' })
    vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { desc = 'Change Choice' })

    require('luasnip.loaders.from_lua').lazy_load()
  end,
}
