local ok = prequire('dressing')
if not ok then
  return
end

require('dressing').setup {
  input = {
    border = 'single',
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
