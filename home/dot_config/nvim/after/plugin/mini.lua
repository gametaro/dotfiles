local ok = prequire('mini.pairs')
if not ok then return end

require('mini.pairs').setup {
  modes = { insert = false, command = true, terminal = true },
}

vim.keymap.set(
  { 'c', 't' },
  '<C-h>',
  'v:lua.MiniPairs.bs()',
  { expr = true, desc = 'MiniPairs <BS>' }
)

-- vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')
-- require('mini.surround').setup {
--   custom_surroundings = {
--     [')'] = {
--       input = { find = '%(%s-.-%s-%)', extract = '^(.%s*).-(%s*.)$' },
--       output = { left = '( ', right = ' )' },
--     },
--     [']'] = {
--       input = { find = '%[%s-.-%s-%]', extract = '^(.%s*).-(%s*.)$' },
--       output = { left = '[ ', right = ' ]' },
--     },
--     ['}'] = {
--       input = { find = '{%s-.-%s-}', extract = '^(.%s*).-(%s*.)$' },
--       output = { left = '{ ', right = ' }' },
--     },
--     ['>'] = {
--       input = { find = '<%s-.-%s->', extract = '^(.%s*).-(%s*.)$' },
--       output = { left = '< ', right = ' >' },
--     },
--     ['$'] = {
--       input = { find = '%${.-}', extract = '^(..).*(.)$' },
--       output = { left = '${', right = '}' },
--     },
--     s = {
--       input = { find = '%[%[.-%]%]', extract = '^(..).*(..)$' },
--       output = { left = '[[', right = ']]' },
--     },
--     c = {
--       input = { find = '%"%"%".-%"%"%"', extract = '^(...).*(...)$' },
--       output = { left = '"""', right = '"""' },
--     },
--     ['*'] = {
--       input = function()
--         local n_star = MiniSurround.user_input('Number of * to find: ')
--         local many_star = string.rep('%*', tonumber(n_star) or 1)
--         local find = string.format('%s.-%s', many_star, many_star)
--         local extract = string.format('^(%s).*(%s)$', many_star, many_star)
--         return { find = find, extract = extract }
--       end,
--       output = function()
--         local n_star = MiniSurround.user_input('Number of * to output: ')
--         local many_star = string.rep('*', tonumber(n_star) or 1)
--         return { left = many_star, right = many_star }
--       end,
--     },
--   },
--   n_lines = 10,
--   search_method = 'cover_or_nearest',
-- }

require('mini.jump').setup {
  mappings = {
    repeat_jump = '',
  },
}

-- require('mini.jump2d').setup {
--   labels = 'jfkdlsahgnuvrbytmiceoxwpqz',
--   allowed_lines = {
--     blank = false,
--     cursor_at = false,
--   },
--   allowed_windows = {
--     not_current = false,
--   },
-- }

require('mini.indentscope').setup {
  draw = {
    animation = require('mini.indentscope').gen_animation('none'),
  },
  options = {
    try_as_border = true,
  },
  symbol = '|',
}

local group = vim.api.nvim_create_augroup('mine__mini', {})
vim.api.nvim_create_autocmd('FileType', {
  group = group,
  pattern = { '', 'checkhealth', 'help', 'lspinfo', 'man' },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function()
    if vim.tbl_contains({ 'nofile', 'quickfix', 'terminal' }, vim.bo.buftype) then
      vim.b.miniindentscope_disable = true
    end
  end,
})

local trailspace = require('mini.trailspace')
trailspace.setup {}
vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  callback = trailspace.trim,
})

local sessions = require('mini.sessions')
sessions.setup {
  autoread = true,
  autowrite = true,
  directory = '',
  verbose = { read = true, write = true, delete = true },
}
pcall(sessions.write, sessions.config.file, { force = false })

require('mini.comment').setup {
  hooks = {
    pre = function()
      if vim.bo.filetype == 'typescriptreact' then
        require('ts_context_commentstring.internal').update_commentstring()
      end
    end,
  },
}

vim.api.nvim_create_autocmd('CursorMoved', {
  group = group,
  callback = function(a)
    local curword = vim.fn.expand('<cword>')
    local filetype = vim.bo[a.buf].filetype

    local blocklist = {}
    if filetype == 'lua' then
      blocklist = { 'local', 'require' }
    elseif filetype == 'javascript' then
      blocklist = { 'import' }
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    vim.b.minicursorword_disable = string.len(curword) == 1 or vim.tbl_contains(blocklist, curword)
  end,
})
require('mini.cursorword').setup {}
