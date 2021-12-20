local gitsigns = require 'gitsigns'
local actions = require 'gitsigns.actions'

local M = {}

function M.stage_buffer()
  actions.stage_buffer()
  if pcall(require, 'diffview') then
    vim.cmd 'DiffviewRefresh'
  end
end

function M.stage_hank()
  actions.stage_hunk()
  if pcall(require, 'diffview') then
    vim.cmd 'DiffviewRefresh'
  end
end

function M.stage_hank_range()
  actions.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  if pcall(require, 'diffview') then
    vim.cmd 'DiffviewRefresh'
  end
end

function M.undo_stage_hank()
  actions.undo_stage_hunk()
  if pcall(require, 'diffview') then
    vim.cmd 'DiffviewRefresh'
  end
end

function M.next_hunk()
  actions.next_hunk()
  actions.preview_hunk()
end

function M.prev_hunk()
  actions.prev_hunk()
  actions.preview_hunk()
end

gitsigns.setup {
  signs = {
    add = { hl = 'GitSignsAdd', text = '▍', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
    change = { hl = 'GitSignsChange', text = '▍', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete = { hl = 'GitSignsDelete', text = '', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete = { hl = 'GitSignsDelete', text = '', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '▍', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    buffer = true,
    ['n ]c'] = { expr = true, "&diff ? ']c' : '<Cmd>lua require\"ky.config.gitsigns\".next_hunk()<CR>'" },
    ['n [c'] = { expr = true, "&diff ? '[c' : '<Cmd>lua require\"ky.config.gitsigns\".prev_hunk()<CR>'" },
    ['n <LocalLeader>hb'] = '<Cmd>lua require"ky.config.gitsigns".stage_buffer()<CR>',
    ['n <LocalLeader>hs'] = '<Cmd>lua require"ky.config.gitsigns".stage_hank()<CR>',
    ['v <LocalLeader>hs'] = '<Cmd>lua require"ky.config.gitsigns".stage_hank_range()<CR>',
    ['n <LocalLeader>hu'] = '<Cmd>lua require"ky.config.gitsigns".undo_stage_hank()<CR>',
    ['n <LocalLeader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <LocalLeader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <LocalLeader>hR'] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <LocalLeader>hp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <LocalLeader>hq'] = '<Cmd>lua require"gitsigns".setqflist("all")<CR>',
    ['n <LocalLeader>hl'] = '<Cmd>lua require"gitsigns".setloclist()<CR>',
    ['o ih'] = '<Cmd>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = '<Cmd>lua require"gitsigns.actions".select_hunk()<CR>',
  },
  preview_config = {
    border = 'single',
  },
  current_line_blame = false,
  word_diff = true,
}

return M
