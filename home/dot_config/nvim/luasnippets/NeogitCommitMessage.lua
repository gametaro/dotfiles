---@diagnostic disable: undefined-global

local types = { 'fix', 'feat', 'build', 'chore', 'ci', 'docs', 'style', 'refactor', 'perf', 'test' }

return vim.tbl_map(function(type)
  return s(
    type,
    fmt(
      string.format(
        [[
        %s({}): {}

        {}
        ]],
        type
      ),
      ins_generate()
    )
  )
end, types)
