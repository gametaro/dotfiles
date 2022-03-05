local sn = require('ky.snippets.helpers').sn
local s = require('ky.snippets.helpers').s
local t = require('ky.snippets.helpers').t
local c = require('ky.snippets.helpers').c
local i = require('ky.snippets.helpers').i
local r = require('ky.snippets.helpers').r
local d = require('ky.snippets.helpers').d
local fmt = require('ky.snippets.helpers').fmt
local fmta = require('ky.snippets.helpers').fmta
local ins_generate = require('ky.snippets.helpers').ins_generate
local rep_generate = require('ky.snippets.helpers').rep_generate

local format = string.format

local opts = {
  single_quote = true,
  semi = true,
  tab_width = nil,
}

local quote = opts.single_quote and "'" or '"'
local semi = opts.semi and ';' or ''
-- local indent = opts.tab_width or vim.opt.shiftwidth

local function rec_elseif()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { ' else if (' },
        i(1),
        t { ') {', '\t' },
        i(2),
        t { '', '}' },
        d(3, rec_elseif, {}),
      }),
    }),
  })
end

local function rec_case()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { 'case ' },
        i(1),
        t { ':', '\t\t' },
        i(2),
        t { '', '\t\t' },
        t { 'break', '\t' },
        d(3, rec_case, {}),
      }),
    }),
  })
end

return {
  s(
    'l',
    c(1, {
      sn(nil, fmt(format('let {}%s', semi), { r(1, 'name') })),
      sn(nil, fmt(format('let {} = {}%s', semi), { r(1, 'name'), i(2) })),
    })
  ),
  s('c', fmt(format('const {} = {}%s', semi), ins_generate())),
  s(
    'cd',
    c(1, {
      sn(nil, fmta('const { <> } = <>;', { r(2, 'name'), r(1, 'value') })),
      sn(nil, fmt('const [ {} ] = {};', { r(2, 'name'), r(1, 'value') })),
    })
  ),
  s('te', fmt(format('{} ? {} : {}%s', semi), ins_generate())),
  s('j', {
    t('JSON.'),
    c(1, { t('parse'), t('stringify') }),
    t('('),
    i(2),
    t(format(')%s', semi)),
  }),
  s('cl', {
    t('console.'),
    c(1, {
      t('log'),
      t('warn'),
      t('error'),
    }),
    t('('),
    i(2),
    t(format(')%s', semi)),
  }),
  s('a', { t('await '), i(1) }),
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
    i(2),
    c(3, {
      t { '', '}' },
      sn(nil, {
        t { '', '} else {', '\t' },
        i(1),
        t { '', '}' },
      }),
      sn(nil, {
        t { '', '} else if (' },
        i(1),
        t { ') {', '\t' },
        i(2),
        t { '', '}' },
        d(3, rec_elseif, {}),
      }),
    }),
  }),
  s('ifelse', {
    t { 'if (' },
    i(1),
    t { ') {', '\t' },
    i(2),
    t { '', '} else {', '\t' },
    i(0),
    t { '', '}' },
  }),
  s('else', {
    t { 'else {', '\t' },
    i(1),
    t { '', '}' },
  }),
  s('elseif', {
    t { 'else if (' },
    i(1),
    t { ') {', '\t' },
    i(2),
    t { '', '}' },
    d(3, rec_elseif, {}),
  }),
  s('try', {
    t { 'try {', '\t' },
    i(1),
    t { '', '} ' },
    c(2, {
      t('catch ('),
      t('finally ('),
    }),
    i(3),
    t { ') {', '\t' },
    i(4),
    c(5, {
      t { '', '}' },
      sn(nil, {
        t { '', '} finally {', '\t' },
        i(1),
        t { '', '}' },
      }),
    }),
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
      sn(nil, fmt('({}) => {}', rep_generate())),
      sn(
        nil,
        fmt(
          [[
          ({}) => {{
            {}
          }}
          ]],
          rep_generate()
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
          rep_generate()
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
          rep_generate()
        )
      ),
      sn(
        nil,
        fmt(
          [[
          async function {}({}) {{
            {}
          }}
          ]],
          rep_generate()
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
          rep_generate()
        )
      ),
    }),
  }),
  s('for', {
    t('for (const '),
    i(1),
    c(2, { t(' in '), t(' of ') }),
    i(3),
    t { ') {', '\t' },
    i(4),
    t { '', '}' },
  }),
  s('foreach', {
    i(1),
    t('.forEach('),
    i(2),
    t { ' => {', '\t' },
    i(3),
    t { '', '})' },
  }),
  s('switch', {
    t('switch ('),
    i(1),
    t { ') {', '\t' },
    t { 'case ' },
    i(2),
    t { ':', '\t\t' },
    i(3),
    t { '', '\t\t' },
    t { format('break%s', semi), '\t' },
    d(4, rec_case, {}),
    t { 'default:', '\t\t' },
    t { format('break%s', semi) },
    t { '', format('}%s', semi) },
  }),
  s('while', {
    c(1, {
      sn(nil, {
        t('while ('),
        r(1, 'condition'),
        t { ') {', '\t' },
        r(2, 'statement'),
        t { '', format('}%s', semi) },
      }),
      sn(nil, {
        t { 'do {', '\t' },
        r(2, 'statement'),
        t { '', '} while (' },
        r(1, 'condition'),
        t { format(')%s', semi) },
      }),
    }),
  }),
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
    t(format(')%s', semi)),
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
  s('desc', {
    t(format('describe(%s', quote)),
    i(1),
    t { format('%s), () => {', quote), '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('it', {
    t(format('it(%s', quote)),
    i(1),
    c(2, {
      t { format('%s, () => {', quote), '\t' },
      t { format('%s, async () => {', quote), '\t' },
    }),
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('before', {
    t { 'before(() => {', '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('beforeAll', {
    t { 'beforeAll(() => {', '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('beforeEach', {
    t { 'beforeEach(() => {', '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('after', {
    t { 'after(() => {', '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('afterAll', {
    t { 'afterAll(() => {', '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('afterEach', {
    t { 'afterEach(() => {', '\t' },
    i(0),
    t { '', format('})%s', semi) },
  }),
  s('expect', {
    t { 'expect(' },
    i(1),
    t { ')' },
    i(0),
    t { semi },
  }),
}
