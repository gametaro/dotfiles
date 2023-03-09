return {
  'folke/todo-comments.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = { 'TodoQuickFix', 'TodoLocList' },
  init = function()
    vim.keymap.set('n', '<Leader>tq', vim.cmd.TodoQuickFix, { desc = 'Todo quickfix' })
    vim.keymap.set('n', '<Leader>tl', vim.cmd.TodoLocList, { desc = 'Todo loclist' })
    vim.keymap.set('n', ']t', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next todo comment' })

    vim.keymap.set('n', '[t', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Previous todo comment' })
  end,
  config = function()
    require('todo-comments').setup({
      signs = false,
      search = vim.fn.executable('git') == 1 and require('ky.util').is_git_repo() and {
        command = 'git',
        args = {
          '--no-pager',
          'grep',
          '-I',
          '-E',
          '--no-color',
          '--line-number',
          '--column',
        },
      } or {
        command = 'rg',
        args = {
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
      },
    })
  end,
}
