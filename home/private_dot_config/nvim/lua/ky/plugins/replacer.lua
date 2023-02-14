return {
  'gabrielpoca/replacer.nvim',
  ft = 'qf',
  init = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'qf',
      callback = function(a)
        vim.keymap.set('n', 'r', function()
          require('replacer').run({ rename_files = false })
        end, { buffer = a.buf, desc = 'Replace' })
      end,
    })
  end,
}
