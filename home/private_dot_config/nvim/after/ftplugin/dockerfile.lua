vim.g.lsp_start({
  name = 'docker',
  cmd = { 'docker-langserver', '--stdio' },
  root_patterns = { 'Dockerfile' },
})
