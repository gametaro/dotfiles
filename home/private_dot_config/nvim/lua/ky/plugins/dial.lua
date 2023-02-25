return {
  'monaqa/dial.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  config = function()
    local augend = require('dial.augend')

    local default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias['%Y/%m/%d'],
      augend.date.alias['%Y-%m-%d'],
      augend.date.alias['%m/%d'],
      augend.date.alias['%H:%M'],
      augend.constant.alias.bool,
      augend.constant.new({
        elements = { 'TODO', 'WARN', 'NOTE', 'HACK' },
      }),
      -- augend.paren.new({
      --   patterns = { { "'", "'" }, { '"', '"' }, { '`', '`' } },
      --   escape_char = [[\]],
      -- }),
    }

    local with_default = function(group_name)
      group_name = group_name or {}
      for _, v in ipairs(default) do
        table.insert(group_name, v)
      end
      return group_name
    end

    local group_names = {}
    group_names.lua = {
      augend.paren.alias.lua_str_literal,
      augend.constant.new({
        elements = { 'and', 'or' },
      }),
      augend.constant.new({
        elements = { 'pairs', 'ipairs' },
      }),
    }

    group_names.python = {
      augend.constant.new({
        elements = { 'True', 'False' },
      }),
    }

    group_names.markdown = {
      augend.misc.alias.markdown_header,
    }

    group_names.typescript = {
      augend.constant.new({
        elements = { 'let', 'const' },
      }),
      augend.constant.new({
        elements = { '&&', '||', '??' },
      }),
      augend.constant.new({
        elements = { 'console.log', 'console.warn', 'console.error' },
      }),
    }

    group_names.gitcommit = {
      augend.constant.new({
        elements = { 'fix', 'feat', 'chore', 'refactor', 'ci' },
      }),
    }

    group_names.gitrebase = {
      augend.constant.new({
        elements = { 'pick', 'squash', 'edit', 'reword', 'fixup', 'drop' },
      }),
    }

    require('dial.config').augends:register_group({
      default = default,
      lua = with_default(group_names.lua),
      python = with_default(group_names.python),
      typescript = with_default(group_names.typescript),
      markdown = with_default(group_names.markdown),
      gitcommit = with_default(group_names.gitcommit),
      gitrebase = with_default(group_names.gitrebase),
    })

    vim.keymap.set({ 'n', 'x' }, '<C-a>', '<Plug>(dial-increment)')
    vim.keymap.set({ 'n', 'x' }, '<C-x>', '<Plug>(dial-decrement)')
    vim.keymap.set('x', 'g<C-a>', 'g<Plug>(dial-increment)')
    vim.keymap.set('x', 'g<C-x>', 'g<Plug>(dial-decrement)')

    local group = vim.api.nvim_create_augroup('DialMapping', { clear = true })
    for group_name, _ in pairs(group_names) do
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = group_name,
        callback = function(a)
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = a.buf
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          map('n', '<C-a>', require('dial.map').inc_normal(group_name))
          map('x', '<C-a>', require('dial.map').inc_visual(group_name))
          map('n', '<C-x>', require('dial.map').dec_normal(group_name))
          map('x', '<C-x>', require('dial.map').dec_visual(group_name))
          map('x', 'g<C-a>', require('dial.map').inc_gvisual(group_name))
          map('x', 'g<C-x>', require('dial.map').dec_gvisual(group_name))
        end,
      })
    end
  end,
}
