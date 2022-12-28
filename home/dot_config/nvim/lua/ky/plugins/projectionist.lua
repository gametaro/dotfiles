return {
  'tpope/vim-projectionist',
  init = function()
    vim.g.projectionist_heuristics = {
      ['*.lua'] = {
        ['*.lua'] = { alternate = { '{}_spec.lua' }, type = 'source' },
        ['*_spec.lua'] = { alternate = '{}.lua', type = 'test' },
      },
      ['*.ts'] = {
        ['*.ts'] = { alternate = { '{}.test.ts', '{}.spec.ts' }, type = 'source' },
        ['*.test.ts'] = { alternate = '{}.ts', type = 'test' },
        ['*.spec.ts'] = { alternate = '{}.ts', type = 'test' },
      },
      ['*.tsx'] = {
        ['*.tsx'] = { alternate = { '{}.test.tsx', '{}.spec.tsx' }, type = 'source' },
        ['*.test.tsx'] = { alternate = '{}.tsx', type = 'test' },
        ['*.spec.tsx'] = { alternate = '{}.tsx', type = 'test' },
      },
      ['*.py'] = {
        ['*.py'] = { alternate = { 'test_{}.py' }, type = 'source' },
        ['test_*.py'] = { alternate = { '{}.py' }, type = 'test' },
      },
    }
    vim.keymap.set('n', '<LocalLeader>a', vim.cmd.A)
    vim.keymap.set('n', '<LocalLeader>Av', vim.cmd.AV)
    vim.keymap.set('n', '<LocalLeader>As', vim.cmd.AS)
  end,
}
