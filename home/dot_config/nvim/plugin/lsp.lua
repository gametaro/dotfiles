local icons = require('ky.ui').icons

local lsp = vim.lsp

local float = {
  border = require('ky.ui').border,
  source = 'always',
}

local signs = { Error = icons.error, Warn = icons.warn, Hint = icons.hint, Info = icons.info }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
  severity_sort = true,
  virtual_text = {
    source = 'always',
    prefix = '●',
    severity = vim.diagnostic.severity.ERROR,
  },
  float = float,
}

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, float)
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, float)
-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#use-nvim-notify-to-display-lsp-messages
lsp.handlers['window/showMessage'] = function(_, result, ctx)
  local client = lsp.get_client_by_id(ctx.client_id)
  local level = ({
    'ERROR',
    'WARN',
    'INFO',
    'DEBUG',
  })[result.type]
  vim.notify({ result.message }, level, {
    title = 'LSP | ' .. client.name,
  })
end

local client_notifs = {}

local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }

local function get_notif_data(client_id, token)
  if not client_notifs[client_id] then
    client_notifs[client_id] = {}
  end
  if not client_notifs[client_id][token] then
    client_notifs[client_id][token] = {}
  end
  return client_notifs[client_id][token]
end

local function update_spinner(client_id, token)
  local notif_data = get_notif_data(client_id, token)
  if notif_data.spinner then
    local new_spinner = (notif_data.spinner + 1) % #spinner_frames
    notif_data.spinner = new_spinner
    notif_data.notification = vim.notify(nil, nil, {
      hide_from_history = true,
      icon = spinner_frames[new_spinner],
      replace = notif_data.notification,
    })
    vim.defer_fn(function()
      update_spinner(client_id, token)
    end, 100)
  end
end

local function format_title(title, client)
  return client.name .. (#title > 0 and ': ' .. title or '')
end

local function format_message(message, percentage)
  return (percentage and percentage .. '%\t' or '') .. (message or '')
end

lsp.handlers['$/progress'] = function(_, result, ctx)
  local client_id = ctx.client_id
  local client_name = lsp.get_client_by_id(client_id).name
  local val = result.value
  local ignore = { 'null-ls' }
  if not val.kind or vim.tbl_contains(ignore, client_name) then
    return
  end

  local notif_data = get_notif_data(client_id, result.token)
  if val.kind == 'begin' then
    notif_data.notification = vim.notify(
      format_message(val.message or 'Loading...', val.percentage),
      'info',
      {
        title = format_title(val.title, lsp.get_client_by_id(client_id)),
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = true,
      }
    )
    notif_data.spinner = 1
    update_spinner(client_id, result.token)
  elseif val.kind == 'report' and notif_data then
    notif_data.notification = vim.notify(format_message(val.message, val.percentage), 'info', {
      replace = notif_data.notification,
      hide_from_history = false,
    })
  elseif val.kind == 'end' and notif_data then
    notif_data.notification = vim.notify(
      val.message and format_message(val.message) or 'Complete',
      'info',
      {
        icon = '',
        replace = notif_data.notification,
        timeout = 1000,
      }
    )
    notif_data.spinner = nil
  end
end
