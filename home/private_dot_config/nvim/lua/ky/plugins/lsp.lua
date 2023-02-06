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
  event = 'BufReadPre',
  config = function()
    local lsp = vim.lsp
    lsp.set_log_level(vim.log.levels.ERROR)

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

      -- See `:help lsp.*` for documentation on any of the below functions
      map('n', 'gD', lsp.buf.declaration)
      map('n', 'gd', lsp.buf.definition)
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

        lsp.buf.hover()
      end)
      map('n', 'gI', lsp.buf.implementation)
      map('i', '<C-s>', lsp.buf.signature_help)
      map('n', '<LocalLeader>wa', lsp.buf.add_workspace_folder)
      map('n', '<LocalLeader>wr', lsp.buf.remove_workspace_folder)
      map('n', '<LocalLeader>wl', function()
        vim.pretty_print(lsp.buf.list_workspace_folders())
      end)
      map('n', '<LocalLeader>D', lsp.buf.type_definition)
      map('n', '<LocalLeader>rN', lsp.buf.rename)
      map('n', '<LocalLeader>rn', function()
        return ':IncRename ' .. vim.fn.expand('<cword>')
      end, { expr = true })
      map({ 'n', 'x' }, '<LocalLeader>ca', function()
        lsp.buf.code_action({
          apply = true,
        })
      end)
      map('n', 'gr', lsp.buf.references)
      map('n', '<LocalLeader>cl', lsp.codelens.run)

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

      map({ 'n', 'x' }, '<M-f>', function()
        lsp.buf.format({
          async = true,
          bufnr = bufnr,
          filter = function(c)
            return not vim.tbl_contains({ 'sumneko_lua' }, c.name)
          end,
        })
      end)
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

        local client = lsp.get_client_by_id(a.data.client_id)
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
      sumneko_lua = {},
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
