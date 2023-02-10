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
      map('n', '<Leader>hs', gs.stage_hunk)
      map('n', '<Leader>hr', gs.reset_hunk)
      map('x', '<Leader>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      map('x', '<Leader>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end)
      map('n', '<Leader>hS', gs.stage_buffer)
      map('n', '<Leader>hu', gs.undo_stage_hunk)
      map('n', '<Leader>hR', gs.reset_buffer)
      map('n', '<Leader>hp', gs.preview_hunk)
      map('n', '<Leader>hb', function()
        gs.blame_line({ full = true })
      end)
      map('n', '<Leader>hd', gs.diffthis)
      map('n', '<Leader>hD', function()
        gs.diffthis('~')
      end)
      map('n', '<Leader>hq', gs.setqflist)
      map('n', '<Leader>hQ', function()
        gs.setqflist('all')
      end)
      map('n', '<Leader>hl', gs.setloclist)
      map('n', '<Leader>tb', gs.toggle_current_line_blame)
      map('n', '<Leader>td', gs.toggle_deleted)
      map('n', '<Leader>tw', gs.toggle_word_diff)

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
