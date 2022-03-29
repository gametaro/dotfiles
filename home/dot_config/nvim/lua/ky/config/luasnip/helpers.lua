local ls = require('luasnip')

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
  ins_generate = ins_generate,
  rep_generate = rep_generate,
}
