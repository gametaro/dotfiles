local job = require('ky.util').job
local icons = require('ky.ui').icons

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local diagnostic = vim.diagnostic

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
      api.nvim_set_var('git_rev', {
        ahead = tonumber(ahead) or 0,
        behind = tonumber(behind) or 0,
      })
    end)
  )
end

api.nvim_create_autocmd('VimEnter', {
  group = api.nvim_create_augroup('GitRev', { clear = true }),
  once = true,
  callback = function()
    local timer = vim.loop.new_timer()
    timer:start(0, 10000, function()
      git_rev()
    end)
  end,
})

return {
  'rebelot/heirline.nvim',
  event = 'UIEnter',
  config = function()
    local heirline = require('heirline')
    local conditions = require('heirline.conditions')
    local utils = require('heirline.utils')

    local setup_colors = function()
      return {
        git_add = utils.get_highlight('DiagnosticHint').fg,
        git_changed = utils.get_highlight('DiagnosticWarn').fg,
        git_removed = utils.get_highlight('DiagnosticError').fg,
        diff_add = utils.get_highlight('DiffAdd').bg,
        diff_change = utils.get_highlight('DiffChange').bg,
        diff_delete = utils.get_highlight('DiffDelete').bg,
        diag_error = utils.get_highlight('DiagnosticError').fg,
        diag_warn = utils.get_highlight('DiagnosticWarn').fg,
        diag_info = utils.get_highlight('DiagnosticInfo').fg,
        diag_hint = utils.get_highlight('DiagnosticHint').fg,
        cyan = utils.get_highlight('Title').fg,
        green = utils.get_highlight('DiagnosticInfo').fg,
        magenta = utils.get_highlight('DiagnosticHint').fg,
        orange = utils.get_highlight('DiagnosticWarn').fg,
        red = utils.get_highlight('DiagnosticError').fg,
        gray = utils.get_highlight('NonText').fg,
      }
    end
    heirline.load_colors(setup_colors())

    local Align = { provider = '%=' }
    local Space = { provider = ' ' }

    api.nvim_create_autocmd('User', {
      pattern = 'HeirlineInitWinbar',
      callback = function(a)
        local buf = a.buf
        local buftype = vim.tbl_contains({ 'prompt', 'nofile' }, vim.bo[buf].buftype)
        local filetype = vim.tbl_contains({ 'gitcommit' }, vim.bo[buf].filetype)

        if (buftype or filetype) and vim.bo[buf].filetype ~= 'lir' then
          vim.opt_local.winbar = nil
        end
      end,
    })

    local ViMode = {
      init = function(self)
        self.mode = api.nvim_get_mode().mode
        if not self.once then
          api.nvim_create_autocmd('ModeChanged', {
            pattern = '*:*o',
            command = 'redrawstatus',
          })
          self.once = true
        end
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
          n = 'green',
          i = 'red',
          v = 'cyan',
          V = 'cyan',
          ['\22'] = 'cyan',
          c = 'orange',
          s = 'magenta',
          S = 'magenta',
          ['\19'] = 'magenta',
          R = 'orange',
          r = 'orange',
          ['!'] = 'red',
          t = 'red',
        },
      },
      update = 'ModeChanged',
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
        self.filename = api.nvim_buf_get_name(0)
      end,
      on_click = {
        name = 'heirline_filename',
        callback = function(self)
          cmd.edit(vim.fs.dirname(self.filename))
        end,
      },
    }

    local FileIcon = {
      init = function(self)
        local filename = vim.fs.basename(self.filename)
        local extension = fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color =
          require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        local filename = vim.fs.basename(self.filename)
        return filename == '' and '[No Name]' or filename
      end,
      hl = { bold = false },
    }

    local FilePath = {
      provider = function(self)
        local filepath = fn.fnamemodify(self.filename, ':.:h')
        if not filepath then
          return
        end
        local trail = filepath:sub(-1) == '/' and '' or '/'
        if not conditions.width_percent_below(#filepath, 0.5) then
          filepath = fn.pathshorten(filepath)
        end
        return filepath .. trail
      end,
      hl = { fg = utils.get_highlight('Comment').fg },
    }

    local FileFlags = {
      {
        condition = function()
          return not vim.bo.modified and not vim.bo.readonly
        end,
        -- a small performance improvement:
        -- re register the component callback only on layout/buffer changes.
        update = { 'WinNew', 'WinClosed', 'BufEnter' },
        { provider = ' ' },
        {
          provider = '',
          hl = { fg = 'gray' },
          on_click = {
            callback = function(_, winid)
              pcall(api.nvim_win_close, winid, true)
            end,
            name = function(self)
              return 'heirline_close_button_' .. self.winnr
            end,
            update = true,
          },
        },
      },
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = function()
          return ' ●' -- '
        end,
        hl = { fg = 'diff_change' },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = function()
          return ' '
        end,
        hl = { fg = 'diag_warn' },
      },
    }

    FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, Space, FilePath)

    local FileType = {
      provider = function()
        return vim.bo.filetype
      end,
      hl = { fg = utils.get_highlight('Comment').fg },
    }

    local FileEncoding = {
      provider = function()
        local encoding = (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.o.encoding
        return string.upper(encoding)
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

    local Ruler = {
      {
        provider = function()
          return '%3l'
        end,
      },
      {
        provider = function()
          return '/%3L:'
        end,
        hl = { fg = utils.get_highlight('Comment').fg },
      },
      {
        provider = function()
          return '%3c'
        end,
      },
    }

    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      on_click = {
        name = 'heirline_lsp',
        callback = function()
          -- use vim.defer_fn() if the callback requires opening of a floating window
          vim.defer_fn(function()
            cmd.LspInfo()
          end, 100)
        end,
      },
      provider = function()
        local clients = table.concat(vim.tbl_map(function(client)
          return client and string.format('%.4s…', client.name) or ''
        end, vim.lsp.get_active_clients({ bufnr = 0 })) or {}, ' ')
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
        self.errors = #diagnostic.get(0, { severity = diagnostic.severity.ERROR })
        self.warnings = #diagnostic.get(0, { severity = diagnostic.severity.WARN })
        self.hints = #diagnostic.get(0, { severity = diagnostic.severity.HINT })
        self.info = #diagnostic.get(0, { severity = diagnostic.severity.INFO })
      end,
      static = {
        error_icon = string.format('%s ', icons.diagnostic.error),
        warn_icon = string.format('%s ', icons.diagnostic.warn),
        info_icon = string.format('%s ', icons.diagnostic.info),
        hint_icon = string.format('%s ', icons.diagnostic.hint),
      },
      update = function()
        return api.nvim_get_mode().mode:sub(1, 1) ~= 'i'
      end,
      -- update = { 'DiagnosticChanged', 'BufEnter' },
      on_click = {
        name = 'heirline_diagnostics',
        callback = function()
          local qf = fn.getqflist({ winid = 0, title = 0 })
          if not qf then
            return
          end

          if qf.winid ~= 0 and qf.title == 'Diagnostics' then
            cmd.cclose()
          else
            diagnostic.setqflist()
          end
        end,
      },
      {
        provider = function(self)
          return self.errors > 0 and self.error_icon .. self.errors .. ' '
        end,
        hl = { fg = 'diag_error' },
      },
      {
        provider = function(self)
          return self.warnings > 0 and self.warn_icon .. self.warnings .. ' '
        end,
        hl = { fg = 'diag_warn' },
      },
      {
        provider = function(self)
          return self.info > 0 and self.info_icon .. self.info .. ' '
        end,
        hl = { fg = 'diag_info' },
      },
      {
        provider = function(self)
          return self.hints > 0 and self.hint_icon .. self.hints
        end,
        hl = { fg = 'diag_error' },
      },
    }

    local Git = {
      condition = conditions.is_git_repo,
      {
        provider = function()
          return icons.git.branch .. ' ' .. vim.b.gitsigns_status_dict.head
        end,
        hl = { fg = 'magenta' },
      },
      {
        condition = function()
          return pcall(api.nvim_get_var, 'git_rev')
        end,
        provider = function()
          return (vim.g.git_rev.ahead > 0 and ' ' .. icons.git.ahead .. vim.g.git_rev.ahead or '')
            .. (vim.g.git_rev.behind > 0 and ' ' .. icons.git.behind .. vim.g.git_rev.behind or '')
        end,
        hl = { fg = 'orange' },
      },
      on_click = {
        name = 'heirline_Neogit',
        callback = function()
          cmd.Neogit()
        end,
      },
    }

    local GitStatus = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0
          or self.status_dict.removed ~= 0
          or self.status_dict.changed ~= 0
      end,
      on_click = {
        name = 'heirline_gitstatus',
        callback = function()
          local qf = fn.getqflist({ winid = 0, title = 0 })
          if not qf then
            return
          end

          if qf.winid ~= 0 and qf.title == 'Hunks' then
            cmd.cclose()
          else
            require('gitsigns').setqflist()
          end
        end,
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ' ' .. icons.git.add .. ' ' .. count
        end,
        hl = { fg = 'git_add' },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ' ' .. icons.git.remove .. ' ' .. count
        end,
        hl = { fg = 'git_removed' },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ' ' .. icons.git.change .. ' ' .. count
        end,
        hl = { fg = 'git_changed' },
      },
    }

    local WorkDir = {
      on_click = {
        name = 'heirline_workdir',
        callback = function()
          vim.defer_fn(function()
            cmd.edit('.')
          end, 100)
        end,
      },
      provider = function()
        local flag = (fn.haslocaldir() == 1 and 'L' or fn.haslocaldir(-1, 0) == 1 and 'T' or 'G')
        local icon = ''
        local cwd = fn.fnamemodify(vim.loop.cwd(), ':~')
        if not conditions.width_percent_below(#cwd, 0.25) then
          cwd = fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == '/' and '' or '/'
        return flag .. ' ' .. icon .. ' ' .. cwd .. trail
      end,
      hl = { fg = utils.get_highlight('Directory').fg },
    }

    local TerminalName = {
      init = function(self)
        self.icon, self.icon_color =
          require('nvim-web-devicons').get_icon_color_by_filetype('terminal', { default = true })
        self.tname = api.nvim_buf_get_name(0):gsub('.*:', '')
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
      hl = {
        fg = utils.get_highlight('Directory').fg,
      },
    }

    local QuickfixName = {
      condition = function()
        return vim.bo.filetype == 'qf'
      end,
      init = function(self)
        self.qflist = fn.getqflist({ winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
        self.loclist = fn.getloclist(0, { winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
        self.qf_open = self.qflist.winid ~= 0
        self.loc_open = self.loclist.winid ~= 0
      end,
      Space,
      {
        provider = function(self)
          return self.qf_open and 'Q' or self.loc_open and 'L' or ''
        end,
        hl = { fg = 'gray' },
      },
      Space,
      {
        provider = function(self)
          return self.qf_open and self.qflist.title or self.loc_open and self.loclist.title or ''
        end,
        hl = { fg = 'green' },
      },
      Space,
      {
        provider = function(self)
          local idx = self.qf_open and self.qflist.idx or self.loc_open and self.loclist.idx or ''
          local size = self.qf_open and self.qflist.size
            or self.loc_open and self.loclist.size
            or ''
          return string.format('[%s / %s]', idx, size)
        end,
        hl = { fg = 'gray' },
      },
      Space,
      {
        provider = function(self)
          local nr = self.qf_open and self.qflist.nr or self.loc_open and self.loclist.nr or ''
          local nrs = self.qf_open and fn.getqflist({ nr = '$' }).nr
            or self.loc_open and fn.getloclist(0, { nr = '$' }).nr
            or ''
          return string.format('(%s of %s)', nr, nrs)
        end,
        hl = { fg = 'gray' },
      },
    }

    local HelpFileName = {
      condition = function()
        return vim.bo.filetype == 'help'
      end,
      provider = function()
        return ' ' .. vim.fs.basename(api.nvim_buf_get_name(0))
      end,
    }

    local LirName = {
      condition = function()
        return vim.bo.filetype == 'lir'
      end,
      init = function(self)
        local dir = require('lir').get_context().dir
        self.dir = fn.fnamemodify(dir, ':~:h')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color('lir_folder_icon')
        self.show_hidden_files = require('lir.config').values.show_hidden_files
      end,
      Align,
      {
        provider = function(self)
          return self.icon
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      },
      Space,
      {
        provider = function(self)
          return self.dir
        end,
        hl = function()
          return { fg = utils.get_highlight('Comment').fg }
        end,
      },
      Space,
      {
        provider = function(self)
          return self.show_hidden_files and ' ' or ' '
        end,
        hl = function(self)
          return { fg = self.show_hidden_files and 'diag_warn' or 'gray' }
        end,
      },
      Align,
    }

    local Spell = {
      condition = function()
        return vim.wo.spell
      end,
      provider = '暈',
    }

    local WinBars = {
      fallthrough = false,
      LirName,
      {
        condition = function()
          return conditions.buffer_matches({
            buftype = { 'nofile', 'prompt' },
            filetype = { '^git.*' },
          })
        end,
        init = function()
          vim.opt_local.winbar = nil
        end,
      },
      QuickfixName,
      HelpFileName,
      {
        condition = function()
          return conditions.buffer_matches({ buftype = { 'terminal' } })
        end,
        {
          Space,
          TerminalName,
        },
      },
      {
        Space,
        FileNameBlock,
        Align,
        Diagnostics,
        Space,
        GitStatus,
        Space,
      },
      hl = function()
        return {
          bg = conditions.is_active() and utils.get_highlight('WinBar').bg
            or utils.get_highlight('WinBarNC').bg,
        }
      end,
    }

    local Tabpage = {
      provider = function(self)
        local cwd = fn.pathshorten(fn.getcwd(-1, self.tabnr))
        return '%' .. self.tabnr .. 'T' .. ' ' .. cwd .. ' '
      end,
      hl = function(self)
        return self.is_active and 'TabLineSel' or 'TabLine'
      end,
    }

    local TabPages = {
      condition = function()
        return #api.nvim_list_tabpages() >= 2
      end,
      utils.make_tablist(Tabpage),
      Align,
    }

    local TabLine = { TabPages }

    local DisableStatusLine = {
      condition = function()
        return vim.o.laststatus == 0
      end,
      provider = function()
        local winwidth = api.nvim_win_get_width(0)
        return string.rep('─', winwidth)
      end,
      hl = {
        fg = utils.get_highlight('WinSeparator').fg,
        bg = utils.get_highlight('WinSeparator').bg,
      },
    }

    local DefaultStatusLine = {
      ViMode,
      Space,
      Git,
      Align,
      WorkDir,
      Align,
      Spell,
      Space,
      LSPActive,
      Space,
      FileType,
      Space,
      FileEncoding,
      Space,
      FileFormat,
      Space,
      Ruler,
    }

    local InactiveStatusLine = {
      condition = function()
        return not conditions.is_active()
      end,
      FileNameBlock,
    }

    local SpecialStatusLine = {
      condition = function()
        return conditions.buffer_matches({
          buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
          filetype = { '^git.*' },
        })
      end,
      ViMode,
      Align,
      WorkDir,
      Align,
      FileType,
      Space,
      Ruler,
    }

    local TerminalStatusLine = {
      condition = function()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      { condition = conditions.is_active, ViMode, Space },
      Align,
      TerminalTitle,
      Align,
      Ruler,
    }

    local StatusLines = {
      fallthrough = false,
      DisableStatusLine,
      SpecialStatusLine,
      TerminalStatusLine,
      InactiveStatusLine,
      DefaultStatusLine,
      hl = function()
        return {
          fg = conditions.is_active() and utils.get_highlight('StatusLine').fg
            or utils.get_highlight('StatusLineNC').fg,
          bg = conditions.is_active() and utils.get_highlight('StatusLine').bg
            or utils.get_highlight('StatusLineNC').bg,
        }
      end,
    }

    api.nvim_create_autocmd('ColorScheme', {
      group = api.nvim_create_augroup('mine__heirline', {}),
      callback = function()
        utils.on_colorscheme(setup_colors())
      end,
    })

    heirline.setup(StatusLines, WinBars, TabLine)
  end,
}
