local ok = prequire('hydra')
if not ok then return end

local cmd = vim.cmd

local Hydra = require('hydra')

Hydra {
  name = 'Side scroll',
  mode = 'n',
  body = 'z',
  heads = {
    { 'h', '5zh' },
    { 'l', '5zl', { desc = '←/→' } },
    { 'H', 'zH' },
    { 'L', 'zL', { desc = 'half screen ←/→' } },
  },
}

Hydra {
  name = 'Window size',
  mode = 'n',
  body = '<C-w>',
  heads = {
    { '+', '2<C-w>+' },
    { '-', '2<C-w>-', { desc = 'height +/-' } },
    { '>', '2<C-w>>' },
    { '<', '2<C-w><', { desc = 'width +/-' } },
    { '<Esc>', nil, { exit = true } },
  },
}

Hydra {
  name = 'Tab',
  mode = 'n',
  body = '<C-t>',
  heads = {
    {
      'e',
      function()
        cmd.tabnew { '%' }
      end,
      { desc = 'Open a new tab page with an current buffer' },
    },
    { 'c', cmd.tabclose, { desc = 'Close current tab page' } },
    {
      'C',
      function()
        cmd.tabclose { bang = true }
      end,
      { desc = 'Force close current tab page' },
    },
    { 'l', cmd.tabnext, { desc = 'Go to the next tab page' } },
    { 'h', cmd.tabprevious, { desc = 'Go to the previous tab page' } },
    { 'o', cmd.tabonly, { desc = 'Close all other tab pages' } },
    { '0', cmd.tabfirst, { desc = 'Go to the first tab page' } },
    { '$', cmd.tablast, { desc = 'Go to the last tab page' } },
    {
      'L',
      function()
        cmd.tabmove { '+' }
      end,
      { desc = 'Move the tab page to the right' },
    },
    {
      'H',
      function()
        cmd.tabmove { '-' }
      end,
      { desc = 'Move the tab page to the left' },
    },
  },
}

local gitsigns = require('gitsigns')

local hint = [[
  _J_: next hunk   _s_: stage hunk        _d_: show deleted   _b_: blame line
  _K_: prev hunk   _u_: undo stage hunk   _p_: preview hunk   _B_: blame show full  
  ^ ^              _S_: stage buffer      ^ ^                 _/_: show base file
  ^
  ^ ^              _<Enter>_: Neogit              _q_: exit
]]

Hydra {
  hint = hint,
  config = {
    color = 'pink',
    invoke_on_body = true,
    hint = {
      position = 'bottom',
      border = 'rounded',
    },
    on_enter = function()
      vim.bo.modifiable = false
      gitsigns.toggle_signs(true)
      gitsigns.toggle_linehl(true)
    end,
    on_exit = function()
      gitsigns.toggle_signs(false)
      gitsigns.toggle_linehl(false)
      gitsigns.toggle_deleted(false)
      vim.cmd.echo() -- clear the echo area
    end,
  },
  mode = { 'n', 'x' },
  body = '<Leader>g',
  heads = {
    {
      'J',
      function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function()
          gitsigns.next_hunk()
        end)
        return '<Ignore>'
      end,
      { expr = true },
    },
    {
      'K',
      function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function()
          gitsigns.prev_hunk()
        end)
        return '<Ignore>'
      end,
      { expr = true },
    },
    { 's', ':Gitsigns stage_hunk<CR>', { silent = true } },
    { 'u', gitsigns.undo_stage_hunk },
    { 'S', gitsigns.stage_buffer },
    { 'p', gitsigns.preview_hunk },
    { 'd', gitsigns.toggle_deleted, { nowait = true } },
    { 'b', gitsigns.blame_line },
    {
      'B',
      function()
        gitsigns.blame_line { full = true }
      end,
    },
    { '/', gitsigns.show, { exit = true } }, -- show the base of the file
    { '<Enter>', '<cmd>Neogit<CR>', { exit = true } },
    { 'q', nil, { exit = true, nowait = true } },
  },
}
