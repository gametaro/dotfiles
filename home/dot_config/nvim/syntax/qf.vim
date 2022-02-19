if exists('b:current_syntax')
  finish
endif

syn match qfFileName /^[^│]*/ nextgroup=qfSeparatorLeft
syn match qfSeparatorLeft /│/ contained nextgroup=qfLineNr
syn match qfLineNr /[^│]*/ contained nextgroup=qfSeparatorRight
syn match qfSeparatorRight '│' contained nextgroup=qfError,qfWarning,qfInfo,qfNote
syn match qfError / E .*$/ contained
syn match qfWarning / W .*$/ contained
syn match qfInfo / I .*$/ contained
syn match qfNote / [NH] .*$/ contained

lua <<EOF
vim.api.nvim_set_hl(0, 'qfFileName', { default = true, link = 'Directory' })
vim.api.nvim_set_hl(0, 'qfSeparatorLeft', { default = true, link = 'Delimiter' })
vim.api.nvim_set_hl(0, 'qfSeparatorRight', { default = true, link = 'Delimiter' })
vim.api.nvim_set_hl(0, 'qfLineNr', { default = true, link = 'LineNr' })
vim.api.nvim_set_hl(0, 'qfError', { default = true, link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, 'qfWarning', { default = true, link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'qfInfo', { default = true, link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, 'qfNote', { default = true, link = 'DiagnosticHint' })
EOF

let b:current_syntax = 'qf'
