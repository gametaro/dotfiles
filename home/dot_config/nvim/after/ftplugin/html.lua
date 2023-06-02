vim.cmd.runtime({ 'ftplugin/typescript/angular.lua', bang = true })
vim.lsp.start({
  cmd = { 'vscode-html-language-server', '--stdio' },
  root_names = { 'package.json' },
})
