local group = vim.api.nvim_create_augroup('mine', {})

---@param event string|string[]
---@param opts { pattern: string|table, buffer: integer, desc: string, callback: function, command: string, once: boolean, nested: boolean  }
local autocmd = function(event, opts)
  opts = opts or {}
  return vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = group }, opts))
end

autocmd('QuickFixCmdPost', {
  pattern = '[^l]*',
  nested = true,
  callback = function()
    vim.cmd.cwindow()
  end,
  desc = 'automatically open the quickfix window',
})

autocmd('QuickFixCmdPost', {
  pattern = 'l*',
  nested = true,
  callback = function()
    vim.cmd.lwindow()
  end,
  desc = 'automatically open the location list window',
})

autocmd('FileType', {
  pattern = { 'help', 'capture', 'lspinfo', 'null-ls-info', 'scratch' },
  callback = function(a)
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf, nowait = true })
  end,
  desc = 'Close current window',
})

autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight the yanked region',
})

if vim.fn.executable('chezmoi') == 1 then
  local source_dir = vim.json.decode(vim.fn.system({ 'chezmoi', 'data' })).chezmoi.sourceDir
  if source_dir then
    autocmd('BufWritePost', {
      pattern = source_dir .. '/*',
      callback = function(a)
        require('ky.util').job(
          'chezmoi',
          { 'apply', '--no-tty', '--source-path', a.match },
          function(code, data)
            if code ~= 0 then
              vim.notify(data, vim.log.levels.WARN)
            end
          end
        )
      end,
      desc = 'Run chezmoi apply whenever dotfiles were saved',
    })
  end
end

autocmd('FocusLost', {
  nested = true,
  callback = function()
    vim.cmd.wall({ mods = { emsg_silent = true, silent = true } })
  end,
})

autocmd('BufLeave', {
  callback = function(a)
    if
      vim.bo[a.buf].buftype == ''
      and vim.bo[a.buf].filetype ~= ''
      and vim.bo[a.buf].modifiable
    then
      vim.cmd.update({ mods = { emsg_silent = true, silent = true } })
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
      vim.cmd.diffupdate()
    end
  end,
})

autocmd('VimResized', {
  callback = function()
    local tab = vim.api.nvim_get_current_tabpage()
    vim.cmd.tabdo({ 'wincmd', '=' })
    vim.api.nvim_set_current_tabpage(tab)
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
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
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

autocmd({ 'BufEnter', 'VimEnter' }, {
  callback = function(a)
    if vim.bo[a.buf].buftype ~= '' then
      return
    end
    local root = require('ky.util').get_root_by_patterns()
      or require('ky.util').get_root_by_lsp({ buffer = a.buf })
    vim.cmd.tcd(root or vim.fs.dirname(vim.api.nvim_buf_get_name(a.buf)))
  end,
})
