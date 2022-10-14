local ok = prequire('mini')
if not ok then
  return
end

require('mini.pairs').setup({
  modes = { insert = false, command = true, terminal = true },
})

vim.keymap.set(
  { 'c', 't' },
  '<C-h>',
  'v:lua.MiniPairs.bs()',
  { expr = true, replace_keycodes = false, desc = 'MiniPairs <BS>' }
)

require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation('none'),
  },
  options = {
    try_as_border = true,
  },
  symbol = '|',
})

local group = vim.api.nvim_create_augroup('mine__mini', {})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { '', 'checkhealth', 'help', 'lspinfo', 'man', 'packer' },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function()
    if vim.tbl_contains({ 'nofile', 'quickfix', 'terminal' }, vim.bo.buftype) then
      vim.b.miniindentscope_disable = true
    end
  end,
})

local trailspace = require('mini.trailspace')
trailspace.setup({})
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  callback = trailspace.trim,
})

require('mini.comment').setup({
  hooks = {
    pre = function()
      if vim.bo.filetype == 'typescriptreact' then
        require('ts_context_commentstring.internal').update_commentstring()
      end
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
    -- textobj-line (i only)
    l = function()
      if vim.api.nvim_get_current_line() == '' then
        return
      end
      vim.cmd.normal({ '^', bang = true })
      local from_line, from_col = unpack(vim.api.nvim_win_get_cursor(0))
      local from = { line = from_line, col = from_col + 1 }
      vim.cmd.normal({ 'g_', bang = true })
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
})
vim.keymap.set('n', '<LocalLeader>mc', map.close)
vim.keymap.set('n', '<LocalLeader>mf', map.toggle_focus)
vim.keymap.set('n', '<LocalLeader>mo', map.open)
vim.keymap.set('n', '<LocalLeader>mr', map.refresh)
vim.keymap.set('n', '<LocalLeader>ms', map.toggle_side)
vim.keymap.set('n', '<LocalLeader>mt', map.toggle)

vim.api.nvim_create_autocmd('User', {
  pattern = 'SessionLoadPost',
  group = group,
  callback = map.open,
})

vim.keymap.set('n', '<LocalLeader>z', require('mini.misc').zoom)
