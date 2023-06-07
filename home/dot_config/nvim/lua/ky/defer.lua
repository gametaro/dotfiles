-- Credit: https://github.com/runiq/neovim-throttle-debounce

local defer = {}

---Throttles a function on the leading edge. Automatically `schedule_wrap()`s.
---@param fn function Function to throttle
---@param ms integer Timeout in ms
---@return function fn Debounced function
function defer.throttle_leading(fn, ms)
  local timer = vim.uv.new_timer()
  local running = false

  return function(...)
    if not running then
      timer:start(ms, 0, function()
        running = false
        timer:stop()
      end)
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
end

---Throttles a function on the trailing edge. Automatically `schedule_wrap()`s.
---@param fn function Function to throttle
---@param ms number Timeout in ms
---@return function fn Debounced function
function defer.throttle_trailing(fn, ms)
  local timer = vim.uv.new_timer()
  local running = false

  return function(...)
    if not running then
      local argv = { ... }
      local argc = select('#', ...)

      timer:start(ms, 0, function()
        running = false
        timer:stop()
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
      running = true
    end
  end
end

---Debounces a function on the leading edge. Automatically `schedule_wrap()`s.
---@param fn function Function to debounce
---@param ms integer Timeout in ms
---@return function fn Debounced function
function defer.debounce_leading(fn, ms)
  local timer = vim.uv.new_timer()
  local running = false

  return function(...)
    timer:start(ms, 0, function()
      running = false
      timer:stop()
    end)

    if not running then
      running = true
      pcall(vim.schedule_wrap(fn), select(1, ...))
    end
  end
end

---Debounces a function on the trailing edge. Automatically `schedule_wrap()`s.
---@param fn function Function to debounce
---@param ms integer Timeout in ms
---@return function fn Debounced function
function defer.debounce_trailing(fn, ms)
  local timer = vim.uv.new_timer()

  return function(...)
    local argv = { ... }
    local argc = select('#', ...)

    timer:start(ms, 0, function()
      timer:stop()
      pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
    end)
  end
end

return defer
