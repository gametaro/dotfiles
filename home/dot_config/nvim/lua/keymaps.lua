local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('x', '=', '=gv', opts)

map('n', 'x', '"_x', opts)

map('t', '<Esc>', [[<C-\><C-n>]], opts)

-- map('n', '<Leader>t', '<Cmd>tabclose<CR>', opts)

map('c', '<C-a>', '<Home>', { noremap = true })
map('c', '<C-b>', '<Left>', { noremap = true })
map('c', '<C-d>', '<Del>', { noremap = true })
map('c', '<C-e>', '<End>', { noremap = true })
map('c', '<C-f>', '<Right>', { noremap = true })
map('c', '<C-n>', '<Down>', { noremap = true })
map('c', '<C-p>', '<Up>', { noremap = true })

map('n', '<M-h>', '<C-w>h', opts)
map('n', '<M-j>', '<C-w>j', opts)
map('n', '<M-k>', '<C-w>k', opts)
map('n', '<M-l>', '<C-w>l', opts)
map('i', '<M-h>', '<Esc><C-w>h', opts)
map('i', '<M-j>', '<Esc><C-w>j', opts)
map('i', '<M-k>', '<Esc><C-w>k', opts)
map('i', '<M-l>', '<Esc><C-w>l', opts)

map('n', '<Leader>q', '<Cmd>lua require"utils".toggle_qf()<CR>', opts)

-- NOTE: https://github.com/mhinz/vim-galore#quickly-add-empty-lines
map('n', '[<Space>', "<Cmd>put! =repeat(nr2char(10), v:count1)<CR>'[", opts)
map('n', ']<Space>', '<Cmd>put =repeat(nr2char(10), v:count1)<CR>', opts)

map('n', '<Leader>cd', '<Cmd>tcd %:p:h<Bar>pwd<CR>', opts)
map('n', '<Leader>cu', '<Cmd>tcd ..<Bar>pwd<CR>', opts)

map('n', '<Leader>hi', '<Cmd> lua require"utils".highlight_under_cursor()<CR>', opts)

map('n', '<Leader>lq', '<Cmd> lua vim.diagnostic.setqflist()<CR>', opts)

map('n', '<BS>', '<C-^>', opts)

map('n', '<LocalLeader>tn', '<Cmd>tabnew<CR>', opts)
map('n', '<LocalLeader>tc', '<Cmd>tabclose<CR>', opts)
