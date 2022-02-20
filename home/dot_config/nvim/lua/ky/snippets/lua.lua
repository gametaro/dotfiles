local sn = require('ky.snippets.helpers').sn
local s = require('ky.snippets.helpers').s
local t = require('ky.snippets.helpers').t
local c = require('ky.snippets.helpers').c
local i = require('ky.snippets.helpers').i
local r = require('ky.snippets.helpers').r
local fmt = require('ky.snippets.helpers').fmt
local ins_generate = require('ky.snippets.helpers').ins_generate

return {
  s(
    'l',
    c(1, {
      sn(nil, fmt('local {}', r(1, 'name'))),
      sn(nil, fmt('local {} = {}', { r(1, 'name'), i(2) })),
    })
  ),
  s(
    'rq',
    c(1, {
      sn(nil, fmt("require('{}')", r(1, 'name'))),
      sn(nil, fmt("local {} = require('{}')", { i(2), r(1, 'name') })),
    })
  ),
  s('if', {
    t { 'if ' },
    i(1),
    t { ' then', '\t' },
    i(0),
    t { '', 'end' },
  }),
  s('p', fmt('print({})', ins_generate())),
  s('for', {
    t('for '),
    c(1, {
      sn(nil, {
        i(1, 'k'),
        t(', '),
        i(2, 'v'),
        t(' in '),
        c(3, { t('pairs'), t('ipairs') }),
        t('('),
        i(4),
        t(')'),
      }),
      sn(nil, { i(1, 'i'), t(' = '), i(2), t(', '), i(3) }),
    }),
    t { ' do', '\t' },
    i(0),
    t { '', 'end' },
  }),
  s(
    'f',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          local function {}({})
            {}
          end
          ]],
          { r(1, 'name'), r(2, 'args'), r(3, 'code') }
        )
      ),
      sn(
        nil,
        fmt(
          [[
          local {} = function ({})
            {}
          end
          ]],
          { r(1, 'name'), r(2, 'args'), r(3, 'code') }
        )
      ),
    })
  ),
}
