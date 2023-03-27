return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
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
    })

    local ai = require('mini.ai')
    local spec_treesitter = ai.gen_spec.treesitter
    ai.setup({
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
        -- diagnostic
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
        u = function(type)
          local node = vim.treesitter.get_node()
          if node == nil then
            return node
          end
          if type == 'a' then
            local parent = node:parent()
            local start = node:start()
            local end_ = node:end_()
            while parent ~= nil and parent:start() == start and parent:end_() == end_ do
              node = parent
              parent = node:parent()
            end
          end
          local from_line, from_col, to_line, to_col = node:range()
          return {
            from = { line = from_line + 1, col = from_col + 1 },
            to = { line = to_line + 1, col = to_col },
          }
        end,
        F = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = spec_treesitter({ a = '@class.outer', i = '@class.inner' }),
        o = spec_treesitter({
          a = { '@block.outer', '@conditional.outer', '@loop.outer' },
          i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
      },
      mappings = {
        around_last = '',
        inside_last = '',
      },
    })
  end,
}
