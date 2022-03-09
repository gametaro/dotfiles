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
        t { ' else {', '\t' },
        i(1),
        t { '', '}' },
      }),
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
        t { 'break' .. semi, '\t' },
        d(3, rec_case, {}),
      }),
    }),
  })
end

local function rec_prop_comma()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { '', '' },
        i(1),
        t(': '),
        i(2),
        t(','),
        d(3, rec_prop_comma, {}),
      }),
    }),
  })
end

local function rec_prop_semi()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { '', '\t' },
        i(1),
        t(': '),
        i(2),
        t(semi),
        d(3, rec_prop_semi, {}),
      }),
    }),
  })
end

-- TODO: should not ignore...
-- jscpd:ignore-start
local function rec_promise()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t('.then(('),
        i(1),
        t { ') => {', '\t' },
        i(2),
        t { '', '})' },
        d(3, rec_promise, {}),
      }),
      sn(nil, {
        t('.catch(('),
        i(1),
        t { ') => {', '\t' },
        i(2),
        t { '', '})' },
      }),
    }),
  })
end
-- jscpd:ignore-end

local is_test_file = function()
  local fname = vim.fn.expand('%:t')
  return vim.endswith(fname, 'spec.ts') or vim.endswith(fname, 'test.ts')
end

return {
  -- jscpd:ignore-start
  s('p', {
    i(1),
    c(2, {
      sn(nil, {
        t('.then(('),
        i(1),
        t { ') => {', '\t' },
        i(2),
        t { '', '})' },
        d(3, rec_promise, {}),
      }),
      sn(nil, {
        t('.catch(('),
        i(1),
        t { ') => {', '\t' },
        i(2),
        t { '', '})' },
      }),
    }),
  }),
  -- jscpd:ignore-end
  s('prop', {
    i(1),
    t(': '),
    i(2),
    t(','),
    d(3, rec_prop_comma, {}),
  }),
  s(
    'l',
    c(1, {
      sn(nil, fmt('let {}' .. semi, { r(1, 'name') })),
      sn(nil, fmt('let {} = {}' .. semi, { r(1, 'name'), i(2) })),
    })
  ),
  s('c', fmt('const {} = {}' .. semi, ins_generate())),
  s(
    'cd',
    c(1, {
      sn(nil, fmta('const { <> } = <>;', { r(2, 'name'), r(1, 'value') })),
      sn(nil, fmt('const [ {} ] = {};', { r(2, 'name'), r(1, 'value') })),
    })
  ),
  s('te', fmt('{} ? {} : {}' .. semi, ins_generate())),
  s('j', {
    t('JSON.'),
    c(1, { t('parse'), t('stringify') }),
    t('('),
    i(2),
    t(')' .. semi),
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
    t(')' .. semi),
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
      sn(nil, {
        t('catch ('),
        i(1),
        t { ') {', '\t' },
        i(2),
        c(3, {
          t { '', '}' },
          sn(nil, {
            t { '', '} finally {', '\t' },
            i(1),
            t { '', '}' },
          }),
        }),
      }),
      sn(nil, {
        t { 'finally {', '\t' },
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
  s('import', {
    t('import '),
    c(2, {
      sn(nil, {
        t('{ '),
        r(1, 'name'),
        t(' } from ' .. quote),
      }),
      sn(nil, {
        c(1, {
          t(''),
          t('* as '),
        }),
        r(2, 'name'),
        t(' from ' .. quote),
      }),
    }),
    i(1),
    t(quote .. semi),
  }),
  s('ex', {
    t('export '),
    i(0),
  }),
  s('fa', {
    t('('),
    i(1),
    t(') => '),
    c(2, {
      sn(nil, {
        r(1, 'code'),
      }),
      sn(nil, {
        t { '{', '\t' },
        r(1, 'code'),
        t { '', '}' },
      }),
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
    i(0),
    t { '', '})' },
  }),
  s('map', {
    i(1),
    t('.map('),
    i(2),
    t { ' => {', '\t' },
    i(0),
    t { '', '})' },
  }),
  s('flatMap', {
    i(1),
    t('.flatMap('),
    i(2),
    t { ' => {', '\t' },
    i(0),
    t { '', '})' },
  }),
  s('reduce', {
    i(1),
    t('.reduce(('),
    i(2),
    t(', '),
    i(3),
    t { ') => {', '\t' },
    i(0),
    t { '', '}, ' },
    i(4),
    t(')'),
  }),
  s('filter', {
    i(1),
    t('.filter('),
    i(2),
    t { ' => {', '\t' },
    i(0),
    t { '', '})' },
  }),
  s('find', {
    i(1),
    t('.find('),
    i(2),
    t { ' => {', '\t' },
    i(0),
    t { '', '})' },
  }),
  s('every', {
    i(1),
    t('.every('),
    i(2),
    t { ' => {', '\t' },
    i(0),
    t { '', '})' },
  }),
  s('some', {
    i(1),
    t('.some('),
    i(2),
    t { ' => {', '\t' },
    i(0),
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
    t { 'break' .. semi, '\t' },
    d(4, rec_case, {}),
    t { 'default:', '\t\t' },
    i(5),
    t { '', '\t\t' },
    t { 'break' .. semi },
    t { '', '}' .. semi },
  }),
  s('while', {
    c(1, {
      sn(nil, {
        t('while ('),
        r(1, 'condition'),
        t { ') {', '\t' },
        r(2, 'statement'),
        t { '', '}' .. semi },
      }),
      sn(nil, {
        t { 'do {', '\t' },
        r(2, 'statement'),
        t { '', '} while (' },
        r(1, 'condition'),
        t { ')' .. semi },
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
    c(1, {
      t('public '),
      t('private '),
    }),
    i(2),
    c(3, { t(': '), t(' = ') }),
    i(4),
  }),
  s('method', {
    c(1, {
      t(''),
      t('public '),
      t('private '),
    }),
    i(2),
    t('('),
    i(3),
    t { ') {', '\t' },
    i(0),
    t { '', '}' },
  }),
  s('t', {
    t('this.'),
  }),
  s('o', {
    t('Object.'),
    c(1, {
      t('keys('),
      t('values('),
      t('entries('),
      t('assign('),
    }),
    i(2),
    t(')' .. semi),
  }),
  s('type', {
    t('type '),
    i(1),
    t { ' = {', '\t' },
    i(2),
    t(': '),
    i(3),
    t(semi),
    d(4, rec_prop_semi, {}),
    t { '', '}' },
  }),
  s('interface', {
    t('interface '),
    i(1),
    t { ' {', '\t' },
    i(2),
    t(': '),
    i(3),
    t(semi),
    d(4, rec_prop_semi, {}),
    t { '', '}' },
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
    t('describe(' .. quote),
    i(1),
    t { quote .. ', () => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('it', {
    t('it(' .. quote),
    i(1),
    c(2, {
      t { quote .. ', () => {', '\t' },
      t { quote .. ', async () => {', '\t' },
    }),
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('before', {
    t { 'before(() => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('beforeAll', {
    t { 'beforeAll(() => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('beforeEach', {
    t { 'beforeEach(() => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('after', {
    t { 'after(() => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('afterAll', {
    t { 'afterAll(() => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('afterEach', {
    t { 'afterEach(() => {', '\t' },
    i(0),
    t { '', '})' .. semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
  s('expect', {
    t { 'expect(' },
    i(1),
    t { ')' },
    i(0),
    t { semi },
  }, {
    condition = is_test_file,
    show_condition = is_test_file,
  }),
}
