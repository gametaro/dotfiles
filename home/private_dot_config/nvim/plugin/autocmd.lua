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
  desc = 'Automatically open quickfix window',
})

autocmd('QuickFixCmdPost', {
  pattern = 'l*',
  nested = true,
  callback = function()
    vim.cmd.lwindow()
  end,
  desc = 'Automatically open location list window',
})

autocmd('FileType', {
  pattern = { 'help', 'null-ls-info', 'scratch' },
  callback = function(a)
    vim.keymap.set('n', 'q', '<C-w>c', { buffer = a.buf, nowait = true })
  end,
  desc = 'Close current window',
})

autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight yanked region',
})

if vim.env.CHEZMOI_WORKING_TREE then
  autocmd('BufWritePost', {
    pattern = vim.env.CHEZMOI_WORKING_TREE .. '/*',
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

autocmd({ 'BufLeave', 'WinLeave', 'FocusLost' }, {
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
  desc = 'Update diff',
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
  pattern = '*:[vV\x16]',
  callback = function()
    vim.opt_local.listchars:append({ space = '·' })
  end,
})

autocmd('ModeChanged', {
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
    local root = require('ky.util').get_root_by_names()
      or require('ky.util').get_root_by_lsp({ buffer = a.buf })
    vim.cmd.tcd(root or vim.fn.getcwd())
  end,
})

autocmd({ 'BufReadPre', 'BufReadPost' }, {
  callback = function(a)
    local is_large = vim.api.nvim_buf_line_count(a.buf) > vim.g.max_line_count
    if is_large then
      if a.event == 'BufReadPre' then
        vim.opt_local.foldmethod = 'manual'
        vim.opt_local.list = false
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undolevels = -1
        vim.opt_local.undoreload = 0
      end

      if a.event == 'BufReadPost' then
        -- disable indentation based on treesitter
        vim.opt_local.indentexpr = ''
        vim.b.editorconfig = false
      end
    end
  end,
  desc = 'Disable options on large file',
})
