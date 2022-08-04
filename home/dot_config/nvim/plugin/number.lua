local group = vim.api.nvim_create_augroup('mine__number', {})

---@class number.Options
---@field ignore_buftype string[]
---@field ignore_filetype string[]
local opts = {
  ignore_buftype = {
    'help',
    'nofile',
    'prompt',
    'quickfix',
    'terminal',
  },
  ignore_filetype = {},
}

---@param value boolean
---@return nil
local number = function(value)
  return vim.api.nvim_set_option_value('number', value, { scope = 'local' })
end

---@param value boolean
---@return nil
local relativenumber = function(value)
  return vim.api.nvim_set_option_value('relativenumber', value, { scope = 'local' })
end

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = group,
  callback = function(a)
    if vim.tbl_contains(opts.ignore_buftype, vim.bo[a.buf].buftype) then return end
    if vim.tbl_contains(opts.ignore_filetype, vim.bo[a.buf].filetype) then return end

    number(true)
    relativenumber(false)
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = group,
  callback = function(a)
    if vim.tbl_contains(opts.ignore_buftype, vim.bo[a.buf].buftype) then return end
    if vim.tbl_contains(opts.ignore_filetype, vim.bo[a.buf].filetype) then return end

    number(true)
    relativenumber(true)
  end,
})
