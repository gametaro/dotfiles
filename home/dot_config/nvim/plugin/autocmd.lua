local api = vim.api
local fn = vim.fn
local augroup = api.nvim_create_augroup
local cmd = api.nvim_command

local group = augroup('mine', { clear = true })

local autocmd = function(event, opts)
  opts = opts or {}
  return api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = group }, opts))
end

autocmd('QuickFixCmdPost', {
  pattern = '[^l]*',
  nested = true,
  callback = function()
    cmd('cwindow')
  end,
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  pattern = 'l*',
  nested = true,
  callback = function()
    cmd('lwindow')
  end,
  desc = 'automatically open the location list window',
})

autocmd('FileType', {
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function()
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, nowait = true })
  end,
  desc = 'close with `q`',
})

autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'Search', timeout = 150 }
  end,
  desc = 'highlight on yank',
})

autocmd('BufWritePost', {
  pattern = (vim.env.XDG_DATA_HOME or '') .. '/chezmoi/*',
  callback = function(a)
    if string.match(a.file, '%.git/') then
      return
    end
    local output = ''
    local notification
    local command = { 'chezmoi', 'apply', '--source-path', a.match }
    local win, height
    local length = 0
    local on_data = function(_, data)
      output = output .. table.concat(data, '\n')
      if #output ~= 0 then
        notification = vim.notify(output, 'info', {
          title = table.concat(command, ' '),
          icon = '🏠',
          replace = notification,
          on_open = function(win_)
            win, height = win_, vim.api.nvim_win_get_height(win_)
          end,
        })
        vim.api.nvim_win_set_height(win, height + length)
        length = length + 1
      end
    end
    fn.jobstart(command, {
      on_stdout = on_data,
      on_stderr = on_data,
    })
  end,
  desc = 'run chezmoi apply whenever a dotfile is saved',
})

-- -- show cursor line only in active window
-- vim.cmd [[
-- autocmd mine InsertLeave,WinEnter * set cursorline
-- autocmd mine InsertEnter,WinLeave * set nocursorline
-- ]]

autocmd('BufReadPost', {
  callback = function()
    if vim.tbl_contains({ 'nofile' }, vim.bo.buftype) then
      return
    end
    if vim.tbl_contains({ 'gitcommit', 'gitrebase', 'NeogitCommitMessage' }, vim.bo.filetype) then
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
    cmd('silent! wall')
  end,
})

autocmd('BufLeave', {
  callback = function()
    if vim.bo.buftype == '' and vim.bo.filetype ~= '' and vim.bo.modifiable then
      cmd('silent! update')
    end
  end,
})

autocmd({ 'FocusGained', 'WinEnter' }, {
  callback = function()
    cmd('silent! checktime')
  end,
})

autocmd('BufWritePost', {
  callback = function()
    if vim.wo.diff then
      cmd('diffupdate')
    end
  end,
})

autocmd('VimResized', {
  callback = function()
    cmd('wincmd =')
  end,
})

autocmd('TermOpen', {
  callback = function()
    cmd('startinsert')
  end,
})

autocmd('TermOpen', {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
  end,
})

autocmd({ 'TermEnter', 'TermLeave' }, {
  callback = function()
    api.nvim_buf_set_var(0, 'term_mode', api.nvim_get_mode().mode)
  end,
})

autocmd('TermClose', {
  callback = function(a)
    if vim.v.event.status == 0 then
      api.nvim_buf_delete(a.buf, { force = true })
    end
  end,
  desc = 'close terminal buffers if the job exited without error. see :help terminal-status',
})

autocmd('BufEnter', {
  pattern = 'term://*',
  callback = function()
    local ok, term_mode = pcall(api.nvim_buf_get_var, 0, 'term_mode')
    if ok and term_mode == 't' then
      cmd('startinsert')
    end
  end,
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
    if fn.isdirectory(dir) == 0 then
      fn.mkdir(dir, 'p')
    end
  end,
})

autocmd('ModeChanged', {
  pattern = '*:s',
  callback = function()
    local ok, luasnip = prequire('luasnip')
    if ok and luasnip.in_snippet() then
      return vim.diagnostic.disable()
    end
  end,
})

autocmd('ModeChanged', {
  pattern = '[is]:n',
  callback = function()
    local ok, luasnip = prequire('luasnip')
    if ok and luasnip.in_snippet() then
      return vim.diagnostic.enable()
    end
  end,
})

autocmd('DiagnosticChanged', {
  callback = function()
    local qf = fn.getqflist { winid = 0, title = 0 }

    if qf.winid ~= 0 and qf.title == 'Diagnostics' then
      require('ky.defer').debounce_trailing(function()
        vim.diagnostic.setqflist { open = false }
      end, 1500)()
    end
  end,
})

autocmd('DiagnosticChanged', {
  callback = function()
    local loc = fn.getloclist(0, { winid = 0, title = 0 })

    if loc.winid ~= 0 and loc.title == 'Diagnostics' then
      require('ky.defer').debounce_trailing(function()
        vim.diagnostic.setloclist { open = false }
      end, 1500)()
    end
  end,
})

autocmd('FileType', {
  pattern = { 'gitcommit', 'gitrebase' },
  callback = function()
    vim.bo.bufhidden = 'wipe'
  end,
})
