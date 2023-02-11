return {
  'tyru/open-browser.vim',
  keys = {
    { 'gx', '<Plug>(openbrowser-smart-search)', mode = { 'n', 'x' }, desc = { 'Open Browser' } },
  },
  config = function()
    require('ky.abbrev').cabbrev('ob', 'OpenBrowserSmartSearch')
  end,
}
