local lir = require('lir')
local config = require('lir.config')
local actions = require('lir.actions')
local mark_actions = require('lir.mark.actions')
local clipboard_actions = require('lir.clipboard.actions')
local history = require('lir.history')
local Path = require('plenary.path')

local cache_file_path = Path:new(vim.fn.stdpath('cache'), 'lir', 'history')

local function save()
  local dir = cache_file_path:parent()
  if not dir:exists() then
    dir:mkdir { parents = true }
  end
  cache_file_path:write(vim.mpack.encode(history.get_all()), 'w')
end

local function restore()
  if cache_file_path:exists() then
    local ok, histories = pcall(vim.mpack.decode, cache_file_path:read())
    if ok then
      history.replace_all(histories)
    end
  end
end

local function create()
  local dir = lir.get_context().dir
  vim.ui.input({ prompt = 'New File: ', default = dir, completion = 'file' }, function(input)
    if not input or input == dir then
      return
    end

    local file = Path:new(input)
    if file:exists() then
      vim.notify('file exists', vim.log.levels.INFO, { title = 'Lir' })
      return
    end
    if vim.endswith(file.filename, Path.path.sep) then
      Path:new(file.filename:sub(1, -2)):mkdir { parents = true }
    else
      file:touch {
        parents = true,
      }
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

local function hidden_status()
  if vim.w.lir_is_float then
    local bufnr = vim.w.lir_curdir_win.bufnr
    local ns = vim.api.nvim_create_namespace('lir_hidden')
    if config.values.show_hidden_files then
      vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 1, {
        end_col = 2,
        -- Icons and marks can be freely changed.
        virt_text = { { '', 'WarningMsg' } },
      })
    else
      vim.api.nvim_buf_set_extmark(bufnr, ns, 0, 1, {
        end_col = 2,
        -- Icons and marks can be freely changed.
        virt_text = { { '', 'Comment' } },
      })
    end
  end
end

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('lir-hidden-status', { clear = true }),
  pattern = 'LirSetTextFloatCurdirWindow',
  callback = hidden_status,
})

vim.api.nvim_create_autocmd('ExitPre', {
  group = vim.api.nvim_create_augroup('lir-persistent-history', { clear = true }),
  callback = save,
})

vim.keymap.set('n', '<LocalLeader><LocalLeader>', require('lir.float').init)
vim.keymap.set('n', '<LocalLeader>.', function()
  require('lir.float').init(vim.loop.cwd())
end)

restore()

require('lir').setup {
  hide_cursor = false,
  show_hidden_files = true,
  devicons_enable = true,
  mappings = {
    ['l'] = actions.edit,
    ['o'] = actions.edit,
    ['<CR>'] = actions.edit,
    ['<C-s>'] = actions.split,
    ['<C-v>'] = actions.vsplit,
    ['<C-t>'] = actions.tabedit,

    ['-'] = actions.up,
    ['h'] = actions.up,
    ['q'] = actions.quit,

    ['m'] = actions.mkdir,
    -- ['a'] = actions.newfile,
    ['a'] = create,
    ['r'] = actions.rename,
    ['@'] = actions.cd,
    ['y'] = actions.yank_path,
    ['.'] = actions.toggle_show_hidden,
    ['d'] = actions.delete,

    ['<Tab>'] = function()
      mark_actions.toggle_mark()
      vim.cmd('normal! j')
    end,
    ['c'] = clipboard_actions.copy,
    ['x'] = clipboard_actions.cut,
    ['p'] = clipboard_actions.paste,
  },
  float = {
    winblend = vim.o.winblend,
    curdir_window = {
      enable = true,
      highlight_dirname = true,
    },
    win_opts = function()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      return {
        border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
        width = width,
        height = height,
        col = math.floor((vim.o.columns - width) / 2),
      }
    end,
  },
  on_init = function()
    vim.keymap.set(
      'x',
      'J',
      ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>',
      { buffer = true }
    )
  end,
}
