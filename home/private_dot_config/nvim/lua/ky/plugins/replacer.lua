return {
  'gabrielpoca/replacer.nvim',
  ft = 'qf',
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'qf',
      callback = function(a)
        vim.keymap.set('n', 'r', function()
          require('replacer').run({ rename_files = false })
        end, { buffer = a.buf, desc = 'Replace (don\'t rename files)' })
        vim.keymap.set('n', 'R', function()
          require('replacer').run({ rename_files = true })
        end, { buffer = a.buf, desc = 'Replace (rename files)' })
      end,
    })
  end,
}
