local ok = prequire('marks')
if not ok then
  return
end

require('marks').setup({
  default_mappings = false,
  -- builtin_marks = { '.', '^', "'", '"' },
  excluded_filetypes = {
    '',
    'gitcommit',
    'gitrebase',
    'lspinfo',
    'null-ls-info',
  },
})
