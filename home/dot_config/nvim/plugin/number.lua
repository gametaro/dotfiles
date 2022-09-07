local api = vim.api

local group = api.nvim_create_augroup('mine__number', {})

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
local number = function(value)
  return api.nvim_set_option_value('number', value, { scope = 'local' })
end

---@param value boolean
local relativenumber = function(value)
  return api.nvim_set_option_value('relativenumber', value, { scope = 'local' })
end

local ignore = function(buf)
  return vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype)
    or vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype)
end

api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave', 'BufLeave', 'CmdlineEnter' }, {
  group = group,
  callback = function(a)
    if ignore(a.buf) then
      return
    end

    number(true)
    relativenumber(false)
    if a.event == 'CmdlineEnter' then
      vim.cmd.redraw()
    end
  end,
})

api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter', 'BufEnter', 'CmdlineLeave' }, {
  group = group,
  callback = function(a)
    if ignore(a.buf) then
      return
    end

    number(true)
    relativenumber(true)
  end,
})
