local ok = prequire('dressing')
if not ok then
  return
end

require('dressing').setup {
  input = {
    border = require('ky.ui').border,
  },
  select = {
    telescope = require('telescope.themes').get_cursor {
      borderchars = {
        prompt = { '─', '│', ' ', '│', '┌', '┐', '│', '│' },
        results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
      },
    },
  },
}
