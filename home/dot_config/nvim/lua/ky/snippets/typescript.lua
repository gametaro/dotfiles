local sn = require('ky.snippets.helpers').sn
local s = require('ky.snippets.helpers').s
local t = require('ky.snippets.helpers').t
local c = require('ky.snippets.helpers').c
local i = require('ky.snippets.helpers').i
local r = require('ky.snippets.helpers').r
local fmt = require('ky.snippets.helpers').fmt
local fmta = require('ky.snippets.helpers').fmta
local ins_generate = require('ky.snippets.helpers').ins_generate

return {
  s(
    'l',
    c(1, {
      sn(nil, fmt('let {}', { r(1, 'name') })),
      sn(nil, fmt('let {} = {}', { r(1, 'name'), i(2) })),
    })
  ),
  s('c', fmt('const {} = {}', ins_generate())),
  s(
    'cd',
    c(1, {
      sn(nil, fmta('const { <> } = <>;', { r(2, 'value'), r(1, 'name') })),
      sn(nil, fmt('const [ {} ] = {};', { r(2, 'value'), r(1, 'name') })),
    })
  ),
  s('te', fmt('{} ? {} : {}', ins_generate())),
  s('j', {
    t('JSON.'),
    c(1, { t('parse'), t('stringify') }),
    t('('),
    i(2),
    t(')'),
  }),
  s('cl', {
    t('console.'),
    c(1, { t('log'), t('warn'), t('error') }),
    t('('),
    i(2),
    t(')'),
  }),
  s(
    'await',
    c(1, {
      sn(nil, fmt('await {}', r(1, 'value'))),
      sn(nil, fmt('const {} = await {}', { r(1, 'name'), r(2, 'value') })),
      sn(nil, fmta('const { <> } = await <>', { r(1, 'name'), r(2, 'value') })),
    })
  ),
  s(
    'promiseall',
    c(1, {
      sn(nil, fmt('await Promise.all({})', ins_generate())),
      sn(nil, fmt('const {} = await Promise.all({})', ins_generate())),
      sn(
        nil,
        fmt(
          [[
          await Promise.all({}.map(async ({}) => {{
            {}
          }}
          ]],
          ins_generate()
        )
      ),
    })
  ),
  s('if', {
    t { 'if (' },
    i(1),
    t { ') {', '\t' },
    i(0),
    t { '', '}' },
  }),
  s('ifelse', {
    t { 'if (' },
    i(1),
    t { ') else {', '\t' },
    i(0),
    t { '', '}' },
  }),
  s('trycatch', {
    t { 'try {', '\t' },
    i(1),
    t { '\t', '} catch (' },
    i(2),
    t { ') {', '\t' },
    i(3),
    t { '', '}' },
  }),
  s(
    'process',
    c(1, {
      sn(nil, fmt('process.env.{};', r(1, 'name'))),
      sn(nil, fmta('const { <> } = process.env;', r(1, 'name'))),
    })
  ),
  s(
    'import',
    c(1, {
      sn(nil, fmta("import { <> } from '<>'", { r(2, 'name'), r(1, 'from') })),
      sn(nil, fmt("import {} from '{}'", { r(2, 'name'), r(1, 'from') })),
      sn(nil, fmt("import {} as {} from '{}'", { r(2, 'name'), i(3), r(1, 'from') })),
    })
  ),
  s('ex', {
    t('export '),
    i(1),
    t(' '),
    i(2),
  }),
  s('fa', {
    c(1, {
      sn(nil, fmt('({}) => {}', { r(1, 'args'), r(2, 'code') })),
      sn(
        nil,
        fmt(
          [[
          ({}) => {{
            {}
          }}
          ]],
          { r(1, 'args'), r(2, 'code') }
        )
      ),
      sn(
        nil,
        fmt(
          [[
          const {} = ({}) => {{
            {}
          }}
          ]],
          { i(1), r(2, 'args'), r(3, 'code') }
        )
      ),
    }),
  }),
  s('af', {
    c(1, {
      sn(
        nil,
        fmt(
          [[
          const {} = async ({}) => {{
            {}
          }}
          ]],
          { r(1, 'name'), r(2, 'args'), r(3, 'code') }
        )
      ),
      sn(
        nil,
        fmt(
          [[
          async function {} ({}) {{
            {}
          }}
          ]],
          { r(1, 'name'), r(2, 'args'), r(3, 'code') }
        )
      ),
      sn(
        nil,
        fmt(
          [[
          ;(async ({}) => {{
            {}
          }})({})
          ]],
          { r(1, 'args'), r(2, 'code'), i(3) }
        )
      ),
    }),
  }),
  s(
    'for',
    c(1, {
      sn(
        nil,
        fmt(
          [[
          for (const {} of {}) {{
            {}
          }}]],
          { r(1, 'variable'), r(2, 'iterable'), r(3, 'statement') }
        )
      ),
      sn(
        nil,
        fmt(
          [[
          for (const {} in {}) {{
            {}
          }}]],
          { r(1, 'variable'), r(2, 'iterable'), r(3, 'statement') }
        )
      ),
    })
  ),
  s(
    'class',
    fmta(
      [[
      class <> {
        constructor(<>) {
          <>
        }
      }]],
      ins_generate()
    )
  ),
  s('member', {
    c(1, { t('public '), t('private ') }),
    i(2),
    c(3, { t(': '), t(' = ') }),
    i(4),
  }),
  s(
    'method',
    fmta(
      [[
      <><>(<>) {
        <>
      }
      ]],
      {
        c(1, { t(''), t('public '), t('private ') }),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  s('t', {
    t('this.'),
  }),
  s('o', {
    t('Object.'),
    c(1, { t('keys('), t('values('), t('entries('), t('assign(') }),
    i(2),
    t(')'),
  }),
  s(':', {
    t(': '),
  }),
  s('=', {
    t(' = '),
  }),
  s('/', {
    t('// '),
  }),
  s('s', {
    t('string'),
  }),
  s('n', {
    t('number'),
  }),
}
