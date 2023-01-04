local api = vim.api
local cmd = vim.cmd

local keep_mode = false

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

    local escape = [[<C-\><C-n>]]
    map('t', ';', function()
      local line = api.nvim_get_current_line()
      return string.match(line, '❯%s+$') and string.format('%s:', escape) or ':'
    end, { expr = true })
    map('t', [[<C-o>]], function()
      keep_mode = true
      return string.format('%s<C-o>', escape)
    end, { expr = true })
    map('t', [[<BS>]], function()
      keep_mode = true
      return string.format('%s<C-^>', escape)
    end, { expr = true })

    map('t', '<Esc>', function()
      local names = { 'nvim', 'fzf' }
      return require('ky.util').find_proc_in_tree(vim.b[a.buf].terminal_job_pid, names) and '<Esc>'
        or escape
    end, {
      expr = true,
      desc = [[toggle `<Esc>` and `<C-\><C-n>` based on current process tree]],
    })

    cmd.startinsert()
  end,
})

api.nvim_create_autocmd({ 'TermEnter', 'TermLeave' }, {
  callback = function(a)
    if a.event == 'TermEnter' then
      keep_mode = false
      vim.b[a.buf].term_mode = api.nvim_get_mode().mode
    end
    if a.event == 'TermLeave' and not keep_mode then
      vim.b[a.buf].term_mode = api.nvim_get_mode().mode
    end
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
