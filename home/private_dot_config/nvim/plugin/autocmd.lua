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

if vim.fn.executable('chezmoi') == 1 then
  local source_dir = vim.json.decode(vim.fn.system({ 'chezmoi', 'data' })).chezmoi.sourceDir
  if source_dir then
    autocmd('BufWritePost', {
      pattern = source_dir .. '/*',
      callback = function(a)
        -- FIXME: synchronous is bad:(
        local output = vim.fn.system({ 'chezmoi', 'apply', '--no-tty', '--source-path', a.match })
        if #output ~= 0 and vim.v.shell_error ~= 0 then
          vim.notify(output, vim.log.levels.INFO, { title = 'chezmoi' })
        end
      end,
      desc = 'run chezmoi apply whenever a dotfile is saved',
    })
  end
end

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
    vim.cmd.tabdo({ 'wincmd', '=' })
  end,
  desc = 'Resize window',
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

autocmd({ 'BufWritePre', 'FileWritePre' }, {
  callback = function()
    local dir = fn.expand('<afile>:p:h')
    if fn.isdirectory(dir) == 0 then
      fn.mkdir(dir, 'p')
    end
  end,
})

autocmd('ModeChanged', {
  group = group,
  pattern = '*:[vV\x16]',
  callback = function()
    vim.opt_local.listchars:append({ space = '·' })
  end,
})

autocmd('ModeChanged', {
  group = group,
  pattern = '[vV\x16]*:*',
  callback = function()
    vim.opt_local.listchars:remove('space')
  end,
})
