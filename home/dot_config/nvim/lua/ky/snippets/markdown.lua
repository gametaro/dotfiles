local sn = require('ky.snippets.helpers').sn
local s = require('ky.snippets.helpers').s
local t = require('ky.snippets.helpers').t
local c = require('ky.snippets.helpers').c
local i = require('ky.snippets.helpers').i
local d = require('ky.snippets.helpers').d
local fmt = require('ky.snippets.helpers').fmt
local ins_generate = require('ky.snippets.helpers').ins_generate

local header_gen = function(num)
  return s('h' .. tostring(num), fmt(string.rep('#', num) .. ' {}', ins_generate()))
end

local function rec_ls()
  return sn(nil, {
    c(1, {
      -- important!! Having the sn(...) as the first choice will cause infinite recursion.
      t { '' },
      -- The same dynamicNode as in the snippet (also note: self reference).
      sn(nil, {
        t { '', '- ' },
        i(1),
        d(2, rec_ls, {}),
      }),
    }),
  })
end

local function rec_ls_2()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { '', '* ' },
        i(1),
        d(2, rec_ls_2, {}),
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
    d(2, rec_ls, {}),
    t(''),
  }),
  s('ul*', {
    t { '* ' },
    i(1),
    d(2, rec_ls_2, {}),
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
