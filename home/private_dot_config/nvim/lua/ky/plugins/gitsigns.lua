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

      local setlist = require('ky.defer').debounce_trailing(function()
        local qf = vim.fn.getqflist({ winid = 0, title = 0 })
        local loc = vim.fn.getloclist(0, { winid = 0, title = 0 })

        if qf and qf.winid ~= 0 and qf.title == 'Hunks' then
          gs.setqflist(0, { open = false })
        end
        if loc and loc.winid ~= 0 and loc.title == 'Hunks' then
          gs.setqflist(0, { use_location_list = true, open = false })
        end
      end, 500)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitSignsUpdate',
        callback = setlist,
      })

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        else
          vim.schedule(function()
            gs.next_hunk({ navigation_message = false, greedy = false })
            vim.api.nvim_feedkeys('zz', 'n', false)
          end)
          return '<Ignore>'
        end
      end, { expr = true, desc = 'Next hunk' })
      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        else
          vim.schedule(function()
            gs.prev_hunk({ navigation_message = false, greedy = false })
            vim.api.nvim_feedkeys('zz', 'n', false)
          end)
          return '<Ignore>'
        end
      end, { expr = true, desc = 'Previous hunk' })
      -- Actions
      map('n', '<Leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
      map('n', '<Leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
      map('x', '<Leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Stage hunk' })
      map('x', '<Leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'Reset hunk' })
      map('n', '<Leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<Leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
      map('n', '<Leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<Leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk' })
      map('n', '<Leader>hb', function()
        gs.blame_line({ full = true })
      end, { desc = 'Blame line' })
      map('n', '<Leader>hd', gs.diffthis, { desc = 'Diffthis' })
      map('n', '<Leader>hD', function()
        gs.diffthis('~')
      end, { desc = 'Diffthis' })
      map('n', '<Leader>hq', gs.setqflist, { desc = 'Quickfix' })
      map('n', '<Leader>hQ', function()
        gs.setqflist('all')
      end, { desc = 'Quickfix' })
      map('n', '<Leader>hl', gs.setloclist, { desc = 'Location List' })
      map('n', [[\hb]], gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
      map('n', [[\hd]], gs.toggle_deleted, { desc = 'Toggle deleted' })
      map('n', [[\hw]], gs.toggle_word_diff, { desc = 'Toggle word diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { silent = true, desc = 'Hunk' })
    end

    require('gitsigns').setup({
      numhl = true,
      preview_config = {
        border = vim.g.border,
      },
      trouble = false,
      max_file_length = vim.g.max_line_count,
      on_attach = on_attach,
      _extmark_signs = true,
      _threaded_diff = true,
      _signs_staged_enable = true,
    })
  end,
}
