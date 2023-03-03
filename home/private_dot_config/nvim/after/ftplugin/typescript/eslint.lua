-- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
local root_names = {
  '.eslintrc',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
}

if require('ky.util').get_root_by_names(root_names) then
  vim.g.lsp_start({
    cmd = { 'vscode-eslint-language-server', '--stdio' },
    root_names = root_names,
    init_options = {
      provideFormatter = true,
    },
    -- https://raw.githubusercontent.com/microsoft/vscode-eslint/main/%24shared/settings.ts
    -- https://raw.githubusercontent.com/microsoft/vscode-eslint/main/client/src/client.ts
    settings = {
      validate = 'on',
      packageManager = 'npm',
      useESLintClass = false,
      experimental = {
        useFlatConfig = false,
      },
      codeActionOnSave = {
        enable = false,
        mode = 'all',
      },
      format = true,
      quiet = false,
      onIgnoredFiles = 'off',
      rulesCustomizations = {},
      run = 'onType',
      problems = {
        shortenToSingleLine = false,
      },
      -- should not be nil!
      nodePath = '',
      -- workspaceFolder = {},
      -- not `workingDirectories` and needs double brackets!
      workingDirectory = { { mode = 'auto' } }, -- 'location'
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
    },
    on_new_config = function(config, new_root_dir)
      config.settings.workspaceFolder = {
        uri = new_root_dir,
        name = vim.fs.basename(new_root_dir),
      }
    end,
  })
end
