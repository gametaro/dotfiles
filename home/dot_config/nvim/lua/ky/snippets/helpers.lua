local ls = require('luasnip')

return {
  s = ls.s,
  i = ls.i,
  t = ls.t,
  c = ls.c,
  sn = ls.sn,
  d = ls.d,
  r = ls.r,
  f = ls.f,
  fmt = require('luasnip.extras.fmt').fmt,
  fmta = require('luasnip.extras.fmt').fmta,
  ins_generate = function(nodes)
    return setmetatable(nodes or {}, {
      __index = function(table, key)
        local idx = tonumber(key)
        if idx then
          local val = ls.i(idx)
          rawset(table, key, val)
          return val
        end
      end,
    })
  end,
  rep_generate = function(nodes)
    return setmetatable(nodes or {}, {
      __index = function(table, key)
        local idx = tonumber(key)
        if idx then
          local val = ls.r(idx, tostring(idx))
          rawset(table, key, val)
          return val
        end
      end,
    })
  end,
}
