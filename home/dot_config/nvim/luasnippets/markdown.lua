---@diagnostic disable: undefined-global

local ins_generate = require('ky.snippets.helpers').ins_generate

local header_gen = function(num)
  return s('h' .. tostring(num), fmt(string.rep('#', num) .. ' {}', ins_generate()))
end

local function rec_dash()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { '', '- ' },
        i(1),
        d(2, rec_dash, {}),
      }),
    }),
  })
end

local function rec_star()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { '', '* ' },
        i(1),
        d(2, rec_star, {}),
      }),
    }),
  })
end

local snippets = {
  s('l', fmt('[{}]({})', ins_generate())),
  s('u', fmt('<{}>', ins_generate())),
  s('img', fmt('![{}]({})', ins_generate())),
  s('strikethrough', fmt('~~{}~~', ins_generate())),
  s('b', fmt('**{}**', ins_generate())),
  s('i', fmt('*{}*', ins_generate())),
  s('bi', fmt('***{}***', ins_generate())),
  s('q', fmt('> {}', ins_generate())),
  s('c', fmt('`{}`', ins_generate())),
  s(
    'cb',
    fmt(
      [[
    ```{}
    {}
    ```
    ]],
      ins_generate()
    )
  ),
  s('ul-', {
    t { '- ' },
    i(1),
    d(2, rec_dash, {}),
    t(''),
  }),
  s('ul*', {
    t { '* ' },
    i(1),
    d(2, rec_star, {}),
    t(''),
  }),
  s(
    'ol',
    fmt(
      [[
      1. {}
      2. {}
      3. {}
      ]],
      ins_generate()
    )
  ),
}

for _, v in ipairs { 1, 2, 3, 4, 5, 6 } do
  table.insert(snippets, header_gen(v))
end

return snippets
