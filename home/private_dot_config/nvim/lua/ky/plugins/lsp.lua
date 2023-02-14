return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'jose-elias-alvarez/typescript.nvim' },
    { 'b0o/schemastore.nvim' },
    { 'lukas-reineke/lsp-format.nvim' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'folke/neodev.nvim', config = true },
    {
      'williamboman/mason.nvim',
      opts = {
        ui = {
          border = vim.g.border,
        },
      },
      cmd = 'Mason',
    },
    { 'williamboman/mason-lspconfig.nvim', opts = { automatic_installation = false } },
    { 'folke/neoconf.nvim', config = true },
  },
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    vim.lsp.set_log_level(vim.log.levels.ERROR)

    require('lsp-format').setup({
      typescript = {
        exclude = { 'tsserver', 'eslint' },
      },
      lua = {
        exclude = { 'sumneko_lua' },
      },
      html = {
        exclude = { 'html' },
      },
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    ---@param client table
    ---@param bufnr integer
    local on_attach = function(client, bufnr)
      ---@param mode string|string[]
      ---@param lhs string
      ---@param rhs function
      ---@param opts? table
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto definition' })
      map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto declaration' })
      map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
      map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Goto implementation' })
      -- map('n', 'gt', vim.lsp.buf.type_definition, { desc = 'Goto type definition' })
      map('n', 'K', function()
        ---@param subject string
        local function help(subject)
          -- close a window if it's floating
          local win = vim.api.nvim_get_current_win()
          if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, true)
          end

          vim.cmd.help(subject)
        end

        ---@param cword string
        ---@return string?
        local function get_subject(cword)
          return string.match(cword, '^|(%S-)|$')
            or string.match(cword, "^'(%S-)'$")
            or string.match(cword, '^`:(%S-)`$')
        end

        local cword = vim.fn.expand('<cWORD>')
        local subject = get_subject(cword)
        if subject then
          help(subject)
          return
        end

        vim.lsp.buf.hover()
      end, { desc = 'Hover' })
      map('i', '<C-s>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
      -- map('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder)
      -- map('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder)
      -- map('n', '<Leader>wl', function()
      --   vim.pretty_print(vim.lsp.buf.list_workspace_folders())
      -- end)
      map('n', '<Leader>cr', function()
        if pcall(require, 'inc_rename') then
          return ':IncRename ' .. vim.fn.expand('<cword>')
        else
          vim.lsp.buf.rename()
        end
      end, { expr = true, desc = 'Rename' })
      map({ 'n', 'x' }, '<Leader>ca', function()
        vim.lsp.buf.code_action({
          apply = true,
        })
      end, { desc = 'Code action' })
      map('n', '<Leader>cl', vim.lsp.codelens.run, { desc = 'Codelens' })
      map({ 'n', 'x' }, '<M-f>', function()
        vim.lsp.buf.format({
          async = true,
          bufnr = bufnr,
          filter = function(c)
            return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
          end,
        })
      end, { desc = 'Format' })

      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end

      -- vim.api.nvim_create_autocmd('CursorHold', {
      --   buffer = bufnr,
      --   callback = function()
      --     local opts = {
      --       focusable = false,
      --       close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
      --       border = require('ky.ui').border,
      --       scope = 'cursor',
      --     }
      --     vim.diagnostic.open_float(nil, opts)
      --   end,
      -- })
    end

    ---@type table<string, function>
    local custom_on_attach = {
      eslint = function(client)
        client.server_capabilities.documentFormattingProvider = true
        client.config.settings.format.enable = true
      end,
    }

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('mine__lsp', {}),
      callback = function(a)
        if not a.data.client_id then
          return
        end

        local client = vim.lsp.get_client_by_id(a.data.client_id)
        on_attach(client, a.buf)
        require('lsp-format').on_attach(client)

        if custom_on_attach[client.name] then
          custom_on_attach[client.name](client)
        end
      end,
    })

    ---@type table<string, table>
    local configs = {
      angularls = {},
      bashls = {},
      cssls = {},
      dockerls = {},
      eslint = {
        settings = {
          format = { enable = true },
        },
      },
      html = {},
      jsonls = {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      marksman = {},
      pylsp = {},
      sqlls = {},
      yamlls = {
        settings = {
          yaml = {
            schemas = require('schemastore').json.schemas(),
            -- for cloudformation
            -- see https://github.com/aws-cloudformation/cfn-lint-visual-studio-code/issues/69
            customTags = {
              '!And',
              '!And sequence',
              '!If',
              '!If sequence',
              '!Not',
              '!Not sequence',
              '!Equals',
              '!Equals sequence',
              '!Or',
              '!Or sequence',
              '!FindInMap',
              '!FindInMap sequence',
              '!Base64',
              '!Join',
              '!Join sequence',
              '!Cidr',
              '!Ref',
              '!Sub',
              '!Sub sequence',
              '!GetAtt',
              '!GetAZs',
              '!ImportValue',
              '!ImportValue sequence',
              '!Select',
              '!Select sequence',
              '!Split',
              '!Split sequence',
            },
          },
        },
      },
      lua_ls = {},
    }

    for server, config in pairs(configs) do
      config.capabilities = capabilities
      require('lspconfig')[server].setup(config)
    end

    require('typescript').setup({
      server = {
        on_attach = on_attach,
        capabilities = capabilities,
      },
    })
  end,
}
