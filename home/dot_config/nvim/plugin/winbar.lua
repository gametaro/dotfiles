-- local ok, gps = prequire('nvim-gps')

-- local fg = vim.api.nvim_get_hl_by_name('Comment', true).foreground
-- local bg = vim.api.nvim_get_hl_by_name('Statusline', true).background
-- vim.api.nvim_set_hl(0, 'WinBarGps', { fg = fg, bg = bg })

-- _G.winbar = function()
--   local win = vim.api.nvim_get_current_win()
--   local padding = string.rep(' ', 2)

--   if win == vim.g.statusline_winid and ok then
--     return gps.is_available() and padding .. '%#WinBarGps#' .. gps.get_location() .. '%*' or ''
--   end
--   local full_filename = vim.api.nvim_buf_get_name(0)
--   if full_filename == '' then
--     return ''
--   end

--   local filepath = vim.fn.fnamemodify(full_filename, ':.:h')
--   local filename = vim.fn.fnamemodify(full_filename, ':t')
--   local extension = vim.fn.fnamemodify(full_filename, ':e')

--   local icon, color = require('nvim-web-devicons').get_icon_color(
--     filename,
--     extension,
--     { default = true }
--   )

--   vim.api.nvim_set_hl(0, 'WinBarIcon', { fg = color, bg = bg })
--   vim.api.nvim_set_hl(0, 'WinBarFilePath', { fg = fg, bg = bg })

--   return padding
--     .. '%#WinBarIcon#'
--     .. icon
--     .. '%*'
--     .. ' '
--     .. filename
--     .. ' '
--     .. '%#WinBarFilePath#'
--     .. filepath
--     .. '%*'
-- end

-- vim.opt.winbar = '%!v:lua._G.winbar()'
