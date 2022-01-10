local npairs = require 'nvim-autopairs'
npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { 'string' },
    javascript = { 'template_string' },
  },
  enable_check_bracket_line = true,
  fast_wrap = {},
  map_bs = true,
  map_c_h = true,
  map_c_w = true,
}

local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

local Rule = require 'nvim-autopairs.rule'
local cond = require 'nvim-autopairs.conds'

npairs.add_rules {
  -- add {} afer =>
  -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#arrow-key-on-javascript
  Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript' })
    :use_regex(true)
    :set_end_pair_length(2),
  -- add spaces between parentheses
  -- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#add-spaces-between-parentheses
  Rule(' ', ' '):with_pair(function(opts)
    local pair = opts.line:sub(opts.col - 1, opts.col)
    return vim.tbl_contains({ '()', '[]', '{}' }, pair)
  end),
  Rule('( ', ' )')
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match '.%)' ~= nil
    end)
    :use_key ')',
  Rule('{ ', ' }')
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match '.%}' ~= nil
    end)
    :use_key '}',
  Rule('[ ', ' ]')
    :with_pair(function()
      return false
    end)
    :with_move(function(opts)
      return opts.prev_char:match '.%]' ~= nil
    end)
    :use_key ']',
  -- add spaces on f=
  -- see https://github.com/windwp/nvim-autopairs/wiki/Custom-rules#auto-addspace-on-
  Rule('=', '')
    :with_pair(cond.not_inside_quote())
    :with_pair(cond.not_filetypes { 'sh' })
    :with_pair(function(opts)
      local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
      if last_char:match '[%w%=%s]' then
        return true
      end
      return false
    end)
    :replace_endpair(function(opts)
      local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
      local next_char = opts.line:sub(opts.col, opts.col)
      next_char = next_char == ' ' and '' or ' '
      if prev_2char:match '%w$' then
        return '<bs> =' .. next_char
      end
      if prev_2char:match '%=$' then
        return next_char
      end
      if prev_2char:match '=' then
        return '<bs><bs>=' .. next_char
      end
      return ''
    end)
    :set_end_pair_length(0)
    :with_move(cond.none())
    :with_del(cond.none()),
  -- add spaces on f+
  Rule('+', '')
    :with_pair(cond.not_inside_quote())
    :with_pair(function(opts)
      local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
      if last_char:match '[%w%+%s]' then
        return true
      end
      return false
    end)
    :replace_endpair(function(opts)
      local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
      local next_char = opts.line:sub(opts.col, opts.col)
      next_char = next_char == ' ' and '' or ' '
      if prev_2char:match '%w$' then
        return '<bs> +' .. next_char
      end
      if prev_2char:match '%+$' then
        return next_char
      end
      if prev_2char:match '+' then
        return '<bs><bs>+' .. next_char
      end
      return ''
    end)
    :set_end_pair_length(0)
    :with_move(cond.none())
    :with_del(cond.none()),
  -- add spaces on f-
  Rule('-', '')
    :with_pair(cond.not_inside_quote())
    :with_pair(function(opts)
      local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
      if last_char:match '[%w%-%s]' then
        return true
      end
      return false
    end)
    :replace_endpair(function(opts)
      local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
      local next_char = opts.line:sub(opts.col, opts.col)
      next_char = next_char == ' ' and '' or ' '
      if prev_2char:match '%w$' then
        return '<bs> -' .. next_char
      end
      if prev_2char:match '%-$' then
        return next_char
      end
      if prev_2char:match '-' then
        return '<bs><bs>-' .. next_char
      end
      return ''
    end)
    :set_end_pair_length(0)
    :with_move(cond.none())
    :with_del(cond.none()),
  -- Rule(':', '')
  --   :with_pair(cond.not_inside_quote())
  --   :with_pair(function(opts)
  --     local last_char = opts.line:sub(opts.col - 1, opts.col - 1)
  --     if last_char:match '[%w%:%s]' then
  --       return true
  --     end
  --     return false
  --   end)
  --   :replace_endpair(function(opts)
  --     local prev_2char = opts.line:sub(opts.col - 2, opts.col - 1)
  --     local next_char = opts.line:sub(opts.col, opts.col)
  --     next_char = next_char == ' ' and '' or ' '
  --     if prev_2char:match '%w$' then
  --       return '<bs>:' .. next_char
  --     end
  --     if prev_2char:match ':$' then
  --       return next_char
  --     end
  --     if prev_2char:match ':' then
  --       return '<bs><bs>:' .. next_char
  --     end
  --     return ''
  --   end)
  --   :set_end_pair_length(0)
  --   :with_move(cond.none())
  --   :with_del(cond.none()),
}
