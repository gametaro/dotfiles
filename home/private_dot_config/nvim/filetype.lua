vim.filetype.add({
  extension = {
    ['code-workspace'] = 'jsonc',
  },
  filename = {
    ['.ecrc'] = 'json',
  },
  pattern = {
    ['Jenkinsfile.*'] = 'groovy',
    ['tsconfig.*%.json'] = 'jsonc',
  },
})
