local doskey = function (lhs, rhs, opts)
  opts = opts or '$*'
  os.execute(string.format('doskey %s=%s %s', lhs, rhs, opts))
end

doskey('cat', 'type')
doskey('cp', 'copy')
doskey('cpr', 'xcopy')
doskey('ls', 'dir')
doskey('man', 'help')
doskey('mv', 'move')
doskey('ps', 'tasklist')
doskey('pwd', 'cd')
doskey('rm', 'del')
doskey('rmr', 'deltree')

doskey('g', 'git')
doskey('v', 'nvim')

