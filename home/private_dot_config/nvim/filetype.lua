vim.filetype.add({
  extension = {
    ['code-workspace'] = 'jsonc',
    ['tmpl'] = 'gotmpl',
  },
  filename = {
    ['.ecrc'] = 'json',
    ['containers.conf'] = 'toml',
  },
  pattern = {
    ['Jenkinsfile.*'] = 'groovy',
    ['tsconfig.*%.json'] = 'jsonc',
    ['.*/containers/.*%.conf'] = 'toml',
    ['.*/containers.conf.d/.*%.conf'] = 'toml',
    ['.*/git/config.*'] = 'gitconfig',
    ['.*/readline/.*inputrc.*'] = 'readline',
    ['.*/zsh/.*'] = 'zsh',
  },
})
