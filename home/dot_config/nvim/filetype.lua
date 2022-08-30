vim.filetype.add({
  extension = {
    ['code-workspace'] = 'jsonc',
  },
  pattern = {
    ['Jenkinsfile.*'] = 'groovy',
    ['tsconfig.*%.json'] = 'jsonc',
  },
})
