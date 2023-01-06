vim.filetype.add({
  extension = {
    ['code-workspace'] = 'jsonc',
  },
  filename = {
    ['.ecrc'] = 'json',
    ['containers.conf'] = 'toml',
  },
  pattern = {
    ['Jenkinsfile.*'] = 'groovy',
    ['tsconfig.*%.json'] = 'jsonc',
    ['.*/containers.conf.d/.*%.conf'] = 'toml',
  },
})
