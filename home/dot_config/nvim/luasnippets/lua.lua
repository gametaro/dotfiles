---@diagnostic disable: undefined-global

local format = string.format

local function rec_elseif()
  return sn(nil, {
    c(1, {
      t { '' },
      sn(nil, {
        t { '', 'else', '\t' },
        i(1),
      }),
      sn(nil, {
        t { '', 'elseif ' },
        i(1),
        t { ' then', '\t' },
        i(2),
        d(3, rec_elseif, {}),
      }),
    }),
  })
end

local opts = {
  single_quote = true,
  tab_width = nil,
}

local quote = opts.single_quote and "'" or '"'

return {
  s('l', {
    c(1, {
      sn(nil, {
        t('local '),
        i(1),
      }),
      sn(nil, {
        t('local '),
        i(1),
        t(' = '),
        i(2),
      }),
    }),
  }),
  s('ll', {
    t('local '),
    i(1),
    t(' = '),
    i(2),
  }),
  s('lt', {
    t('local '),
    i(1),
    t(' = { '),
    i(2),
    t(' }'),
  }),
  s(
    'lf',
    c(1, {
      sn(nil, {
        t('local function '),
        r(1, 'name'),
        t('('),
        r(2, 'arg'),
        t { ')', '\t' },
        r(3, 'code'),
        t { '', 'end' },
      }),
      sn(nil, {
        t('local '),
        r(1, 'name'),
        t(' = function('),
        r(2, 'arg'),
        t { ')', '\t' },
        r(3, 'code'),
        t { '', 'end' },
      }),
    })
  ),
  s(
    'rq',
    c(1, {
      sn(nil, fmt(format('require(%s{}%s)', quote, quote), rep_generate())),
      sn(nil, {
        t('local '),
        i(2),
        t(' = require(' .. quote),
        i(1),
        t(quote .. ')'),
      }),
    })
  ),
  s('if', {
    t { 'if ' },
    i(1),
    t { ' then', '\t' },
    i(2),
    d(3, rec_elseif, {}),
    t { '', 'end' },
  }),
  s('p', fmt('print({})', i(0))),
  s('pp', fmt('vim.pretty_print({})', i(0))),
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
  s('fa', {
    t('function('),
    i(1),
    t { ')', '\t' },
    i(2),
    t { '', 'end' },
  }),
  s('f', {
    t('function '),
    i(1),
    t('('),
    i(2),
    c(3, {
      sn(nil, {
        t { ')', '\t' },
        r(1, 'code'),
        t { '', 'end' },
      }),
      sn(nil, {
        t { ') ' },
        r(1, 'code'),
        t { ' end' },
      }),
    }),
  }),
  s('fmt', {
    t('string.format('),
    i(1),
    t(', '),
    i(0),
    t(')'),
  }),
  s('vf', {
    t('vim.fn'),
    c(1, {
      sn(nil, {
        t('.'),
        i(1),
      }),
      sn(nil, {
        t('[' .. quote),
        i(1),
        t(quote .. ']'),
      }),
    }),
    i(0),
  }),
  s('va', {
    c(1, {
      sn(nil, {
        t('api.nvim_'),
        i(1),
      }),
      sn(nil, {
        t('vim.api.nvim_'),
        i(1),
      }),
    }),
    i(0),
  }),
  s('map', {
    t('vim.keymap.set('),
    c(1, {
      sn(nil, {
        t(quote),
        i(1),
        t(quote),
      }),
      sn(nil, {
        t('{ '),
        i(1),
        t(' }'),
      }),
    }),
    t(', ' .. quote),
    i(2),
    t(quote .. ', '),
    c(3, {
      sn(nil, {
        t(quote),
        i(1),
        t(quote),
      }),
      sn(nil, {
        t { 'function()', '\t' },
        i(1),
        t { '', 'end' },
      }),
    }),
    c(4, {
      t(''),
      sn(nil, {
        t(', { '),
        i(1),
        t(' }'),
      }),
    }),
    i(0),
    t(')'),
  }),
  s('au', {
    t('vim.api.nvim_create_autocmd(' .. quote),
    i(1),
    t { quote .. ', {', '\t' },
    t('pattern = '),
    i(2),
    t { ',', '\t' },
    c(3, {
      sn(nil, {
        t('callback = '),
        i(1),
      }),
      sn(nil, {
        t('command = '),
        i(1),
      }),
    }),
    i(0),
    t { '', '})' },
  }),
  s('aug', {
    t('vim.api.nvim_create_augroup(' .. quote),
    i(1),
    t(quote .. ', {'),
    c(2, {
      sn(nil, {
        t(''),
        i(1),
      }),
      sn(nil, {
        t(' clear = '),
        i(1),
        t(' '),
      }),
    }),
    t('})'),
  }),
  s('com', {
    t('vim.api.nvim_create_user_command(' .. quote),
    i(1),
    t(quote .. ', function('),
    i(2),
    t { ')', '\t' },
    i(3),
    t { '', 'end, {' },
    i(0),
    t('})'),
  }),
  s('opt', {
    c(1, {
      t('vim.opt.'),
      t('vim.opt_local.'),
      t('vim.opt_global.'),
    }),
    i(2),
    c(3, {
      t(' = '),
      t(':append'),
      t(':remove'),
      t(':prepend'),
    }),
    i(0),
  }),
}
