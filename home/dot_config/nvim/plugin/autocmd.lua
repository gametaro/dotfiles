local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local augroup = api.nvim_create_augroup

local debounce_trailing = require('ky.defer').debounce_trailing

local group = augroup('mine', { clear = true })

---@param event string|string[]
---@param opts { pattern: string|table, buffer: integer, desc: string, callback: function, command: string, once: boolean, nested: boolean  }
local autocmd = function(event, opts)
  opts = opts or {}
  return api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = group }, opts))
end

autocmd('QuickFixCmdPost', {
  pattern = '[^l]*',
  nested = true,
  callback = cmd.cwindow,
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  pattern = 'l*',
  nested = true,
  callback = cmd.lwindow,
  desc = 'automatically open the location list window',
})

autocmd('FileType', {
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function(a)
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf, nowait = true })
  end,
  desc = 'close with `q`',
})

autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 200 }
  end,
  desc = 'highlight on yank',
})

if vim.env.XDG_DATA_HOME then
  autocmd('BufWritePost', {
    pattern = vim.fs.normalize(vim.env.XDG_DATA_HOME) .. '/chezmoi/*',
    callback = function(a)
      if string.match(a.file, '%.git/') then return end
      local output = ''
      local notification
      local command = { 'chezmoi', 'apply', '--source-path', a.match }
      local on_data = function(_, data)
        output = output .. table.concat(data, '\n')
        if #output ~= 0 then
          notification = vim.notify(output, vim.log.levels.INFO, {
            title = table.concat(command, ' '),
            icon = '🏠',
            replace = notification,
          })
        end
      end
      fn.jobstart(command, {
        on_stdout = on_data,
        on_stderr = on_data,
      })
    end,
    desc = 'run chezmoi apply whenever a dotfile is saved',
  })
end

autocmd('BufReadPost', {
  callback = function(a)
    if vim.tbl_contains({ 'nofile' }, vim.bo[a.buf].buftype) then return end
    if
      vim.tbl_contains({ 'gitcommit', 'gitrebase', 'NeogitCommitMessage' }, vim.bo[a.buf].filetype)
    then
      return
    end
    local row, col = unpack(api.nvim_buf_get_mark(0, '"'))
    if
      api.nvim_win_is_valid(0)
      and { row, col } ~= { 1, 0 }
      and row <= api.nvim_buf_line_count(0)
    then
      api.nvim_win_set_cursor(0, { row, col })
    end
  end,
  desc = 'always jump to the last cursor position. see :help restore-cursor',
})

autocmd('FocusLost', {
  nested = true,
  callback = function()
    cmd.wall { mods = { emsg_silent = true, silent = true } }
  end,
})

autocmd('BufLeave', {
  callback = function(a)
    if
      vim.bo[a.buf].buftype == ''
      and vim.bo[a.buf].filetype ~= ''
      and vim.bo[a.buf].modifiable
    then
      cmd.update { mods = { emsg_silent = true, silent = true } }
    end
  end,
})

-- autocmd({ 'FocusGained', 'WinEnter' }, {
--   callback = function()
--     cmd.checktime { mods = { emsg_silent = true, silent = true } }
--   end,
-- })

autocmd('BufWritePost', {
  callback = function()
    if vim.wo.diff then cmd.diffupdate() end
  end,
})

autocmd('VimResized', {
  callback = function()
    cmd.wincmd('=')
  end,
})

local get_prompt_text = function()
  local count = api.nvim_buf_line_count(0)
  local lines = vim.tbl_filter(function(s)
    return s ~= ''
  end, api.nvim_buf_get_lines(0, 0, count, true))

  return lines[#lines]
end

autocmd('TermOpen', {
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
      return 'i' .. string.rep('<Up>', vim.v.count1) .. [[<C-\><C-n>]]
    end, { expr = true })
    map('n', '<C-n>', function()
      return 'i' .. string.rep('<Down>', vim.v.count1) .. [[<C-\><C-n>]]
    end, { expr = true })
    map('t', ':', function()
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

autocmd({ 'TermEnter', 'TermLeave' }, {
  pattern = 'term://*',
  callback = function(a)
    vim.b[a.buf].term_mode = api.nvim_get_mode().mode
  end,
})

autocmd('BufEnter', {
  pattern = 'term://*',
  callback = function(a)
    if vim.b[a.buf].term_mode == 't' then cmd.startinsert() end
  end,
})

autocmd('TermClose', {
  callback = function(a)
    if vim.v.event.status == 0 then api.nvim_buf_delete(a.buf, { force = true }) end
  end,
  desc = 'close terminal buffers if the job exited without error. see :help terminal-status',
})

autocmd('BufEnter', {
  callback = function()
    vim.opt_local.formatoptions:remove {
      'c',
      'o',
      'r',
    }
  end,
})

autocmd('BufWritePre', {
  callback = function()
    local dir = fn.expand('<afile>:p:h')
    if fn.isdirectory(dir) == 0 then fn.mkdir(dir, 'p') end
  end,
})
