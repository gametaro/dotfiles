local doskey = function(lhs, rhs, opts)
  opts = opts or '$*'
  os.execute(string.format('doskey %s=%s %s', lhs, rhs, opts))
end

doskey('g', 'git')
doskey('v', 'nvim')
