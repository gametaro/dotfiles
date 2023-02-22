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

local snippets = vim.tbl_map(function(type)
  return s({
    trig = type[1],
    dscr = 'Conventional Commits',
    snippetType = 'autosnippet',
  }, {
    t(type[2]),
    c(1, {
      sn(nil, {
        t('('),
        r(1, 'type'),
        t('): '),
        r(2, 'subject'),
      }),
      sn(nil, {
        t('('),
        r(1, 'type'),
        t(')!: '),
        r(2, 'subject'),
      }),
      sn(nil, {
        t(': '),
        r(1, 'subject', i(1)),
      }),
    }),
    t({ '', '', '' }),
    i(0),
  }, { condition = conds.line_begin })
end, types)

return snippets
