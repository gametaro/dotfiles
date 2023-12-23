local essentials = {}
local extensions = {}
local utils = {}

local roots = {}
local terminals = vim.defaulttable(function() return {} end)

local function lazy()
  local lazypath = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy', 'lazy.nvim')
  if not vim.uv.fs_stat(lazypath) then
    print(vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      lazypath,
    }))
  end
  vim.opt.runtimepath:prepend(lazypath)

  vim.keymap.set('n', '<leader>p', '<cmd>Lazy<cr>')
  require('lazy').setup({
    { 'nvim-lua/plenary.nvim' },
    { 'b0o/schemastore.nvim' },
    { 'williamboman/mason.nvim', build = ':MasonUpdate', config = true },
    {
      'nvim-telescope/telescope.nvim',
      config = function()
        local b = require('telescope.builtin')

        vim.keymap.set('n', '<c-p>', function()
          local ok = pcall(b.git_files)
          if not ok then b.find_files() end
        end, { desc = 'Find files' })
        vim.keymap.set('n', '<c-b>', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })
        vim.keymap.set('n', '<c-g>', '<cmd>Telescope live_grep<cr>', { desc = 'Grep' })
        vim.keymap.set('n', '<c-h>', '<cmd>Telescope help_tags<cr>', { desc = 'Help' })
        vim.keymap.set('n', '<c-n>', '<cmd>Telescope oldfiles<cr>', { desc = 'Oldfiles' })

        vim.keymap.set('n', '<leader>gC', '<cmd>Telescope git_bcommits<cr>', { desc = 'Git bcommits' })
        vim.keymap.set('x', '<leader>gC', '<cmd>Telescope git_bcommits_range<cr>', { desc = 'Git bcommits range' })
        vim.keymap.set('n', '<leader>gc', '<cmd>Telescope git_commits<cr>', { desc = 'Git commits' })
        vim.keymap.set('n', '<leader>gs', '<cmd>Telescope git_status<cr>', { desc = 'Git status' })

        require('telescope').setup({
          pickers = {
            buffers = {
              ignore_current_buffer = true,
              sort_lastused = true,
              sort_mru = true,
              only_cwd = true,
            },
            find_files = { hidden = true },
            git_files = { show_untracked = true },
            oldfiles = { only_cwd = true },
          },
        })
      end,
    },
    {
      'sindrets/diffview.nvim',
      cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
      init = function()
        vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'File history' })
        vim.keymap.set('n', '<leader>gf', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Current file history' })
        vim.keymap.set('n', '<leader>gF', '<cmd>DiffviewFileHistory<cr>', { desc = 'File history' })
        vim.keymap.set('x', '<leader>gf', ":'<,'>DiffviewFileHistory<cr>", { desc = 'File history' })
      end,
      config = true,
    },
    {
      'lewis6991/gitsigns.nvim',
      dependencies = 'tpope/vim-repeat',
      opts = {
        on_attach = function(buffer)
          local gs = package.loaded.gitsigns

          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = buffer
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then
              return ']c'
            else
              vim.schedule(function() gs.next_hunk({ greedy = false }) end)
              return '<Ignore>'
            end
          end, { expr = true, desc = 'Next hunk' })
          map('n', '[c', function()
            if vim.wo.diff then
              return '[c'
            else
              vim.schedule(function() gs.prev_hunk({ greedy = false }) end)
              return '<Ignore>'
            end
          end, { expr = true, desc = 'Previous hunk' })
          -- Actions
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
          map(
            'x',
            '<leader>hs',
            function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
            { desc = 'Stage hunk' }
          )
          map(
            'x',
            '<leader>hr',
            function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
            { desc = 'Reset hunk' }
          )
          map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = 'Reset buffer' })
          map('n', '<leader>hp', gs.preview_hunk_inline, { desc = 'Preview hunk' })
          map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame line' })
          map('n', '<leader>hd', gs.diffthis, { desc = 'Diffthis' })
          map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diffthis ~' })
          map('n', '<leader>hq', gs.setqflist, { desc = 'Quickfix' })
          map('n', '<leader>hQ', function() gs.setqflist('all') end, { desc = 'Quickfix' })
          map('n', '<leader>hl', gs.setloclist, { desc = 'Location List' })
          map('n', [[\hb]], gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
          map('n', [[\hd]], gs.toggle_deleted, { desc = 'Toggle deleted' })
          map('n', [[\hw]], gs.toggle_word_diff, { desc = 'Toggle word diff' })
          map({ 'o', 'x' }, 'ih', ':<c-u>Gitsigns select_hunk<cr>', { silent = true, desc = 'Hunk' })
        end,
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          auto_install = true,
          ensure_installed = { 'diff' },
          ignore_install = {
            -- 'bash',
            'c',
            'help',
            'lua',
            'markdown',
            'markdown_inline',
            'python',
            'query',
            'vim',
            'vimdoc',
          },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
      },
      config = function()
        local cmp = require('cmp')

        cmp.setup({
          confirmation = { default_behavior = 'replace' },
          experimental = { ghost_text = true },
          snippet = {
            expand = function(args) vim.snippet.expand(args.body) end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<c-d>'] = cmp.mapping.scroll_docs(-4),
            ['<c-f>'] = cmp.mapping.scroll_docs(4),
            ['<c-Space>'] = cmp.mapping.complete(),
            ['<cr>'] = cmp.mapping.confirm({ select = true }),
          }),
          formatting = { deprecated = true },
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
          }, {
            { name = 'buffer' },
            { name = 'path' },
          }),
        })
      end,
    },
    {
      'echasnovski/mini.nvim',
      config = function()
        require('mini.comment').setup({
          options = { ignore_blank_line = true },
        })

        require('mini.operators').setup()

        require('mini.pairs').setup({
          modes = { insert = true, command = true, terminal = true },
        })
        local function map_bs(lhs, rhs)
          vim.keymap.set({ 'i', 'c', 't' }, lhs, rhs, { expr = true, replace_keycodes = false })
        end
        map_bs('<c-h>', 'v:lua.MiniPairs.bs()')
        map_bs('<c-w>', 'v:lua.MiniPairs.bs("\23")')
        map_bs('<c-u>', 'v:lua.MiniPairs.bs("\21")')

        require('mini.ai').setup({
          custom_textobjects = {
            -- textobj-entire
            e = function()
              local from = { line = 1, col = 1 }
              local to = { line = vim.fn.line('$'), col = math.max(vim.fn.getline('$'):len(), 1) }
              return { from = from, to = to, vis_mode = 'V' }
            end,
            -- textobj-line
            l = function(type)
              if vim.api.nvim_get_current_line() == '' then return end
              vim.cmd.normal({ type == 'i' and '^' or '0', bang = true })
              local from_line, from_col = unpack(vim.api.nvim_win_get_cursor(0))
              local from = { line = from_line, col = from_col + 1 }
              vim.cmd.normal({ type == 'i' and 'g_' or '$', bang = true })
              local to_line, to_col = unpack(vim.api.nvim_win_get_cursor(0))
              local to = { line = to_line, col = to_col + 1 }
              return { from = from, to = to }
            end,
          },
          mappings = {
            around_last = '',
            inside_last = '',
          },
        })
      end,
    },
    {
      'RRethy/vim-illuminate',
      config = function() require('illuminate').configure({ modes_denylist = { 'i' } }) end,
    },
    {
      'kylechui/nvim-surround',
      opts = {
        keymaps = {
          visual = false,
        },
        move_cursor = false,
      },
    },
    {
      'stevearc/conform.nvim',
      keys = {
        {
          '<m-f>',
          function() require('conform').format({ async = true, lsp_fallback = true }) end,
          mode = '',
          desc = 'Format buffer',
        },
      },
      opts = {
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'isort', 'black' },
          javascript = { { 'prettierd', 'prettier' } },
          typescript = { { 'prettierd', 'prettier' } },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
        formatters = {
          shfmt = {
            prepend_args = { '-i', '2' },
          },
        },
      },
      init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
    },
    {
      'mfussenegger/nvim-lint',
      config = function()
        require('lint').linters_by_ft = {
          bash = { 'shellcheck' },
          gitcommit = { 'gitlint' },
          markdown = { 'markdownlint' },
          sh = { 'shellcheck' },
          yaml = { 'actionlint' },
          zsh = { 'zsh' },
        }
        vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
          callback = function() require('lint').try_lint() end,
        })
      end,
    },
    {
      'folke/flash.nvim',
      opts = {
        highlight = { backdrop = false },
        modes = {
          char = {
            char = {
              keys = { 'f', 'F', 't', 'T' },
            },
            highlight = { backdrop = false },
          },
        },
      },
      init = function()
        vim.keymap.set({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end, { desc = 'Flash' })
        vim.keymap.set(
          { 'n', 'x', 'o' },
          'S',
          function() require('flash').treesitter() end,
          { desc = 'Flash Treesitter' }
        )
        vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
        vim.keymap.set(
          { 'o', 'x' },
          'R',
          function() require('flash').treesitter_search() end,
          { desc = 'Treesitter Search' }
        )
        vim.keymap.set({ 'c' }, '<c-s>', function() require('flash').toggle() end, { desc = 'toggle flash search' })
        vim.api.nvim_set_hl(0, 'FlashLabel', { bg = 'NvimDarkBlue' })
      end,
    },
  }, {
    performance = {
      rtp = {
        disabled_plugins = {
          -- "gzip",
          'matchit',
          -- 'matchparen',
          'netrwPlugin',
          'rplugin',
          -- "tarPlugin",
          'tohtml',
          'tutor',
          -- "zipPlugin",
        },
      },
    },
  })
end

---@param names? string|string[]
---@return string?
function utils.get_root(names)
  names = names or { '.git' }
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then return end

  local dirname = vim.fs.dirname(path)
  if not dirname then return end

  roots[dirname] = roots[dirname] or vim.fs.dirname(vim.fs.find(names, { path = dirname, upward = true })[1])

  return roots[dirname]
end

function essentials.highlight()
  ---@type table<string, vim.api.keyset.highlight>
  local highlights = {
    ['@attribute'] = { link = 'Label' },
    ['@text.diff.add'] = { link = 'DiffAdd' },
    ['@text.diff.delete'] = { link = 'DiffDelete' },
  }
  vim.iter(highlights):each(function(k, v) vim.api.nvim_set_hl(0, k, v) end)
end

function essentials.option()
  vim.o.autowriteall = true
  vim.o.backup = true
  vim.opt.backupdir:remove('.')
  vim.o.completeopt = 'menu,menuone,noselect,popup'
  vim.o.confirm = true
  vim.o.diffopt = vim.o.diffopt .. ',algorithm:histogram,indent-heuristic,vertical,linematch:60'
  vim.o.exrc = true
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldlevelstart = 1
  vim.o.foldmethod = 'expr'
  vim.o.foldtext = 'v:lua.vim.treesitter.foldtext()'
  vim.o.ignorecase = true
  vim.o.jumpoptions = 'view'
  vim.o.sessionoptions = 'buffers,tabpages,folds'
  vim.o.shortmess = vim.o.shortmess .. 'IWcs'
  vim.o.signcolumn = 'yes'
  vim.o.smartcase = true
  vim.o.splitkeep = 'screen'
  vim.o.undofile = true
  vim.o.wildignorecase = true
  vim.o.wildoptions = vim.o.wildoptions .. ',fuzzy'
  vim.o.wrap = false
end

function essentials.keymap()
  vim.keymap.set('', '<space>', '')
  vim.keymap.set('', ';', ':')
  vim.keymap.set('c', '<c-a>', '<home>')
  vim.keymap.set('c', '<c-b>', '<left>')
  vim.keymap.set('c', '<c-e>', '<end>')
  vim.keymap.set('c', '<c-f>', '<right>')
  vim.keymap.set('c', '<c-n>', '<down>')
  vim.keymap.set('c', '<c-p>', '<up>')
  vim.keymap.set('c', '<m-b>', '<s-left>')
  vim.keymap.set('c', '<m-f>', '<s-right>')
  vim.keymap.set('n', '<m-h>', '<c-w>h', { desc = 'Go to right window' })
  vim.keymap.set('n', '<m-j>', '<c-w>j', { desc = 'Go to left window' })
  vim.keymap.set('n', '<m-k>', '<c-w>k', { desc = 'Go to down window' })
  vim.keymap.set('n', '<m-l>', '<c-w>l', { desc = 'Go to up window' })
  vim.keymap.set('t', '<esc>', [[<c-\><c-n>]])
  vim.keymap.set(
    't',
    '<c-r>',
    function() return [[<c-\><c-n>"]] .. vim.fn.nr2char(vim.fn.getchar()) .. 'pi' end,
    { expr = true }
  )
  vim.keymap.set('n', 'x', '"_x')
  vim.keymap.set('n', '-', function() vim.cmd.edit('%:h') end)
  vim.keymap.set('s', '<bs>', '<bs>i')
  vim.keymap.set('s', '<c-h>', '<c-h>i')
  vim.keymap.set(
    '',
    '0',
    function() return vim.fn.col('.') - 1 == vim.fn.indent('.') and '0' or '^' end,
    { expr = true, desc = 'Moves cursor to line start or first non-blank character' }
  )

  vim.keymap.set('n', [[\c]], '<cmd>setlocal cul! cul?<cr>', { desc = 'Toggle cursorline' })
  vim.keymap.set('n', [[\f]], '<cmd>setlocal fen! fen?<cr>', { desc = 'Toggle fold' })
  vim.keymap.set('n', [[\l]], '<cmd>setlocal list! list?<cr>', { desc = 'Toggle list' })
  vim.keymap.set('n', [[\n]], '<cmd>setlocal nu! nu?<cr>', { desc = 'Toggle number' })
  vim.keymap.set('n', [[\N]], '<cmd>setlocal rnu! rnu?<cr>', { desc = 'Toggle relativenumber' })
  vim.keymap.set('n', [[\w]], '<cmd>setlocal wrap! wrap?<cr>', { desc = 'Toggle wrap' })
  vim.keymap.set('n', [[\d]], function()
    if vim.diagnostic.is_disabled(0) then
      vim.diagnostic.enable(0)
    else
      vim.diagnostic.disable(0)
    end
  end, { desc = 'Toggle diagnostic' })
  vim.keymap.set('n', [[\i]], function()
    if vim.lsp.inlay_hint.is_enabled(0) then
      vim.lsp.inlay_hint.enable(0, false)
    else
      vim.lsp.inlay_hint.enable(0, true)
    end
  end, { desc = 'Toggle inlay hints' })

  vim.keymap.set(
    { 'i', 's' },
    '<esc>',
    function() return vim.snippet.active() and '<cmd>lua vim.snippet.exit()<cr><esc>' or '<Esc>' end,
    { expr = true }
  )
  vim.keymap.set(
    { 'i', 's' },
    '<tab>',
    function() return vim.snippet.jumpable(1) and '<cmd>lua vim.snippet.jump(1)<cr>' or '<tab>' end,
    { expr = true }
  )
  vim.keymap.set(
    { 'i', 's' },
    '<s-tab>',
    function() return vim.snippet.jumpable(-1) and '<cmd>lua vim.snippet.jump(-1)<cr>' or '<s-tab>' end,
    { expr = true }
  )

  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
  vim.keymap.set('n', '<leader>dK', vim.diagnostic.open_float, { desc = 'Float' })
  vim.keymap.set('n', '<leader>dq', vim.diagnostic.setqflist, { desc = 'Quickfix' })
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Location list' })

  vim.keymap.set('n', 't', function()
    local count = vim.v.count1
    local cwd = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(0))

    local buf = terminals[cwd][count]
    if buf and vim.api.nvim_buf_is_loaded(buf) then
      vim.cmd.buffer(buf)
      return
    end

    vim.cmd.terminal()
    terminals[cwd][count] = vim.api.nvim_get_current_buf()
  end, { desc = 'Open terminal' })
end

function essentials.autocmd()
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
    desc = 'Highlight yanked region',
  })

  vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    callback = function() vim.cmd.checktime({ mods = { emsg_silent = true } }) end,
    desc = 'Check if any buffers were changed outside of Nvim',
  })

  vim.api.nvim_create_autocmd('BufWritePost', {
    callback = function()
      if vim.wo.diff then vim.cmd.diffupdate() end
    end,
    desc = 'Update diff',
  })

  vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
    callback = function()
      local dir = vim.fn.expand('<afile>:p:h')
      if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, 'p') end
    end,
    desc = 'Automatically make directories',
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'help', 'checkhealth' },
    callback = function(a) vim.keymap.set('n', 'q', '<c-w>c', { buffer = a.buf, nowait = true }) end,
    desc = 'Close current window',
  })

  vim.api.nvim_create_autocmd('VimResized', {
    callback = function()
      local tab = vim.api.nvim_get_current_tabpage()
      vim.cmd.tabdo({ 'wincmd', '=' })
      vim.api.nvim_set_current_tabpage(tab)
    end,
    desc = 'Resize window',
  })

  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave', 'FocusLost' }, {
    callback = function(a)
      if vim.bo[a.buf].buftype == '' and vim.bo[a.buf].filetype ~= '' and vim.bo[a.buf].modifiable then
        vim.cmd.update({ mods = { emsg_silent = true } })
      end
    end,
    desc = 'Auto save',
  })

  vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter' }, {
    callback = function(a)
      if not vim.api.nvim_buf_is_valid(a.buf) then return end
      if vim.bo[a.buf].buftype ~= '' then return end
      vim.cmd.tcd(utils.get_root() or vim.fn.getcwd())
    end,
    desc = 'Change directory to project root',
  })

  vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
    group = vim.api.nvim_create_augroup('dotenv', {}),
    callback = function()
      local file = vim.fs.find('.env', { type = 'file', upward = true, stop = vim.fs.dirname(vim.uv.cwd()) })[1]
      if not file then return end

      vim.iter(io.lines(file)):filter(function(line) return not vim.startswith(line, '#') end):each(function(line)
        local key, value = line:match('([^=]+)=([^=]+)')
        if key and value then
          value = value:gsub('^["\']', ''):gsub('["\']$', '')
          vim.env[key] = vim.trim(value)
        end
      end)
    end,
    desc = 'Load and set environment variables from the .env file',
  })

  vim.api.nvim_create_autocmd('BufRead', {
    callback = function(a)
      vim.api.nvim_create_autocmd('BufWinEnter', {
        once = true,
        buffer = a.buf,
        callback = function()
          local ft = vim.bo[a.buf].filetype
          local last_known_line = vim.api.nvim_buf_get_mark(a.buf, '"')[1]
          if
            not (ft:match('commit') and ft:match('rebase'))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(a.buf)
          then
            vim.api.nvim_feedkeys([[g`"]], 'nx', false)
          end
        end,
      })
    end,
    desc = 'Restore cursor position',
  })

  vim.api.nvim_create_autocmd('TermOpen', {
    pattern = 'term://*',
    callback = function() vim.cmd.startinsert() end,
    desc = 'Start in Terminal mode',
  })
end

function essentials.lsp()
  local jsts = {
    cmd = { 'vtsls', '--stdio' },
    settings = {
      javascript = {
        suggest = {
          completeFunctionCalls = true,
        },
      },
    },
  }
  local css = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
  }
  local json = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    init_options = {
      provideFormatter = true,
    },
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  }

  local configs = {
    json = json,
    jsonc = json,
    lua = {
      cmd = { 'lua-language-server' },
    },
    css = css,
    scss = css,
    html = {
      cmd = { 'vscode-html-language-server', '--stdio' },
    },
    sh = {
      cmd = { 'bash-language-server', 'start' },
    },
    yaml = {
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
    },
    javascript = jsts,
    typescript = jsts,
    javascriptreact = jsts,
    typescriptreact = jsts,
  }

  local function start(config, opts)
    config = config or {}
    local root_dir = config.root_dir or utils.get_root(config.root_names)

    if config.cmd then
      local original = config.cmd[1]
      config.cmd[1] = vim.fn.exepath(config.cmd[1])
      if #config.cmd[1] == 0 then config.cmd[1] = original end
    end

    config = vim.tbl_deep_extend('force', config, {
      capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      ),
      root_dir = root_dir,
    })
    vim.lsp.start(config, opts)
  end

  local group = vim.api.nvim_create_augroup('lsp', {})
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    callback = function(a)
      local ft = a.match
      if configs[ft] then start(configs[ft]) end
    end,
    desc = 'Start lsp server',
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(a)
      local client = vim.lsp.get_client_by_id(a.data.client_id)
      if not client then return end

      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = a.buf
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
      map('n', 'gR', vim.lsp.buf.references, { desc = 'References' })
      map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
      map('i', '<c-s>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
      map('n', '<leader>cl', vim.lsp.codelens.run, { desc = 'Codelens' })
      map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename' })
      map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
      -- map({ 'n', 'x' }, '<m-f>', vim.lsp.buf.format, { desc = 'Format' })
    end,
    desc = 'Attach to lsp server',
  })
end

function extensions.keyword()
  local function is_keyword_char()
    local char = vim.fn.strcharpart(vim.fn.strpart(vim.fn.getline('.'), vim.fn.col('.') - 1), 0, 1)
    return vim.regex([[\k]]):match_str(char)
  end

  local function keyword_motion(motion)
    for _ = 1, vim.v.count1 do
      local current_pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd.normal({ motion, bang = true })

      while not is_keyword_char() do
        local new_pos = vim.api.nvim_win_get_cursor(0)
        if current_pos[1] == new_pos[1] and current_pos[2] == new_pos[2] then break end
        vim.cmd.normal({ motion, bang = true })
        current_pos = new_pos
      end
    end
  end

  vim.iter({ 'w', 'b', 'e', 'ge' }):each(function(motion)
    vim.keymap.set({ 'n', 'x' }, motion, function() keyword_motion(motion) end)
  end)
end

function extensions.niceblock()
  vim
    .iter({
      I = { v = '<c-v>I', V = '<c-v>^o^I', ['\22'] = 'I' },
      A = { v = '<c-v>A', V = '<c-v>0o$A', ['\22'] = 'A' },
      gI = { v = '<c-v>0I', V = '<c-v>0o$I', ['\22'] = '0I' },
    })
    :each(function(k, v)
      vim.keymap.set('x', k, function() return v[vim.api.nvim_get_mode().mode] end, { expr = true, desc = 'Niceblock' })
    end)
end

function extensions.session()
  vim.api.nvim_create_autocmd('VimLeavePre', {
    callback = function()
      if vim.fn.argc(-1) > 0 then vim.cmd('%argdelete') end
      vim.cmd.mksession({ bang = true })
    end,
    desc = 'Save session',
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    nested = true,
    callback = function()
      local session_file = 'Session.vim'
      if vim.fn.argc(-1) == 0 and vim.uv.fs_stat(session_file) then
        vim.cmd.source({ session_file, mods = { emsg_silent = true } })
      end
    end,
    desc = 'Restore session',
  })
end

function extensions.edge()
  -- 文字列が空白のみかどうかを判定
  local function is_blank(s) return string.match(s, '^%s*$') ~= nil end

  -- 特定の行と列から文字を取得（マルチバイト対応）
  local function get_char_at(lnum, col)
    local line = vim.fn.getline(lnum)
    if col > vim.fn.strdisplaywidth(line) then return ' ' end
    return vim.fn.strcharpart(vim.fn.strpart(line, col - 1), 0, 1)
  end

  -- 指定された行と列の位置がブロックの一部かどうかを判定
  local function is_part_of_block(lnum, col)
    local char = get_char_at(lnum, col)
    if is_blank(char) then
      local prev_char = col > 1 and get_char_at(lnum, col - 1) or ' '
      local next_char = get_char_at(lnum, col + 1)
      return not (is_blank(prev_char) or is_blank(next_char))
    end
    return true
  end

  -- カーソルをブロックの端に移動する
  local function move_to_block_edge(up)
    local current_line = vim.fn.line('.')
    local current_col = vim.fn.virtcol('.')
    local total_lines = vim.fn.line('$')
    local step = up and 1 or -1
    local target_line = current_line

    -- 現在の位置がブロックの一部かどうかを確認
    local on_block = is_part_of_block(current_line, current_col)
    local on_edge = is_part_of_block(current_line, current_col)
      and not is_part_of_block(current_line + step, current_col)

    for lnum = current_line + step, up and total_lines or 1, step do
      if on_edge then
        -- ブロックの端にいる場合、次のブロックの端まで移動
        if is_part_of_block(lnum, current_col) then
          target_line = lnum
          break
        end
      else
        if on_block then
          -- ブロック内部にいる場合、ブロックの端まで移動
          if not is_part_of_block(lnum, current_col) then
            target_line = lnum - step
            break
          end
        else
          -- ブロック外部にいる場合、次のブロックの始まりまで移動
          if is_part_of_block(lnum, current_col) then
            target_line = lnum
            break
          end
        end
      end
    end

    vim.cmd.normal({ target_line .. 'G', bang = true })
  end

  vim.keymap.set({ 'n', 'x' }, '<c-k>', function() move_to_block_edge(false) end, { desc = 'Previous edge' })
  vim.keymap.set({ 'n', 'x' }, '<c-j>', function() move_to_block_edge(true) end, { desc = 'Next edge' })
end

function extensions.bufjump()
  ---@param forward boolean
  local function jump(forward)
    local jumplist, current_idx = unpack(vim.fn.getjumplist())
    if vim.tbl_isempty(jumplist) then return end

    current_idx = current_idx + 1
    if current_idx == (forward and #jumplist or 1) then return end

    local step = forward and 1 or -1
    local target_idx = current_idx + step

    while target_idx >= 1 and target_idx <= #jumplist do
      local target_buf = jumplist[target_idx].bufnr
      if vim.api.nvim_buf_is_valid(target_buf) and target_buf ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_feedkeys(
          vim.keycode(string.format('%d%s', target_idx - current_idx, forward and '<c-i>' or '<c-o>')),
          'n',
          false
        )
        return
      end
      target_idx = target_idx + step
    end
  end

  vim.keymap.set('n', '<m-i>', function() jump(true) end, { desc = 'Go to newer buffer in jump list' })
  vim.keymap.set('n', '<m-o>', function() jump(false) end, { desc = 'Go to older buffer in jump list' })
end

function extensions.walkthrough()
  local function motion(next)
    local fullname = vim.api.nvim_buf_get_name(0)
    local dirname = vim.fs.dirname(fullname)
    local basename = vim.fs.basename(fullname)

    local files = vim.iter.map(function(name) return name end, vim.fs.dir(dirname))
    if #files <= 1 then return end

    ---@type integer?
    local current_idx
    for i, file in ipairs(files) do
      if file == basename then
        current_idx = i
        break
      end
    end

    if current_idx then
      local target_idx = next and (current_idx % #files + 1) or ((current_idx - 2) % #files + 1)
      vim.cmd.edit(vim.fs.joinpath(dirname, files[target_idx]))
    end
  end

  vim.keymap.set('n', ']w', function() motion(true) end, { desc = 'Go to next file or directory' })
  vim.keymap.set('n', '[w', function() motion(false) end, { desc = 'Go to previous file or directory' })
end

function extensions.peek()
  local saved_view ---@type vim.fn.winsaveview.ret?
  vim.api.nvim_create_autocmd({ 'CmdlineChanged', 'CmdlineLeave' }, {
    callback = function(a)
      if a.match == ':' then
        if a.event == 'CmdlineChanged' then
          local win = vim.fn.bufwinid(a.buf)
          local cmdline = vim.fn.getcmdline()
          local match = cmdline:match('^%d+$')
          if match then
            saved_view = saved_view or vim.fn.winsaveview()
            local row = tonumber(match)
            local max = vim.api.nvim_buf_line_count(a.buf)
            row = math.max(1, math.min(row, max))
            vim.api.nvim_win_set_cursor(win, { row, 0 })
            vim.cmd.normal({ args = { 'zz', 'zv' }, bang = true })
            vim.cmd.redraw()
          end
        elseif a.event == 'CmdlineLeave' then
          if saved_view then
            vim.fn.winrestview(saved_view)
            saved_view = nil
          end
        end
      end
    end,
  })
end

function extensions.fx()
  local ns = vim.api.nvim_create_namespace('fx')
  local bufs = {}
  local path_type = {}

  local function list(path)
    local files = vim.iter.map(function(name, type)
      local fullname = vim.fs.joinpath(path, name)
      path_type[fullname] = type
      return { name = fullname, type = type }
    end, vim.fs.dir(path))

    table.sort(files, function(a, b)
      if a.type == b.type then
        return a.name < b.name
      else
        return a.type == 'directory'
      end
    end)

    return vim.iter.map(function(file) return file.name end, files)
  end

  local function set_extmark(buf, row, opts) vim.api.nvim_buf_set_extmark(buf, ns, row, 0, opts) end

  local function set_conceal(buf, line, row, path)
    local joined_path = vim.fs.joinpath(path, '/')
    local _, end_col = line:find(joined_path, 1, true)
    if end_col then set_extmark(buf, row, { end_row = row, end_col = end_col, conceal = '' }) end
  end

  local function set_highlight(buf, line, row, type)
    local hl_group = 'Normal'

    local type_to_hl_group = {
      block = 'Constant',
      char = 'PreProc',
      directory = 'Directory',
      fifo = 'Type',
      link = 'Identifier',
      socket = 'String',
    }

    hl_group = type_to_hl_group[type] or hl_group

    local link, virt_text_hl
    if type == 'link' then
      link = vim.uv.fs_readlink(line)
      virt_text_hl = link and 'Directory' or 'ErrorMsg'
    end

    local opts = { end_row = row, end_col = #line, hl_group = hl_group }
    if link and virt_text_hl then
      opts.virt_text = { { '-> ' .. link, virt_text_hl } }
      opts.virt_text_pos = 'eol'
    end

    set_extmark(buf, row, opts)
  end

  local function setup(buf, path)
    local files = list(path)
    files = #files == 0 and { '..' } or files
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, files)

    vim.bo[buf].bufhidden = 'hide'
    vim.bo[buf].buflisted = false
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].swapfile = false
    vim.bo[buf].modified = false
    vim.bo[buf].filetype = 'fx'

    local win = vim.fn.bufwinid(buf)
    vim.wo[win][0].concealcursor = 'nc'
    vim.wo[win][0].conceallevel = 2
    vim.wo[win][0].cursorline = true
    vim.wo[win][0].wrap = false
    vim.opt_local.isfname:append('32')

    vim.keymap.set('n', '<cr>', 'gf', { buffer = buf })
    vim.keymap.set('n', '<c-l>', '<cmd>edit .<cr>', { buffer = buf })
    vim.keymap.set('n', '-', function() vim.cmd.edit('%:h') end, { buffer = buf })
  end

  local function attach(buf, path)
    if not bufs[buf] then
      bufs[buf] = vim.api.nvim_buf_attach(buf, false, {
        on_lines = function(_, _, _, first, last_old, last_new, byte_count)
          if first == last_old and last_old == last_new and byte_count == 0 then return end

          local last = math.max(last_old, last_new)
          for i = first, last - 1 do
            local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]
            local type = path_type[line]
            if line and type then
              set_highlight(buf, line, i, type)
              set_conceal(buf, line, i, path)
            end
          end
        end,
        on_detach = function()
          vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
          bufs[buf] = false
        end,
      })
    end
  end

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = vim.api.nvim_create_augroup('fx', {}),
    callback = function(a)
      local path = a.file
      local buf = a.buf
      if vim.api.nvim_buf_is_valid(buf) and vim.fn.isdirectory(path) == 1 then
        attach(buf, path)
        setup(buf, path)
      end
    end,
  })
end

function extensions.unified()
  local function wait()
    local interrupted = false
    while not interrupted do
      local ok, msg = pcall(vim.fn.getchar)
      if not ok and msg == 'Keyboard interrupt' then interrupted = true end
    end
  end

  ---@param chan integer
  ---@param code string
  ---@param ... unknown
  local function request(chan, code, ...)
    local result = vim.rpcrequest(chan, 'nvim_exec_lua', code, { ... })
    if result == vim.NIL then vim.cmd.quitall({ bang = true }) end
    vim.fn.chanclose(chan)
    wait()
  end

  ---@param address string
  local function close(address)
    local ok, chan = pcall(vim.fn.sockconnect, unpack({ 'pipe', address, { rpc = true } }))
    if not ok then return end
    vim.rpcnotify(chan, 'nvim_exec_lua', 'vim.cmd.qall({ bang = true })', {})
    vim.fn.chanclose(chan)
  end

  ---@param args string[]
  ---@param address string
  _G.handle_default = function(args, address)
    if #args == 0 then
      vim.cmd.tabnew({ mods = { keepjumps = true, noautocmd = true } })
    else
      vim.cmd.drop({ args = args, mods = { tab = 1, keepjumps = true } })

      if vim.bo.filetype == 'gitcommit' then
        vim.api.nvim_create_autocmd({ 'QuitPre' }, {
          buffer = vim.api.nvim_get_current_buf(),
          once = true,
          callback = function() close(address) end,
        })
        return true
      end
    end
  end

  ---@param args string[]
  _G.handle_diff = function(args)
    for i, file in ipairs(args) do
      if i == 1 then
        vim.cmd.tabnew({ file, mods = { keepjumps = true, noautocmd = true } })
      elseif i == 2 then
        vim.cmd.vsplit({ file, mods = { split = 'botright', keepjumps = true, noautocmd = true } })
      elseif i == 3 then
        vim.cmd.split({ file, mods = { split = 'botright', keepjumps = true, noautocmd = true } })
      end
      vim.cmd.diffthis()
    end
  end

  ---@param lines string[]
  _G.handle_stdin = function(lines)
    vim.cmd.tabnew({ mods = { keepjumps = true, noautocmd = true }, range = { 1 } })
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.modified = false
    vim.bo.bufhidden = 'wipe'
    vim.bo.buflisted = false
    vim.bo.buftype = 'nofile'
    vim.cmd.filetype('detect')
  end

  if vim.env.NVIM then
    local args = vim.fn.argv(-1)
    local argc = vim.fn.argc(-1)
    local ok, chan = pcall(vim.fn.sockconnect, unpack({ 'pipe', vim.env.NVIM, { rpc = true } }))
    if ok then
      vim.api.nvim_create_autocmd('StdinReadPost', {
        callback = function(a)
          if argc == 0 then
            request(chan, 'return _G.handle_stdin(...)', vim.api.nvim_buf_get_lines(a.buf, 0, -1, false))
          end
        end,
      })

      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          if vim.wo.diff and argc <= 3 and vim.iter(args):any(function(arg) return arg == '-d' end) then
            request(chan, 'return _G.handle_diff(...)', args)
          else
            -- TODO: can remove servername?
            request(chan, 'return _G.handle_default(...)', args, vim.v.servername)
          end
        end,
      })
    end
  end
end

function extensions.quickfix()
  local group = vim.api.nvim_create_augroup('qf', {})
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'qf',
    callback = function()
      local last_line
      local prevview
      local prevwin = vim.fn.win_getid(vim.fn.winnr('#'))
      local prevbuf = vim.api.nvim_win_get_buf(prevwin)
      vim.api.nvim_win_call(prevwin, function() prevview = vim.fn.winsaveview() end)

      vim.api.nvim_create_autocmd('CursorMoved', {
        group = group,
        buffer = 0,
        callback = function()
          local current_line = vim.fn.line('.')
          if current_line == last_line then return end
          last_line = current_line
          local item = vim.fn.getqflist()[current_line]
          if not item then return end
          vim.api.nvim_win_set_buf(prevwin, item.bufnr)
          vim.api.nvim_win_set_cursor(prevwin, { item.lnum, item.col })
          vim.api.nvim_win_call(prevwin, function()
            -- https://github.com/neovim/neovim/issues/10070
            vim.cmd.filetype('detect')
            vim.cmd.normal({ args = { 'zz', 'zv' }, bang = true })
          end)
        end,
      })

      vim.api.nvim_create_autocmd('WinClosed', {
        group = group,
        buffer = 0,
        callback = function()
          vim.api.nvim_win_set_buf(prevwin, prevbuf)
          vim.api.nvim_win_call(prevwin, function() vim.fn.winrestview(prevview) end)
        end,
      })
    end,
  })
end

local function init()
  vim.loader.enable()
  vim.g.mapleader = ' '

  lazy()

  local ok
  local msg
  vim.iter(essentials):each(function(_, essential)
    ok, msg = pcall(essential)
    if not ok then vim.notify(msg) end
  end)
  vim.iter(extensions):each(function(_, extension)
    ok, msg = pcall(extension)
    if not ok then vim.notify(msg) end
  end)
end

init()
