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
    'c',
    c(1, {
      sn(nil, fmt('const {} = {};', ins_generate())),
      sn(nil, fmta('const { <> } = <>;', { r(2, 'value'), r(1, 'name') })),
      sn(nil, fmt('const [ {} ] = {};', { r(2, 'value'), r(1, 'name') })),
    })
  ),
  s(
    'ternary',
    c(1, {
      sn(nil, fmt('{} ? {} : {}', { r(1, 'cond'), r(2, 'true'), r(3, 'false') })),
      sn(nil, fmt('const {} = {} ? {} : {};', { i(1), r(2, 'cond'), r(3, 'true'), r(4, 'false') })),
    })
  ),
  s(
    'json',
    c(1, {
      sn(nil, fmt('JSON.parse({})', r(1, 'value'))),
      sn(nil, fmt('JSON.stringify({})', r(1, 'value'))),
    })
  ),
  s(
    'log',
    c(1, {
      sn(nil, fmt('console.log({})', r(1, 'value'))),
      sn(nil, fmt('console.warn({})', r(1, 'value'))),
      sn(nil, fmt('console.error({})', r(1, 'value'))),
    })
  ),
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
  s(
    'export',
    c(1, {
      sn(nil, fmt('export const {} = {}', ins_generate())),
    })
  ),
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
}
