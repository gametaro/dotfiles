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
    end, { desc = 'Top Indent Scope' })
    vim.keymap.set('n', ']i', function()
      require('mini.indentscope').operator('bottom', true)
    end, { desc = 'Bottom Indent Scope' })
    vim.keymap.set({ 'x', 'o' }, '[i', function()
      require('mini.indentscope').operator('top')
    end, { desc = 'Top Indent Scope' })
    vim.keymap.set({ 'x', 'o' }, ']i', function()
      require('mini.indentscope').operator('bottom')
    end, { desc = 'Bottom Indent Scope' })
    vim.keymap.set({ 'x', 'o' }, 'ii', function()
      require('mini.indentscope').textobject(false)
    end, { desc = 'Object Scope' })
    vim.keymap.set({ 'x', 'o' }, 'ai', function()
      require('mini.indentscope').textobject(true)
    end, { desc = 'Object Scope With Border' })

    require('mini.comment').setup({
      options = {
        ignore_blank_line = true,
      },
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
        -- treesitter-unit
        u = function()
          local node = vim.treesitter.get_node()
          if node == nil then
            return node
          end
          local parent = node:parent()
          local start = node:start()
          while parent ~= nil and parent:start() == start do
            node = parent
            parent = node:parent()
          end
          local from_line, from_col, to_line, to_col = node:range()
          return {
            from = { line = from_line + 1, col = from_col + 1 },
            to = { line = to_line + 1, col = to_col },
          }
        end,
      },
      mappings = {
        around_last = '',
        inside_last = '',
      },
    })
  end,
}
