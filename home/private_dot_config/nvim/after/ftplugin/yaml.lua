vim.g.lsp_start({
  cmd = { 'yaml-language-server', '--stdio' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      format = true,
      schemas = {
        -- https://github.com/awslabs/goformation
        -- https://github.com/redhat-developer/yaml-language-server#more-examples-of-schema-association
        ['https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json'] = {
          'template.yaml',
          '*-template.yaml',
        },
      },
    },
  },
})
