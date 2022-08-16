local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local group = api.nvim_create_augroup('mine', {})

---@param event string|string[]
---@param opts { pattern: string|table, buffer: integer, desc: string, callback: function, command: string, once: boolean, nested: boolean  }
local autocmd = function(event, opts)
  opts = opts or {}
  return api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = group }, opts))
end

autocmd('QuickFixCmdPost', {
  pattern = '[^l]*',
  nested = true,
  callback = function()
    cmd.cwindow()
  end,
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  pattern = 'l*',
  nested = true,
  callback = function()
    cmd.lwindow()
  end,
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
    vim.highlight.on_yank({ higroup = 'Search', timeout = 200 })
  end,
  desc = 'highlight on yank',
})

if vim.env.XDG_DATA_HOME then
  autocmd('BufWritePost', {
    pattern = vim.fs.normalize(vim.env.XDG_DATA_HOME) .. '/chezmoi/*',
    callback = function(a)
      if string.match(a.file, '%.git/') then
        return
      end
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
    if vim.tbl_contains({ 'nofile' }, vim.bo[a.buf].buftype) then
      return
    end
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
    cmd.wall({ mods = { emsg_silent = true, silent = true } })
  end,
})

autocmd('BufLeave', {
  callback = function(a)
    if
      vim.bo[a.buf].buftype == ''
      and vim.bo[a.buf].filetype ~= ''
      and vim.bo[a.buf].modifiable
    then
      cmd.update({ mods = { emsg_silent = true, silent = true } })
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
    if vim.wo.diff then
      cmd.diffupdate()
    end
  end,
})

autocmd('VimResized', {
  callback = function()
    cmd.wincmd('=')
  end,
})

autocmd('BufEnter', {
  callback = function()
    vim.opt_local.formatoptions:remove({
      'c',
      'o',
      'r',
    })
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
