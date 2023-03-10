local terminals = {}

local function open()
  local cwd = vim.fn.getcwd(-1, vim.api.nvim_get_current_tabpage())
  terminals[cwd] = terminals[cwd] or {}
  if terminals[cwd][vim.v.count1] then
    vim.api.nvim_set_current_buf(terminals[cwd][vim.v.count1])
    return
  end
  vim.cmd.terminal()
  table.insert(terminals[cwd], vim.api.nvim_get_current_buf())
end

vim.keymap.set('n', [[<C-\>]], open, { desc = 'Open terminal' })

---@param buf integer
local function on_open(buf)
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = 'no'
  vim.opt_local.statuscolumn = ''

  vim.b[buf].keep_mode = false

  local escape = [[<C-\><C-n>]]
  vim.keymap.set('t', ';', function()
    local line = vim.api.nvim_get_current_line()
    return string.match(line, '❯%s+$') and string.format('%s:', escape) or ':'
  end, { buffer = buf, expr = true, desc = 'Cmdline' })
  vim.keymap.set('t', [[<C-o>]], function()
    vim.b[buf].keep_mode = true
    return string.format('%s<C-o>', escape)
  end, { buffer = buf, expr = true, desc = 'Goto older position' })

  vim.keymap.set('t', '<Esc>', function()
    local names = { 'nvim', 'fzf' }
    return require('ky.util').find_proc_in_tree(vim.b[buf].terminal_job_pid, names) and '<Esc>'
      or escape
  end, { buffer = buf, expr = true })

  vim.cmd.startinsert()
end

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = function(a)
    on_open(a.buf)
  end,
})

vim.api.nvim_create_autocmd({ 'TermEnter', 'TermLeave' }, {
  callback = function(a)
    if a.event == 'TermEnter' then
      vim.b[a.buf].keep_mode = false
      vim.b[a.buf].term_mode = vim.api.nvim_get_mode().mode
    end
    if a.event == 'TermLeave' and not vim.b[a.buf].keep_mode then
      vim.b[a.buf].term_mode = vim.api.nvim_get_mode().mode
    end
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'term://*',
  callback = function(a)
    if vim.b[a.buf].term_mode == 't' then
      vim.cmd.startinsert()
    end
  end,
})
