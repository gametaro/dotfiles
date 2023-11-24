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
      vim.system({ 'chezmoi', 'apply', '--no-tty', '--source-path', a.match }, nil, function(obj)
        if obj.code ~= 0 and obj.data then
          vim.schedule(function()
            vim.notify(obj.data, vim.log.levels.WARN)
          end)
        end
      end)
    end,
    desc = 'Run chezmoi apply',
  })
end

autocmd({ 'BufLeave', 'WinLeave', 'FocusLost' }, {
  callback = function(a)
    if
      vim.bo[a.buf].buftype == ''
      and vim.bo[a.buf].filetype ~= ''
      and vim.bo[a.buf].modifiable
    then
      vim.cmd.update({ mods = { emsg_silent = true } })
    end
  end,
  desc = 'Auto save',
})

autocmd({ 'FocusGained' }, {
  callback = function()
    vim.cmd.checktime({ mods = { emsg_silent = true } })
  end,
  desc = 'Check if any buffers were changed outside of Nvim',
})

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
  desc = 'Update formatoptions',
})

autocmd({ 'BufWritePre', 'FileWritePre' }, {
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
  desc = 'Automatically make directory',
})

autocmd('ModeChanged', {
  pattern = '*:[vV\x16]',
  callback = function()
    vim.opt_local.listchars:append({ space = '·' })
  end,
  desc = 'Show spaces in visual mode',
})

autocmd('ModeChanged', {
  pattern = '[vV\x16]*:*',
  callback = function()
    vim.opt_local.listchars:remove('space')
  end,
  desc = 'Hide spaces except in visual mode',
})

autocmd({ 'BufEnter', 'VimEnter' }, {
  callback = function(a)
    if not vim.api.nvim_buf_is_valid(a.buf) then
      return
    end
    if vim.bo[a.buf].buftype ~= '' then
      return
    end
    local root = require('ky.util').get_root_by_names()
    vim.cmd.tcd(root or vim.fn.getcwd())
  end,
  desc = 'Change directory to project root',
})

autocmd({ 'BufReadPre', 'BufReadPost' }, {
  callback = function(a)
    local is_large = vim.api.nvim_buf_line_count(a.buf) > vim.g.max_line_count
    local win = vim.api.nvim_get_current_win()
    if is_large then
      if a.event == 'BufReadPre' then
        vim.wo[win][0].foldmethod = 'manual'
        vim.wo[win][0].list = false
        vim.wo[win][0].spell = false
        vim.wo[win][0].swapfile = false
        vim.wo[win][0].undolevels = -1
        vim.wo[win][0].undoreload = 0
      end

      if a.event == 'BufReadPost' then
        -- disable indentation based on treesitter
        vim.bo[a.buf].indentexpr = ''
        vim.b.editorconfig = false
      end
    end
  end,
  desc = 'Disable options on large file',
})

autocmd('VimEnter', {
  callback = function()
    local path = vim.fn.stdpath('config') .. '/spell'
    local addfiles = vim.fs.find(function(name, _)
      return string.match(name, '.+%.add$')
    end, { type = 'file', path = path })
    vim.iter(addfiles):each(function(addfile)
      local spellfile = addfile .. '.spl'
      local add_stat = vim.uv.fs_stat(addfile)
      local spell_stat = vim.uv.fs_stat(spellfile)
      if not spell_stat then
        vim.cmd.mkspell(addfile)
      end
      if add_stat and spell_stat and add_stat.mtime.sec > spell_stat.mtime.sec then
        vim.cmd.mkspell({ addfile, bang = true })
      end
    end)
  end,
  desc = 'Create missing spell file',
})

local function get_lang()
  local ok, parser = pcall(vim.treesitter.get_parser)
  if not ok then
    return
  end

  local cpos = vim.api.nvim_win_get_cursor(0)
  local row, col = cpos[1] - 1, cpos[2]
  local range = { row, col, row, col + 1 }

  local ft --- @type string?

  parser:for_each_tree(function(_tree, ltree)
    if ltree:contains(range) then
      local fts = vim.treesitter.language.get_filetypes(ltree:lang())
      for _, ft0 in ipairs(fts) do
        if vim.filetype.get_option(ft0, 'commentstring') ~= '' then
          ft = fts[1]
          break
        end
      end
    end
  end)
  return ft
end

local function enable_commentstrings()
  vim.api.nvim_create_autocmd({ 'CursorHold' }, {
    buffer = 0,
    callback = function()
      local lang = get_lang() or vim.bo.filetype
      if lang == 'comment' then
        lang = vim.bo.filetype -- Exclude this
      end

      local commentstring = vim.filetype.get_option(lang, 'commentstring')

      if commentstring ~= vim.bo.commentstring then
        vim.bo.commentstring = commentstring
      end
    end,
  })
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    if not pcall(vim.treesitter.start) then
      return
    end

    enable_commentstrings()
  end,
})
