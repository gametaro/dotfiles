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

local ignore = function(buf)
  return vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype)
    or vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype)
end

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = group,
  callback = function(a)
    if ignore(a.buf) then return end

    number(true)
    relativenumber(false)
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = group,
  callback = function(a)
    if ignore(a.buf) then return end

    number(true)
    relativenumber(true)
  end,
})
