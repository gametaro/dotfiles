local ok = prequire('cmp_git')
if not ok then
  return
end

require('cmp_git').setup {
  filetypes = { 'gitcommit', 'NeogitCommitMessage' },
}
