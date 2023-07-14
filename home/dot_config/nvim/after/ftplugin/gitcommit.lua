local win = vim.api.nvim_get_current_win()
vim.win[win][0].spell = true
vim.opt.formatoptions:append({ 't' })
vim.bo.textwidth = 72
vim.bo.bufhidden = 'wipe'
