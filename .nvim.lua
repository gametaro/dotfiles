if vim.env.CHEZMOI_SOURCE_DIR then
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = vim.fs.joinpath(vim.env.CHEZMOI_SOURCE_DIR, '*'),
    callback = function(a)
      vim.system({ 'chezmoi', 'apply', '--no-tty', '--source-path', a.match }, nil, function(obj)
        if obj.code ~= 0 then
          if obj.stdout then vim.schedule(function() vim.notify(obj.stdout, vim.log.levels.WARN) end) end
          if obj.stderr then vim.schedule(function() vim.notify(obj.stderr, vim.log.levels.WARN) end) end
        end
      end)
    end,
    desc = 'Run chezmoi apply',
  })
end
