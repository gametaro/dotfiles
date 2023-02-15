vim.cmd.runtime({ 'ftplugin/typescript/angular.lua', bang = true })
vim.g.lsp_start({
  cmd = { 'vscode-html-language-server', '--stdio' },
  root_patterns = { 'package.json' },
})
