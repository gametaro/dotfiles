local get_probe_dir = function()
  return vim.fs.find({ 'node_modules' }, { path = vim.api.nvim_buf_get_name(0), upward = true })[1]
end

local get_cmd = function()
  local probe_dir = get_probe_dir()
  local local_cmd = probe_dir .. '/.bin/ngserver'
  local cmd = vim.fn.executable(local_cmd) == 1 and local_cmd or 'ngserver'
  return {
    cmd,
    '--stdio',
    '--tsProbeLocations',
    probe_dir,
    '--ngProbeLocations',
    probe_dir,
  }
end

local cmd = get_cmd()
if vim.fn.executable(table.concat(cmd, ' ')) == 1 then
  vim.g.lsp_start({
    name = 'ng',
    cmd = cmd,
    root_patterns = { 'angular.json' },
    on_new_config = function(new_config, _)
      new_config.cmd = get_cmd()
    end,
  })
end
