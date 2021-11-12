local icons = require('theme').icons

vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_icons = {
  git = {
    unstaged = 'M',
    staged = 'S',
    unmerged = 'U',
    renamed = 'R',
    untracked = '?',
    deleted = 'D',
  },
}
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}
vim.g.nvim_tree_window_picker_exclude = {
  filetype = {
    'packer',
    'qf',
  },
  buftype = {
    'terminal',
  },
}
vim.g.nvim_tree_respect_buf_cwd = 1

require('nvim-tree').setup {
  auto_close = true,
  hijack_cursor = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = icons.hint,
      info = icons.info,
      warning = icons.warn,
      error = icons.error,
    },
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  filters = {
    dotfiles = false,
    custom = { '.git', 'node_modules', '.cache' },
  },
}

vim.api.nvim_set_keymap('n', '<C-n>', '<Cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })
