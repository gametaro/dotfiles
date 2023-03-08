return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-cmdline' },
    { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
    { 'hrsh7th/cmp-emoji' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'f3fora/cmp-spell' },
    { 'windwp/nvim-autopairs', cond = false },
    {
      'petertriho/cmp-git',
      config = function()
        require('cmp_git').setup({
          filetypes = { 'gitcommit', 'NeogitCommitMessage' },
        })
      end,
    },
  },
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    local cmp = require('cmp')
    local compare = require('cmp.config.compare')

    local api = vim.api

    ---@see https://github.com/lukas-reineke/cmp-under-comparator
    local function compare_under_comparator(entry1, entry2)
      local _, entry1_under = entry1.completion_item.label:find('^_+')
      local _, entry2_under = entry2.completion_item.label:find('^_+')

      return (entry1_under or 0) < (entry2_under or 0)
    end

    local window = {
      border = vim.g.border,
      winhighlight = table.concat({
        'Normal:NormalFloat',
        'FloatBorder:FloatBorder',
        'CursorLine:PmenuSel',
        'Search:None',
      }, ','),
    }

    local config = {
      completion = {
        keyword_pattern = [[\k\+]],
      },
      confirmation = {
        default_behavior = 'replace',
      },
      window = {
        completion = cmp.config.window.bordered(window),
        documentation = cmp.config.window.bordered(window),
      },
      sorting = {
        priority_weight = 2,
        comparators = {
          compare.offset,
          compare.exact,
          -- compare.scopes,
          compare.score,
          compare.recently_used,
          compare_under_comparator,
          compare.locality,
          -- compare.kind,
          compare.sort_text,
          -- compare.length,
          compare.order,
        },
      },
      experimental = {
        ghost_text = {
          hl_group = 'LspCodeLens',
        },
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-f>'] = { i = cmp.mapping.scroll_docs(4) },
        ['<C-b>'] = { i = cmp.mapping.scroll_docs(-4) },
        ['<C-n>'] = { i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<C-p>'] = { i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
        ['<C-Space>'] = { i = cmp.mapping.complete() },
        ['<C-e>'] = { i = cmp.mapping.abort() },
        ['<CR>'] = {
          i = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Replace }),
        },
        ['<C-y>'] = {
          i = cmp.mapping.confirm({ select = true, behavior = cmp.SelectBehavior.Insert }),
        },
      },
      formatting = {
        deprecated = true,
        fields = vim.g.nerd and { 'kind', 'abbr' } or { 'abbr', 'kind' },
        format = function(entry, vim_item)
          if vim.tbl_contains({ 'path' }, entry.source.name) then
            local ok, devicons = pcall(require, 'nvim-web-devicons')
            if ok then
              local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
                return vim_item
              end
            end
          end
          vim_item.kind = require('ky.ui').icons.kind[vim_item.kind]
          return vim_item
        end,
      },
      sources = cmp.config.sources({
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
      }, {
        {
          name = 'buffer',
          option = {
            get_bufnrs = function()
              return vim.tbl_filter(function(buf)
                local buftype = api.nvim_buf_get_option(buf, 'buftype')
                return api.nvim_buf_is_loaded(buf)
                  and not vim.tbl_contains({
                    -- 'help',
                    'nofile',
                    'prompt',
                    'quickfix',
                    'terminal',
                  }, buftype)
                  and not (vim.api.nvim_buf_line_count(buf) > vim.g.max_line_count)
              end, api.nvim_list_bufs())
            end,
          },
        },
      }),
    }

    local cmdline_mapping = cmp.mapping.preset.cmdline({
      ['<C-n>'] = {
        c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      },
      ['<C-p>'] = {
        c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      },
    })

    cmp.setup(config)
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmdline_mapping,
      sources = cmp.config.sources({
        {
          name = 'buffer',
          option = {
            keyword_pattern = [[\k\+]],
            get_bufnrs = function()
              local buf = vim.api.nvim_get_current_buf()
              return vim.api.nvim_buf_line_count(buf) > vim.g.max_line_count and {}
                or { api.nvim_get_current_buf() }
            end,
          },
        },
      }, {
        { name = 'nvim_lsp_document_symbol' },
      }),
    })
    cmp.setup.cmdline(':', {
      mapping = cmdline_mapping,
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })
    cmp.setup.filetype({ 'gitcommit', 'NeogitCommitMessage' }, {
      sources = cmp.config.sources({
        { name = 'buffer' },
        { name = 'git' },
        { name = 'luasnip' },
      }, {
        { name = 'spell' },
      }),
    })
    cmp.setup.filetype({ 'markdown' }, {
      sources = cmp.config.sources({
        { name = 'buffer' },
        { name = 'emoji' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'spell' },
      }),
    })
  end,
}
