vim.bo.buflisted = false
vim.opt_local.list = false
vim.opt_local.number = true
vim.opt_local.relativenumber = false
vim.opt_local.spell = false

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

local win = vim.fn.getqflist({ winid = 1 }).winid
local prevwin = vim.fn.win_getid(vim.fn.winnr('#'))
local prevbuf = vim.api.nvim_win_get_buf(prevwin)
vim.api.nvim_win_call(prevwin, function()
  prevview = vim.fn.winsaveview()
end)

local group = vim.api.nvim_create_augroup('qf', {})
vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
  group = group,
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
      for name, value in pairs(config) do
        prevoptions[name] = vim.wo[prevwin][name]
        vim.api.nvim_set_option_value(name, value, { win = prevwin, scope = 'local' })
      end
      vim.api.nvim_buf_call(item.bufnr, function()
        vim.cmd.normal({ args = { 'zz', 'zv' }, bang = true })
      end)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'WinClosed' }, {
  group = group,
  pattern = tostring(win),
  once = true,
  callback = function()
    vim.api.nvim_win_set_buf(prevwin, prevbuf)
    vim.api.nvim_win_call(prevwin, function()
      vim.fn.winrestview(prevview)
    end)
    vim.api.nvim_del_augroup_by_id(group)
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  group = group,
  callback = function(a)
    if vim.fn.win_gettype(vim.fn.bufwinid(a.buf)) == 'quickfix' then
      for name, value in pairs(prevoptions) do
        vim.wo[prevwin][name] = value
      end
    end
  end,
})
