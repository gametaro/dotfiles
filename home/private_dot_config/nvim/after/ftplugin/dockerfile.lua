vim.g.lsp_start({
  cmd = { 'docker-langserver', '--stdio' },
  root_patterns = { 'Dockerfile' },
})
