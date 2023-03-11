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

local root_names = { 'angular.json' }
if require('ky.util').get_root_by_names(root_names) then
  vim.lsp.start({
    cmd = get_cmd(),
    root_names = root_names,
    on_new_config = function(new_config, _)
      new_config.cmd = get_cmd()
    end,
  })
end
