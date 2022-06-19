local ok = prequire('gitsigns')
if not ok then
  return
end

require('gitsigns').setup {
  -- signs = {
  --   add = {
  --     hl = 'GitSignsAdd',
  --     text = '▍',
  --     numhl = 'GitSignsAddNr',
  --     linehl = 'GitSignsAddLn',
  --   },
  --   change = {
  --     hl = 'GitSignsChange',
  --     text = '▍',
  --     numhl = 'GitSignsChangeNr',
  --     linehl = 'GitSignsChangeLn',
  --   },
  --   delete = {
  --     hl = 'GitSignsDelete',
  --     text = '',
  --     numhl = 'GitSignsDeleteNr',
  --     linehl = 'GitSignsDeleteLn',
  --   },
  --   topdelete = {
  --     hl = 'GitSignsDelete',
  --     text = '',
  --     numhl = 'GitSignsDeleteNr',
  --     linehl = 'GitSignsDeleteLn',
  --   },
  --   changedelete = {
  --     hl = 'GitSignsChange',
  --     text = '▍',
  --     numhl = 'GitSignsChangeNr',
  --     linehl = 'GitSignsChangeLn',
  --   },
  -- },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  current_line_blame = false,
  preview_config = {
    border = require('ky.ui').border,
  },
  trouble = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      else
        vim.schedule(function()
          gs.next_hunk { preview = true }
        end)
        return '<Ignore>'
      end
    end, { expr = true })
    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      else
        vim.schedule(function()
          gs.prev_hunk { preview = true }
        end)
        return '<Ignore>'
      end
    end, { expr = true })
    -- Actions
    map('n', '<LocalLeader>hs', gs.stage_hunk)
    map('n', '<LocalLeader>hr', gs.reset_hunk)
    map('x', '<LocalLeader>hs', function()
      gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end)
    map('x', '<LocalLeader>hr', function()
      gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end)
    map('n', '<LocalLeader>hS', gs.stage_buffer)
    map('n', '<LocalLeader>hu', gs.undo_stage_hunk)
    map('n', '<LocalLeader>hR', gs.reset_buffer)
    map('n', '<LocalLeader>hp', gs.preview_hunk)
    map('n', '<LocalLeader>hb', function()
      gs.blame_line { full = true }
    end)
    map('n', '<LocalLeader>tb', gs.toggle_current_line_blame)
    map('n', '<LocalLeader>hd', gs.diffthis)
    map('n', '<LocalLeader>hD', function()
      gs.diffthis('~')
    end)
    map('n', '<LocalLeader>hq', gs.setqflist)
    map('n', '<LocalLeader>hQ', function()
      gs.setqflist('all')
    end)
    map('n', '<LocalLeader>hl', gs.setloclist)
    map('n', '<LocalLeader>td', gs.toggle_deleted)

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
}
