local actions = require 'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require 'lir.clipboard.actions'

require('lir').setup {
  hide_cursor = false,
  show_hidden_files = false,
  devicons_enable = true,
  mappings = {
    ['l'] = actions.edit,
    ['o'] = actions.edit,
    ['<CR>'] = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['h'] = actions.up,
    ['q'] = actions.quit,

    ['m'] = actions.mkdir,
    ['a'] = actions.newfile,
    ['r'] = actions.rename,
    ['@'] = actions.cd,
    ['y'] = actions.yank_path,
    ['.'] = actions.toggle_show_hidden,
    ['d'] = actions.delete,

    ['J'] = function()
      mark_actions.toggle_mark()
      vim.cmd 'normal! j'
    end,
    ['c'] = clipboard_actions.copy,
    ['x'] = clipboard_actions.cut,
    ['p'] = clipboard_actions.paste,
    ['~'] = function()
      vim.cmd('edit ' .. vim.fn.expand '$HOME')
    end,
    ['+'] = function()
      local dir = require('lspconfig.util').find_git_ancestor(vim.fn.getcwd())
      if dir == nil or dir == '' then
        return
      end
      vim.cmd('e ' .. dir)
    end,
  },
  float = {
    winblend = 0,
    curdir_window = {
      enable = true,
      highlight_dirname = true,
    },
  },
}

require('lir.git_status').setup {
  show_ignored = false,
}

-- use visual mode
function _G.LirSettings()
  vim.api.nvim_buf_set_keymap(
    0,
    'x',
    'J',
    ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
    { noremap = true, silent = true }
  )
end

vim.api.nvim_set_keymap('n', '-', [[<Cmd>execute 'e ' .. expand('%:p:h')<CR>]], { noremap = true })

vim.cmd [[augroup lir-settings]]
vim.cmd [[  autocmd!]]
vim.cmd [[  autocmd Filetype lir :lua LirSettings()]]
vim.cmd [[augroup END]]
