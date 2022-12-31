---@diagnostic disable: undefined-global

local types = {
  { 'fi', 'fix' },
  { 'fe', 'feat' },
  { 'bu', 'build' },
  { 'ch', 'chore' },
  { 'ci', 'ci' },
  { 'do', 'docs' },
  { 'st', 'style' },
  { 're', 'refactor' },
  { 'pe', 'perf' },
  { 'te', 'test' },
}

return vim.tbl_map(function(type)
  return s(
    type[1],
    fmt(
      string.format(
        [[
        %s({}): {}

        {}
        ]],
        type[2]
      ),
      ins_generate()
    )
  )
end, types)
