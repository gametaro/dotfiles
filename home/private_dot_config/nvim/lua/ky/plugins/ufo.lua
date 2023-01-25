return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  event = 'BufReadPre',
  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
        if vim.wo.diff then
          return { 'treesitter', 'indent' }
        end
      end,
    })
  end,
}
