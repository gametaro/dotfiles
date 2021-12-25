local gitsigns = require 'gitsigns'

gitsigns.setup {
  signs = {
    add = { hl = 'GitSignsAdd', text = '▍', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '▍', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete = { hl = 'GitSignsDelete', text = '', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete = { hl = 'GitSignsDelete', text = '', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '▍', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = true,
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'" },
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'" },

    ['n <LocalLeader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['x <LocalLeader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <LocalLeader>hu'] = '<Cmd>lua require"gitsigns".undo_stage_hank()<CR>',
    ['n <LocalLeader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['x <LocalLeader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <LocalLeader>hR'] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <LocalLeader>hp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <LocalLeader>hb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    ['n <LocalLeader>hq'] = '<Cmd>lua require"gitsigns".setqflist("all")<CR>',
    ['n <LocalLeader>hl'] = '<Cmd>lua require"gitsigns".setloclist()<CR>',
    ['n <LocalLeader>hS'] = '<Cmd>lua require"gitsigns".stage_buffer()<CR>',
    ['n <LocalLeader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

    ['o ih'] = '<Cmd>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = '<Cmd>lua require"gitsigns.actions".select_hunk()<CR>',
  },
  current_line_blame = false,
  preview_config = {
    border = 'none',
  },
}
