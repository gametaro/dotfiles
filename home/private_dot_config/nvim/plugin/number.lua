local group = vim.api.nvim_create_augroup('mine__number', {})

---@class number.Options
---@field ignore_buftype string[]
---@field ignore_filetype string[]
local opts = {
  number = vim.o.number,
  relativenumber = vim.o.relativenumber,
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
local function number(value)
  return vim.api.nvim_set_option_value('number', value, { scope = 'local' })
end

---@param value boolean
local function relativenumber(value)
  return vim.api.nvim_set_option_value('relativenumber', value, { scope = 'local' })
end

---@param buf integer
---@return boolean
local function ignore(buf)
  return vim.tbl_contains(opts.ignore_buftype, vim.bo[buf].buftype)
    or vim.tbl_contains(opts.ignore_filetype, vim.bo[buf].filetype)
end

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave', 'BufLeave' }, {
  group = group,
  callback = function(a)
    if ignore(a.buf) then
      return
    end

    if opts.number then
      number(true)
    end
    if opts.relativenumber then
      relativenumber(false)
    end
    if a.event == 'CmdlineEnter' then
      vim.cmd.redraw()
    end
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter', 'BufEnter' }, {
  group = group,
  callback = function(a)
    if ignore(a.buf) then
      return
    end

    if opts.number then
      number(true)
    end
    if opts.relativenumber then
      relativenumber(true)
    end
  end,
})
