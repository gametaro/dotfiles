return {
  'lewis6991/gitsigns.nvim',
  dependencies = 'tpope/vim-repeat',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = buffer
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        else
          vim.schedule(function()
            gs.next_hunk({ navigation_message = false, preview = true })
          end)
          return '<Ignore>'
        end
      end, { expr = true })
      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        else
          vim.schedule(function()
            gs.prev_hunk({ navigation_message = false, preview = true })
          end)
          return '<Ignore>'
        end
      end, { expr = true })
      -- Actions
      map('n', '<LocalLeader>hs', gs.stage_hunk)
      map('n', '<LocalLeader>hr', gs.reset_hunk)
      map('x', '<LocalLeader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      map('x', '<LocalLeader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      map('n', '<LocalLeader>hS', gs.stage_buffer)
      map('n', '<LocalLeader>hu', gs.undo_stage_hunk)
      map('n', '<LocalLeader>hR', gs.reset_buffer)
      map('n', '<LocalLeader>hp', gs.preview_hunk)
      map('n', '<LocalLeader>hb', function()
        gs.blame_line({ full = true })
      end)
      map('n', '<LocalLeader>hd', gs.diffthis)
      map('n', '<LocalLeader>hD', function()
        gs.diffthis('~')
      end)
      map('n', '<LocalLeader>hq', gs.setqflist)
      map('n', '<LocalLeader>hQ', function()
        gs.setqflist('all')
      end)
      map('n', '<LocalLeader>hl', gs.setloclist)
      map('n', '<LocalLeader>tb', gs.toggle_current_line_blame)
      map('n', '<LocalLeader>td', gs.toggle_deleted)
      map('n', '<LocalLeader>tw', gs.toggle_word_diff)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true })
    end

    require('gitsigns').setup({
      preview_config = {
        border = vim.g.border,
      },
      trouble = false,
      on_attach = on_attach,
      _extmark_signs = true,
      _threaded_diff = true,
    })
  end,
}
