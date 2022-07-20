local ok = prequire('nvim-surround')
if not ok then return end

---@param prompt? string
local get_input = function(prompt)
  local ok, result = pcall(vim.fn.input, { prompt = prompt })
  if not ok then return nil end
  return result
end

require('nvim-surround').buffer_setup {
  delimiters = {
    pairs = {
      ['f'] = function()
        local result = get_input('Enter the function name: ')
        if result then return { result .. '(', ')' } end
      end,
    },
  },
}
