vim.g.lsp_start({
  cmd = { 'vscode-css-language-server', '--stdio' },
  root_patterns = { 'package.json' },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})
