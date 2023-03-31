-- Credit: vim-edgemotion

---@param s string
---@return boolean
local function is_white(s)
  return string.match(s, '^%s$') ~= nil
end

---@param lnum integer
---@param startcol integer
---@param length integer
---@return string
local function get_chars(lnum, startcol, length)
  local line = vim.fn.getline(lnum)
  if vim.fn.strdisplaywidth(line) < startcol then
    return ''
  end

  local col = 0
  local endcol = startcol + length - 1
  local chars = {}
  for _, c in ipairs(vim.fn.split(line, [[\zs]])) do
    col = col + vim.fn.strdisplaywidth(c)
    if col > endcol then
      break
    elseif col >= startcol then
      table.insert(chars, c)
    end
  end

  return table.concat(chars)
end

---@param lnum integer
---@param col integer
---@return boolean
local function is_block(lnum, col)
  local char = get_chars(lnum, col, 1)
  if char == '' then
    return false
  end
  if not is_white(char) then
    return true
  end
  local chars = vim.fn.split(get_chars(lnum, col - 1, 3), [[\zs]])
  if #chars ~= 3 then
    return false
  end
  return not (is_white(chars[1]) or is_white(chars[3]))
end

---@param opts table
local function move(opts)
  opts = opts or {}
  local from = vim.fn.line('.')
  local to = opts.up and vim.fn.line('$') or 1

  if from == to then
    return
  end

  local col = vim.fn.virtcol('.')
  local on_block = is_block(from, col)
  local unit = opts.up and 1 or -1
  local on_edge = is_block(from, col) and not is_block(from + unit, col)
  local dst = from
  for i = from + unit, to, unit do
    if on_edge then
      if is_block(i, col) then
        dst = i
        break
      end
    else
      if on_block then
        if is_block(i, col) then
          if i == to then
            dst = i
            break
          end
        else
          dst = i - unit
          break
        end
      else
        if is_block(i, col) then
          dst = i
          break
        end
      end
    end
  end

  vim.fn.cursor({ dst, col })
end

local function up(opts)
  opts = opts or {}
  opts.up = true
  move(opts)
end

local function down(opts)
  opts = opts or {}
  opts.up = false
  move(opts)
end

vim.keymap.set({ 'n', 'x' }, '<C-j>', up, { desc = 'Next block' })
vim.keymap.set({ 'n', 'x' }, '<C-k>', down, { desc = 'Previous block' })
