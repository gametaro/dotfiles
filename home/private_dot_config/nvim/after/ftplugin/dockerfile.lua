vim.lsp.start({
  cmd = { 'docker-langserver', '--stdio' },
  root_names = { 'Dockerfile' },
})
