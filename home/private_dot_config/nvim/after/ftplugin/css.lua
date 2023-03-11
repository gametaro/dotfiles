vim.lsp.start({
  cmd = { 'vscode-css-language-server', '--stdio' },
  root_names = { 'package.json' },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})
