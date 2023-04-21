---@diagnostic disable: undefined-global

local todos = { 'TODO', 'WARN', 'NOTE', 'HACK' }

ls.add_snippets(
  'all',
  vim.map(function(todo)
    return s(string.lower(todo), {
      f(function()
        return string.format(vim.bo.commentstring, ' ' .. todo) .. ': '
      end),
    })
  end, todos)
)

return {
  s('td', {
    d(1, function()
      return sn(nil, {
        c(
          1,
          vim.map(function(todo)
            return t(string.format(vim.bo.commentstring, ' ' .. todo) .. ': ')
          end, todos)
        ),
      })
    end),
    i(0),
  }),
  s('r', fmt('return {}', i(1))),
}
