return {
  'andymass/vim-matchup',
  enabled = false,
  event = 'BufReadPost',
  init = function()
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_deferred_hide_delay = 300
    vim.g.matchup_matchparen_offscreen = { method = 'popup' }
  end,
}
