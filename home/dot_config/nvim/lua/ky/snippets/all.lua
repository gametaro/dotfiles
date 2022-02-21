local s = require('ky.snippets.helpers').s
local i = require('ky.snippets.helpers').i
local fmt = require('ky.snippets.helpers').fmt

return {
  s('r', fmt('return {}', i(1))),
}
