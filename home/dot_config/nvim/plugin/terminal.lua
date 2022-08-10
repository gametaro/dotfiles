local api = vim.api
local cmd = vim.cmd

local get_prompt_text = function()
  local count = api.nvim_buf_line_count(0)
  local lines = vim.tbl_filter(function(s)
    return s ~= ''
  end, api.nvim_buf_get_lines(0, 0, count, true))

  return lines[#lines]
end

api.nvim_create_autocmd('TermOpen', {
  callback = function(a)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'

    ---@param mode string|string[]
    ---@param lhs string
    ---@param rhs string|function
    ---@param opts? table
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = a.buf
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- WARN: experimental
    local escape = [[<C-\><C-n>]]
    map('n', '<CR>', string.format('i<CR>%s', escape))
    map('n', 'I', 'i<Home>')
    map('n', 'A', 'i<End>')
    map('n', 'x', string.format('i<End><BS>%s', escape))
    map('n', 'dw', string.format('i<End><C-w>%s', escape))
    map('n', 'dd', string.format('i<End><C-u>%s', escape))
    map('n', 'cw', 'i<End><C-w>')
    map('n', 'cc', 'i<End><C-u>')
    map('n', 'p', string.format('i<End>%sp', escape))
    map('n', 'P', string.format('i<Home>%sp', escape))
    map('n', 'u', string.format('i<C-_>%s', escape))
    map('n', '<C-p>', function()
      return 'i' .. string.rep('<Up>', vim.v.count1) .. escape
    end, { expr = true })
    map('n', '<C-n>', function()
      return 'i' .. string.rep('<Down>', vim.v.count1) .. escape
    end, { expr = true })
    map('t', ';', function()
      local text = get_prompt_text()
      return string.match(text, '❯%s+$') and [[<C-\><C-n>:]] or ':'
    end, { expr = true })

    map('t', '<Esc>', function()
      local names = { 'nvim', 'fzf' }
      return require('ky.utils').find_proc_in_tree(vim.b[a.buf].terminal_job_pid, names) and '<Esc>'
        or escape
    end, {
      expr = true,
      desc = [[toggle `<Esc>` and `<C-\><C-n>` based on current process tree]],
    })

    cmd.startinsert()
  end,
})

api.nvim_create_autocmd({ 'TermEnter', 'TermLeave' }, {
  pattern = 'term://*',
  callback = function(a)
    vim.b[a.buf].term_mode = api.nvim_get_mode().mode
  end,
})

api.nvim_create_autocmd('BufEnter', {
  pattern = 'term://*',
  callback = function(a)
    if vim.b[a.buf].term_mode == 't' then
      cmd.startinsert()
    end
  end,
})

api.nvim_create_autocmd('TermClose', {
  callback = function(a)
    if vim.v.event.status == 0 then
      api.nvim_buf_delete(a.buf, { force = true })
    end
  end,
  desc = 'close terminal buffers if the job exited without error. see :help terminal-status',
})
