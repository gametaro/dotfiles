local s = require('ky.snippets.helpers').s
local fmt = require('ky.snippets.helpers').fmt
local ins_generate = require('ky.snippets.helpers').ins_generate

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
