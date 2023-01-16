vim.g.lsp_start({
  name = 'css',
  cmd = { 'vscode-css-language-server', '--stdio' },
  root_patterns = { 'package.json' },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})
