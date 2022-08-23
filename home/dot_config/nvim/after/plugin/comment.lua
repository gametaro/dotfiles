local ok = prequire('Comment') and prequire('ts_context_commentstring')
if not ok then
  return
end

require('Comment').setup({
  ignore = '^$',
  mappings = {
    basic = true,
    extra = true,
    extended = false,
  },
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
