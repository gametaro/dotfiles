local ls = require('luasnip')
local types = require('luasnip.util.types')
ls.config.set_config {
  history = true,
  updateevents = 'InsertLeave',
  region_check_events = 'CursorHold',
  delete_check_events = 'TextChanged,InsertEnter',
  enable_autosnippets = true,
  ext_opts = {
    -- [types.insertNode] = {
    --   active = {
    --     virt_text = { { '●' } },
    --   },
    -- },
    [types.choiceNode] = {
      active = {
        virt_text = { { '■' } },
      },
    },
  },
}

function _G.snippets_reload()
  for m, _ in pairs(ls.snippets) do
    package.loaded['ky.snippets.' .. m] = nil
  end
  ls.snippets = setmetatable({}, {
    __index = function(t, k)
      local ok, m = pcall(require, 'ky.snippets.' .. k)
      if not ok and not string.match(m, '^module.*not found:') then
        error(m)
      end
      t[k] = ok and m or {}

      -- optionally load snippets from vscode- or snipmate-library:
      --
      -- require('luasnip.loaders.from_vscode').load { include = { k } }
      return t[k]
    end,
  })
end

_G.snippets_reload()

vim.cmd([[
augroup snippets_reload
au!
au BufWritePost ~/.config/nvim/lua/ky/snippets/*.lua lua _G.snippets_reload()
au BufWritePost ~/.local/share/chezmoi/home/dot_config/nvim/lua/ky/snippets/*.lua lua _G.snippets_reload()
augroup END
]])

vim.api.nvim_add_user_command('LuaSnipEdit', function()
  local fts = require('luasnip.util.util').get_snippet_filetypes()
  vim.ui.select(fts, {
    prompt = 'Select which filetype to edit:',
  }, function(item, idx)
    -- selection aborted -> idx == nil
    if idx then
      vim.cmd('edit ~/.local/share/chezmoi/home/dot_config/nvim/lua/ky/snippets/' .. item .. '.lua')
    end
  end)
end, { nargs = 0 })

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if require('luasnip').expand_or_jumpable() then
    require('luasnip').expand_or_jump()
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if require('luasnip').jumpable(-1) then
    require('luasnip').jump(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<C-l>', function()
  if require('luasnip').choice_active() then
    require('luasnip').change_choice(1)
  end
end)
