local s = require('ky.snippets.helpers').s
local t = require('ky.snippets.helpers').t
local i = require('ky.snippets.helpers').i
local fmt = require('ky.snippets.helpers').fmt
local ins_generate = require('ky.snippets.helpers').ins_generate

local tag_gen = function(tag, attributes)
  attributes = attributes or {}
  local padding = ' '
  local _attributes = ''
  if not vim.tbl_isempty(attributes) then
    for _, attribute in ipairs(attributes) do
      _attributes = attribute == '' and _attributes .. padding .. '{}'
        or _attributes .. padding .. attribute .. '=' .. '"{}"'
    end
  end

  return s(tag, fmt(string.format('<%s%s>{}</%s>', tag, _attributes, tag), ins_generate()))
end

local tag_gen_2 = function(tag)
  return s(tag, { t(string.format('<%s />', tag)) })
end

local tags = {
  'a',
  'b',
  { 'button', { '' } },
  { 'li', { '' } },
  { 'div', { '' } },
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'i',
  'ins',
  'kbd',
  'legend',
  'li',
  'mark',
  'p',
  'pre',
  'q',
  'rp',
  'rt',
  's',
  'samp',
  'small',
  'span',
  'strong',
  'sup',
  'summary',
  'td',
  'th',
  'title',
  'tr',
  'u',
  'var',
  { 'iframe', { 'src' } },
  { 'img', { 'src', 'alt' } },
}

local snippets = {
  tag_gen_2('br'),
  tag_gen_2('hr'),
  s('html', {
    t { '<html>', '\t' },
    i(1),
    t { '', '</html>' },
  }),
  s('input', fmt('<input type="{}" name="{}" value="{}">', ins_generate())),
}

for _, tag in ipairs(tags) do
  if type(tag) == 'table' then
    local tagname, attributes = unpack(tag)
    table.insert(snippets, tag_gen(tagname, attributes))
  else
    table.insert(snippets, tag_gen(tag))
  end
end

return snippets
