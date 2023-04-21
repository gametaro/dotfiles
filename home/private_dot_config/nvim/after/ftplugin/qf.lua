vim.bo.buflisted = false
vim.opt_local.list = false
vim.opt_local.number = true
vim.opt_local.relativenumber = false
vim.opt_local.spell = false
vim.opt_local.wrap = false

vim.keymap.set('n', 'cc', function()
  vim.cmd.cexpr('[]')
end, { buffer = true, desc = 'clear quickfix list' })

local config = {
  number = true,
  cursorline = true,
  relativenumber = false,
  foldenable = false,
}

local prevview
---@type table<string, unknown>
local prevoptions = {}

local buf = vim.api.nvim_get_current_buf()
local prevwin = vim.fn.win_getid(vim.fn.winnr('#'))
local prevbuf = vim.api.nvim_win_get_buf(prevwin)
vim.api.nvim_win_call(prevwin, function()
  prevview = vim.fn.winsaveview()
end)

prevoptions = vim.iter(config):fold(prevoptions, function(_, name)
  prevoptions[name] = vim.wo[prevwin][name]
end)

local group = vim.api.nvim_create_augroup('qf', {})
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  group = group,
  buffer = buf,
  callback = function(a)
    if vim.fn.win_gettype(vim.fn.bufwinid(a.buf)) == 'quickfix' then
      local row = vim.api.nvim_win_get_cursor(0)[1]
      ---@type Item?
      local item = vim.fn.getqflist()[row]
      if not item then
        return
      end
      vim.api.nvim_win_set_buf(prevwin, item.bufnr)
      vim.api.nvim_win_set_cursor(prevwin, { item.lnum, item.col })
      -- nvim_win_set_buf does not run FileType autocmd
      -- https://github.com/neovim/neovim/issues/10070
      vim.api.nvim_win_call(prevwin, function()
        vim.cmd.filetype('detect')
      end)
      vim.iter(config):each(function(name, value)
        vim.api.nvim_set_option_value(name, value, { win = prevwin, scope = 'local' })
      end)
      vim.api.nvim_buf_call(item.bufnr, function()
        vim.cmd.normal({ args = { 'zz', 'zv' }, bang = true })
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'WinClosed' }, {
  group = group,
  buffer = buf,
  callback = function()
    vim.api.nvim_win_set_buf(prevwin, prevbuf)
    vim.api.nvim_win_call(prevwin, function()
      vim.fn.winrestview(prevview)
    end)
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  group = group,
  buffer = buf,
  callback = function(a)
    if vim.fn.win_gettype(vim.fn.bufwinid(a.buf)) == 'quickfix' then
      for name, value in pairs(prevoptions) do
        vim.wo[prevwin][name] = value
      end
    end
  end,
})
