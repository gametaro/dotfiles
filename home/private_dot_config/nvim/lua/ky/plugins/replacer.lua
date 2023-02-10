return {
  'gabrielpoca/replacer.nvim',
  ft = 'qf',
  keys = {
    {
      '<Leader>r',
      function()
        require('replacer').run({ rename_files = false })
      end,
    },
  },
}
