return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- require('mini.pairs').setup({
    --   modes = { insert = false, command = true, terminal = true },
    -- })
    --
    -- vim.keymap.set(
    --   { 'c', 't' },
    --   '<C-h>',
    --   'v:lua.MiniPairs.bs()',
    --   { expr = true, replace_keycodes = false, desc = 'MiniPairs <BS>' }
    -- )

    vim.keymap.set('n', '[i', function()
      require('mini.indentscope').operator('top', true)
    end, { desc = 'Top indent scope' })
    vim.keymap.set('n', ']i', function()
      require('mini.indentscope').operator('bottom', true)
    end, { desc = 'Bottom indent scope' })
    vim.keymap.set({ 'x', 'o' }, '[i', function()
      require('mini.indentscope').operator('top')
    end, { desc = 'Top indent scope' })
    vim.keymap.set({ 'x', 'o' }, ']i', function()
      require('mini.indentscope').operator('bottom')
    end, { desc = 'Bottom indent scope' })
    vim.keymap.set({ 'x', 'o' }, 'ii', function()
      require('mini.indentscope').textobject(false)
    end, { desc = 'Object scope' })
    vim.keymap.set({ 'x', 'o' }, 'ai', function()
      require('mini.indentscope').textobject(true)
    end, { desc = 'Object scope with border' })

    local group = vim.api.nvim_create_augroup('mine__mini', {})

    require('mini.comment').setup({
      hooks = {
        pre = function()
          require('ts_context_commentstring.internal').update_commentstring()
        end,
      },
    })

    require('mini.ai').setup({
      custom_textobjects = {
        -- textobj-entire
        e = function()
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line('$'),
            col = math.max(vim.fn.getline('$'):len(), 1),
          }
          return { from = from, to = to }
        end,
        -- textobj-line
        l = function(type)
          if vim.api.nvim_get_current_line() == '' then
            return
          end
          vim.cmd.normal({ type == 'i' and '^' or '0', bang = true })
          local from_line, from_col = unpack(vim.api.nvim_win_get_cursor(0))
          local from = { line = from_line, col = from_col + 1 }
          vim.cmd.normal({ type == 'i' and 'g_' or '$', bang = true })
          local to_line, to_col = unpack(vim.api.nvim_win_get_cursor(0))
          local to = { line = to_line, col = to_col + 1 }
          return { from = from, to = to }
        end,
        d = function()
          return vim.tbl_map(function(diagnostic)
            local from_line = diagnostic.lnum + 1
            local from_col = diagnostic.col + 1
            local to_line = diagnostic.end_lnum + 1
            local to_col = diagnostic.end_col + 1
            return {
              from = { line = from_line, col = from_col },
              to = { line = to_line, col = to_col },
            }
          end, vim.diagnostic.get(0))
        end,
      },
      mappings = {
        around_last = '',
        inside_last = '',
      },
    })

    local map = require('mini.map')
    map.setup({
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.gitsigns(),
        map.gen_integration.diagnostic({
          error = 'DiagnosticFloatingError',
          warn = 'DiagnosticFloatingWarn',
          info = 'DiagnosticFloatingInfo',
          hint = 'DiagnosticFloatingHint',
        }),
      },
      symbols = {
        encode = map.gen_encode_symbols.dot('4x2'),
        scroll_line = '█',
        scroll_view = '▒',
      },
      window = {
        focusable = true,
        show_integration_count = false,
        winblend = 50,
      },
    })
    vim.keymap.set('n', '<Leader>mc', map.close)
    vim.keymap.set('n', '<Leader>mf', map.toggle_focus)
    vim.keymap.set('n', '<Leader>mo', map.open)
    vim.keymap.set('n', '<Leader>mr', map.refresh)
    vim.keymap.set('n', '<Leader>ms', map.toggle_side)
    vim.keymap.set('n', '<Leader>mt', map.toggle)

    vim.api.nvim_create_autocmd('User', {
      pattern = 'SessionLoadPost',
      group = group,
      callback = map.open,
    })
  end,
}
