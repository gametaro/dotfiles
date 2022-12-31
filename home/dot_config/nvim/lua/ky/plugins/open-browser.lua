return {
  'tyru/open-browser.vim',
  keys = {
    { 'gx', '<Plug>(openbrowser-smart-search)', mode = { 'n', 'x' } },
  },
  config = function()
    require('ky.abbrev').cabbrev('ob', 'OpenBrowserSmartSearch')
  end,
}
