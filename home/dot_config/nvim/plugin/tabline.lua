local surround = function(head)
  return function(tail)
    return function(s)
      return head .. s .. tail
    end
  end
end

local h = function(s)
  return surround('%#')('#')(s)
end

local pad = function(s)
  return surround(' ')(' ')(s)
end

local name_hl = function(hl)
  local attr = vim.tbl_filter(function(k)
    return not vim.tbl_contains({ 'fg', 'bg', 'sp' }, k) and hl[k]
  end, vim.tbl_keys(hl))
  return 'TabLine'
    .. (hl.fg and tostring(hl.fg):gsub('#', '') or '_')
    .. (hl.bg and tostring(hl.bg):gsub('#', '') or '_')
    .. (hl.sp and hl.sp:gsub(',', '') or '')
    .. table.concat(attr, '')
end

local set_hl = function(hl)
  hl = hl or {}
  hl.fg = hl.fg or vim.api.nvim_get_hl_by_name('TabLineSel', true).foreground
  hl.bg = hl.bg or vim.api.nvim_get_hl_by_name('TabLineSel', true).background
  local name = name_hl(hl)
  vim.api.nvim_set_hl(0, name, hl)
  return name
end

local is_active = function(tab)
  return vim.api.nvim_get_current_tabpage() == tab
end

local tab_buf = function(tab)
  return vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab))
end

local modified = function(tab)
  local ignore = { 'TelescopePrompt' }
  if vim.tbl_contains(ignore, vim.bo[(tab_buf(tab))].filetype) then return '' end
  return vim.api.nvim_buf_get_option(tab_buf(tab), 'modified') and '●' or '',
    { fg = vim.api.nvim_get_hl_by_name('diffChanged', true).foreground }
end

local fname = function(tab)
  local buf = tab_buf(tab)
  return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')
end

local cwd = function(tab)
  return vim.fn.pathshorten(
    vim.fn.fnamemodify(
      vim.fn.getcwd(vim.api.nvim_tabpage_get_win(tab), vim.api.nvim_tabpage_get_number(tab)),
      ':~'
    )
  ),
    {}
end

local icon = function(tab)
  local filename = vim.api.nvim_buf_get_name(tab_buf(tab))
  local extension = vim.fn.fnamemodify(filename, ':e')
  local ok, devicons = prequire('nvim-web-devicons')
  if not ok then return '' end
  local icon, color = devicons.get_icon_color(filename, extension, { default = true })
  return icon, { fg = color }
end

local process = function(component, tab)
  local label, hl = component(tab)
  local hlname = set_hl(hl)
  local head = is_active(tab) and h(hlname) or ''
  local tail = is_active(tab) and h('TabLineSel') or ''
  return surround(head)(tail)(label)
end

local components = { --[[ modified, icon, fname, ]]
  cwd,
}

local tabpage = function(tab)
  local t = vim.tbl_map(function(component)
    return process(component, tab)
  end, components)
  return (is_active(tab) and h('TabLineSel') or h('TabLine'))
    .. ('%' .. tostring(vim.api.nvim_tabpage_get_number(tab)) .. 'T') -- for mouse click
    .. pad(table.concat(t, ' '))
end

_G.tabline = function()
  local tabpages = vim.tbl_map(tabpage, vim.api.nvim_list_tabpages())
  return table.concat(tabpages) .. h('TabLineFill') .. '%='
end

vim.o.tabline = '%!v:lua._G.tabline()'
