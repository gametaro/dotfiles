local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local spec = require('nightfox.spec').load(vim.g.colors_name)
local palette = require('nightfox.palette').load(vim.g.colors_name)
local job = require('ky.job')

local colors = {
  fg = spec.fg2,
  bg = spec.bg2,
  git = spec.git,
  diff = spec.diff,
  diag = spec.diag,
  black = palette.black.bright,
  blue = palette.blue.base,
  cyan = palette.cyan.dim,
  green = palette.green.dim,
  magenta = palette.magenta.dim,
  orange = palette.orange.dim,
  pink = palette.pink.base,
  red = palette.red.base,
  white = palette.white.dim,
  yellow = palette.yellow.dim,
}

local Align = { provider = '%=' }
local Space = { provider = ' ' }

local git_rev = function()
  job(
    'git',
    {
      'rev-list',
      '--count',
      '--left-right',
      'HEAD...@{upstream}',
    },
    vim.schedule_wrap(function(data)
      local ahead, behind = unpack(vim.split(data or '', '\t'))
      vim.api.nvim_set_var('git_rev', {
        ahead = tonumber(ahead) or 0,
        behind = tonumber(behind) or 0,
      })
    end)
  )
end

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('GitRev', { clear = true }),
  once = true,
  callback = function()
    local timer = vim.loop.new_timer()
    timer:start(0, 10000, function()
      git_rev()
    end)
  end,
})

local ViMode = {
  init = function(self)
    self.mode = vim.api.nvim_get_mode().mode
  end,
  static = {
    mode_names = {
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = colors.green,
      i = colors.red,
      v = colors.cyan,
      V = colors.cyan,
      ['\22'] = colors.cyan,
      c = colors.orange,
      s = colors.magenta,
      S = colors.magenta,
      ['\19'] = colors.magenta,
      R = colors.orange,
      r = colors.orange,
      ['!'] = colors.red,
      t = colors.red,
    },
  },
  provider = function(self)
    return '%2(' .. self.mode_names[self.mode] .. '%)'
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return {
      fg = self.mode_colors[mode],
      bold = true,
    }
  end,
}

local FileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

local FileIcon = {
  init = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ':t')
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(
      filename,
      extension,
      { default = true }
    )
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local FileName = {
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ':t')
    if self.lfilename == '' then
      self.lfilename = '[No Name]'
    end
  end,
  provider = function(self)
    return self.lfilename
  end,
}

local FilePath = {
  init = function(self)
    self.filepath = vim.fn.fnamemodify(self.filename, ':.:h')
    if self.filepath == '' then
      self.filepath = '[No Name]'
    end
  end,
  utils.make_flexible_component(2, {
    provider = function(self)
      return self.filepath
    end,
  }, {
    provider = function(self)
      return vim.fn.pathshorten(self.filepath)
    end,
  }),
  hl = { fg = utils.get_highlight('Comment').fg },
}

local FileFlags = {
  {
    provider = function()
      return vim.bo.modified and ' ●' -- '
    end,
    hl = { fg = utils.get_highlight('diffChanged').fg },
  },
  {
    provider = function()
      return (not vim.bo.modifiable or vim.bo.readonly) and ' '
    end,
    hl = { fg = colors.orange },
  },
}

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      return { bold = true, force = true }
    end
  end,
}

FileNameBlock = utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName),
  unpack(FileFlags),
  Space,
  FilePath,
  { provider = '%<' }
)

local FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = { fg = utils.get_highlight('Comment').fg },
}

local FileEncoding = {
  provider = function()
    local encoding = (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.o.encoding
    return encoding
  end,
  hl = { fg = utils.get_highlight('Comment').fg },
}

local FileFormat = {
  init = function(self)
    self.fileformat = vim.bo.fileformat
  end,
  static = {
    fileformat_icon = {
      unix = '',
      mac = '',
      windows = '',
    },
  },
  provider = function(self)
    return self.fileformat_icon[self.fileformat]
  end,
  hl = { fg = utils.get_highlight('Comment').fg },
}

local FileSize = {
  provider = function()
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local stat = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    local fsize = stat and stat.size or 0
    if fsize <= 0 then
      return '0' .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format('%.3g%s', fsize / math.pow(1024, i), suffix[i + 1])
  end,
  hl = { fg = utils.get_highlight('Comment').fg },
}

-- local FileLastModified = {
--   provider = function()
--     local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
--     return (ftime > 0) and os.date('%c', ftime)
--   end,
-- }

local Ruler = {
  {
    provider = function()
      return '%l'
    end,
    hl = { fg = spec.fg2 },
  },
  {
    provider = function()
      return '/%2L:'
    end,
    hl = { fg = utils.get_highlight('Comment').fg },
  },
  {
    provider = function()
      return '%2c'
    end,
    hl = { fg = spec.fg2 },
  },
}

local LSPActive = {
  condition = conditions.lsp_attached,
  provider = function()
    local clients = table.concat(
      vim.tbl_map(function(client)
        return client and client.name or ''
      end, vim.lsp.get_active_clients { bufnr = 0 }),
      ' '
    )
    if not conditions.width_percent_below(#clients, 0.25) then
      return
    end
    return clients
  end,
  hl = { fg = utils.get_highlight('Comment').fg },
}

local Diagnostics = {
  condition = conditions.has_diagnostics,
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,
  static = {
    error_icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
    warn_icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
    info_icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
    hint_icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
  },
  {
    provider = function(self)
      return self.errors > 0 and self.error_icon .. self.errors .. ' '
    end,
    hl = { fg = colors.diag.error },
  },
  {
    provider = function(self)
      return self.warnings > 0 and self.warn_icon .. self.warnings .. ' '
    end,
    hl = { fg = colors.diag.warn },
  },
  {
    provider = function(self)
      return self.info > 0 and self.info_icon .. self.info .. ' '
    end,
    hl = { fg = colors.diag.info },
  },
  {
    provider = function(self)
      return self.hints > 0 and self.hint_icon .. self.hints
    end,
    hl = { fg = colors.diag.hint },
  },
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
  end,
  {
    provider = function(self)
      return ' ' .. self.status_dict.head
    end,
    hl = { fg = colors.magenta, bold = true },
  },
  {
    condition = function()
      local has_git_rev = pcall(vim.api.nvim_get_var, 'git_rev')
      return has_git_rev
    end,
    provider = function()
      return (vim.g.git_rev.ahead > 0 and ' ⇡' .. vim.g.git_rev.ahead or '')
        .. (vim.g.git_rev.behind > 0 and ' ⇣' .. vim.g.git_rev.behind or '')
    end,
    hl = { fg = colors.orange },
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ' +' .. count
    end,
    hl = { fg = colors.git.add },
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ' -' .. count
    end,
    hl = { fg = colors.git.removed },
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ' ~' .. count
    end,
    hl = { fg = colors.git.changed },
  },
}

local WorkDir = {
  provider = function(self)
    self.icon = (vim.fn.haslocaldir() == 1 and 'l' or vim.fn.haslocaldir(-1, 0) == 1 and 't' or 'g')
      .. ' '
      .. ' '
    self.cwd = vim.fn.fnamemodify(vim.loop.cwd(), ':~')
  end,
  hl = { fg = utils.get_highlight('Directory').fg, bold = true },
  utils.make_flexible_component(2, {
    provider = function(self)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.icon .. self.cwd .. trail .. ' '
    end,
  }, {
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.icon .. cwd .. trail .. ' '
    end,
  }, {
    provider = '',
  }),
}

local TerminalName = {
  init = function(self)
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color_by_filetype(
      'terminal',
      { default = true }
    )
    self.tname = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
  end,
  provider = function(self)
    return self.icon .. ' ' .. self.tname
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local TerminalTitle = {
  provider = function()
    return vim.b.term_title
  end,
  hl = { fg = utils.get_highlight('Comment').fg },
}

local QuickfixName = {
  condition = function()
    return vim.bo.filetype == 'qf'
  end,
  init = function(self)
    self.qflist = vim.fn.getqflist { winid = 0, title = 0, size = 0, nr = 0, idx = 0 }
    self.loclist = vim.fn.getloclist(0, { winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
    self.qf_open = self.qflist.winid ~= 0
    self.loc_open = self.loclist.winid ~= 0
  end,
  Space,
  {
    provider = function(self)
      return self.qf_open and 'Q' or self.loc_open and 'L' or ''
    end,
    hl = { fg = colors.gray },
  },
  Space,
  {
    provider = function(self)
      return self.qf_open and self.qflist.title or self.loc_open and self.loclist.title or ''
    end,
    hl = { fg = colors.green },
  },
  Space,
  {
    provider = function(self)
      local idx = self.qf_open and self.qflist.idx or self.loc_open and self.loclist.idx or ''
      local size = self.qf_open and self.qflist.size or self.loc_open and self.loclist.size or ''
      return string.format('(%s / %s)', idx, size)
    end,
    hl = { fg = colors.gray },
  },
  Space,
  {
    provider = function(self)
      local nr = self.qf_open and self.qflist.nr or self.loc_open and self.loclist.nr or ''
      local nrs = self.qf_open and vim.fn.getqflist({ nr = '$' }).nr
        or self.loc_open and vim.fn.getloclist(0, { nr = '$' }).nr
        or ''
      return string.format('[%s / %s]', nr, nrs)
    end,
    hl = { fg = colors.gray },
  },
}

local HelpFileName = {
  condition = function()
    return vim.bo.filetype == 'help'
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return ' ' .. vim.fn.fnamemodify(filename, ':t')
  end,
}

local TelescopeName = {
  condition = function()
    return vim.bo.filetype == 'TelescopePrompt'
  end,
  provider = function()
    return ''
  end,
}

local LirName = {
  init = function(self)
    local dir = require('lir').get_context().dir
    self.dir = vim.fn.fnamemodify(dir, ':.:h')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color('lir_folder_icon')
  end,
  condition = function()
    return vim.bo.filetype == 'lir'
  end,
  provider = function(self)
    return self.icon .. ' ' .. self.dir
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local Spell = {
  condition = function()
    return vim.wo.spell
  end,
  provider = '暈',
}

local Snippets = {
  condition = function()
    local has_luasnip = prequire('luasnip')
    return vim.tbl_contains({ 's', 'i' }, vim.api.nvim_get_mode().mode) and has_luasnip
  end,
  provider = function()
    local forward = (require('luasnip').expand_or_locally_jumpable()) and '' or ''
    local backward = (require('luasnip').jumpable(-1)) and ' ' or ''
    return backward .. forward
  end,
  hl = { fg = colors.orange, bold = true },
}

local WinBars = {
  init = utils.pick_child_on_condition,
  {
    condition = function()
      return conditions.buffer_matches {
        buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
        filetype = { '^git.*' },
      }
    end,
    QuickfixName,
    LirName,
    TelescopeName,
    HelpFileName,
  },
  {
    condition = function()
      return conditions.buffer_matches { buftype = { 'terminal' } }
    end,
    {
      FileType,
      Space,
      TerminalName,
    },
  },
  {
    condition = function()
      return not conditions.is_active()
    end,
    { hl = { fg = 'gray', force = true }, FileNameBlock },
  },
  FileNameBlock,
  hl = function()
    return conditions.is_active()
        and {
          -- fg = utils.get_highlight('WinBar').fg,
          bg = utils.get_highlight('WinBar').bg,
        }
      or {
        -- fg = utils.get_highlight('WinBarNC').fg,
        bg = utils.get_highlight('WinBarNC').bg,
      }
  end,
}

local DefaultStatusLine = {
  ViMode,
  Space,
  -- FileNameBlock,
  -- Space,
  Git,
  Space,
  Diagnostics,
  Align,
  WorkDir,
  Align,
  Snippets,
  Spell,
  Space,
  LSPActive,
  Space,
  -- FileSize,
  -- Space,
  FileEncoding,
  Space,
  FileFormat,
  Space,
  FileType,
  Space,
  Ruler,
}

local InactiveStatusLine = {
  condition = function()
    return not conditions.is_active()
  end,
  FileType,
  Space,
  FileName,
  Align,
}

local SpecialStatusLine = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*' },
    }
  end,
  ViMode,
  Align,
  FileType,
  Space,
  Ruler,
}

local TerminalStatusLine = {
  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,
  { condition = conditions.is_active, ViMode, Space },
  Space,
  TerminalName,
  Space,
  TerminalTitle,
  Align,
  Ruler,
}

local StatusLines = {
  init = utils.pick_child_on_condition,
  SpecialStatusLine,
  TerminalStatusLine,
  InactiveStatusLine,
  DefaultStatusLine,
  hl = function()
    return conditions.is_active()
        and {
          fg = utils.get_highlight('StatusLine').fg,
          bg = utils.get_highlight('StatusLine').bg,
        }
      or {
        fg = utils.get_highlight('StatusLineNC').fg,
        bg = utils.get_highlight('StatusLineNC').bg,
      }
  end,
}

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('heirline', { clear = true }),
  callback = function()
    require('heirline').reset_highlights()
    require('heirline').setup(StatusLines)
  end,
})

require('heirline').setup(StatusLines, WinBars)
