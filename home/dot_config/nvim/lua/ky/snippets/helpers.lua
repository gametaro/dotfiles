local ls = require('luasnip')

local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta

local function ins_generate(nodes)
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
end

local function rep_generate(nodes)
  return setmetatable(nodes or {}, {
    __index = function(table, key)
      local idx = tonumber(key)
      if idx then
        local val = ls.r(idx, key)
        rawset(table, key, val)
        return val
      end
    end,
  })
end

return {
  s = ls.s,
  i = ls.i,
  t = ls.t,
  c = ls.c,
  sn = ls.sn,
  d = ls.d,
  r = ls.r,
  f = ls.f,
  fmt = fmt,
  fmta = fmta,
  ins_generate = ins_generate,
  rep_generate = rep_generate,
}
