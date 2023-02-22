return {
  'tamago324/lir.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'tamago324/lir-git-status.nvim' },
  event = 'VeryLazy',
  config = function()
    local lir = require('lir')
    local config = require('lir.config')
    local actions = require('lir.actions')
    local mark_actions = require('lir.mark.actions')
    local clipboard_actions = require('lir.clipboard.actions')
    local history = require('lir.history')
    local Path = require('plenary.path')

    local cache_file = Path:new(vim.fn.stdpath('cache'), 'lir', 'history')

    local function save()
      local dir = cache_file:parent()
      if not dir:exists() then
        dir:mkdir({ parents = true })
      end
      cache_file:write(vim.mpack.encode(history.get_all()), 'w')
    end

    local function restore()
      if cache_file:exists() then
        local ok, histories = pcall(vim.mpack.decode, cache_file:read())
        if ok then
          history.replace_all(histories)
        end
      end
    end

    local function create()
      local cwd = vim.loop.cwd()
      -- temporarily change cwd for filename completion
      vim.cmd.cd({ lir.get_context().dir, mods = { noautocmd = true } })

      vim.ui.input({ prompt = 'New File: ', completion = 'file' }, function(input)
        -- restore original cwd
        vim.cmd.cd({ cwd, mods = { noautocmd = true, silent = true } })
        if not input or input == '' or input == '.' or input == '..' then
          return
        end

        local dir = lir.get_context().dir
        local file = Path:new(dir .. input)
        if file:exists() then
          vim.notify('file exists', vim.log.levels.INFO, { title = 'Lir' })
          return
        end
        if vim.endswith(file.filename, Path.path.sep) then
          Path:new(file.filename:sub(1, -2)):mkdir({ parents = true })
        else
          file:touch({
            parents = true,
          })
        end

        local filename = file.filename:gsub(dir, '')

        -- If the first character is '.' and show_hidden_files is false, set it to true
        if vim.startswith(filename, '.') and not config.values.show_hidden_files then
          config.values.show_hidden_files = true
        end

        actions.reload()

        -- Jump to a line in the parent directory of the file you created.
        local row = lir.get_context():indexof(filename:match('^[^/]+'))
        if row then
          vim.api.nvim_win_set_cursor(0, { row, 1 })
        end
      end)
    end

    local delete = function()
      local ctx = lir.get_context()
      local name = ctx:current_value()
      local path = Path:new(ctx.dir .. name)

      vim.ui.select(
        { 'Yes', 'No' },
        { prompt = string.format('Delete %s ?', name) },
        function(choice)
          if choice and choice == 'Yes' then
            path:rm({ recursive = path:is_dir() })
            local bufs = vim.tbl_filter(function(buf)
              return vim.api.nvim_buf_is_loaded(buf)
                and vim.api.nvim_buf_get_name(buf) == path.filename
            end, vim.api.nvim_list_bufs())
            for _, buf in ipairs(bufs) do
              vim.api.nvim_buf_delete(buf, { force = true })
            end

            actions.reload()
          end
        end
      )
    end

    vim.api.nvim_create_autocmd('ExitPre', {
      group = vim.api.nvim_create_augroup('lir-persistent-history', { clear = true }),
      callback = save,
    })

    restore()

    require('lir').setup({
      -- ignore = { 'node_modules' },
      show_hidden_files = false,
      devicons = {
        enable = vim.g.nerd,
        highlight_dirname = true,
      },
      mappings = {
        ['l'] = actions.edit,
        ['o'] = actions.edit,
        ['<CR>'] = actions.edit,
        ['s'] = actions.split,
        ['v'] = actions.vsplit,
        ['t'] = actions.tabedit,

        ['-'] = actions.up,
        ['h'] = actions.up,
        ['q'] = actions.quit,
        ['<Esc>'] = actions.quit,

        -- ['m'] = actions.mkdir,
        -- ['a'] = actions.newfile,
        ['a'] = create,
        ['r'] = actions.rename,
        ['@'] = function()
          local dir = lir.get_context().dir
          local cmd = vim.fn.haslocaldir() == 1 and 'lcd' or 'cd'
          vim.cmd[cmd]({ dir, mods = { silent = true } })
          vim.notify(cmd .. ': ' .. dir, vim.log.levels.INFO, { title = 'lir' })
        end,
        ['y'] = function()
          local file = lir.get_context():current_value()
          vim.fn.setreg(vim.v.register, file)
          vim.notify('yank: ' .. file, vim.log.levels.INFO, { title = 'lir' })
        end,
        ['Y'] = function()
          local ctx = lir.get_context()
          local path = ctx.dir .. ctx:current_value()
          vim.fn.setreg(vim.v.register, path)
          vim.notify('yank: ' .. path, vim.log.levels.INFO, { title = 'lir' })
        end,
        ['.'] = actions.toggle_show_hidden,
        ['d'] = delete,

        ['<Tab>'] = function()
          mark_actions.toggle_mark()
          vim.cmd.normal({ 'j', bang = true })
        end,
        ['<S-Tab>'] = function()
          mark_actions.toggle_mark()
          vim.cmd.normal({ 'k', bang = true })
        end,
        ['c'] = clipboard_actions.copy,
        ['x'] = clipboard_actions.cut,
        ['p'] = clipboard_actions.paste,
      },
    })

    require('lir.git_status').setup({
      show_ignored = false,
    })
  end,
}
