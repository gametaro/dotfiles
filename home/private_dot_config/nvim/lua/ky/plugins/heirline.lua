local util = require('ky.util')
local icons = require('ky.ui').icons

return {
  'rebelot/heirline.nvim',
  event = 'UIEnter',
  config = function()
    local heirline = require('heirline')
    local conditions = require('heirline.conditions')
    local utils = require('heirline.utils')

    local setup_colors = function()
      return {
        cyan = utils.get_highlight('Identifier').fg,
        green = utils.get_highlight('String').fg,
        magenta = utils.get_highlight('Statement').fg,
        orange = utils.get_highlight('Constant').fg,
        red = utils.get_highlight('DiagnosticError').fg,
      }
    end
    heirline.load_colors(setup_colors())

    local group = vim.api.nvim_create_augroup('mine__heirline', {})

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = group,
      callback = function()
        utils.on_colorscheme(setup_colors())
      end,
    })

    if vim.fn.executable('git') == 1 and util.is_git_repo() then
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'HeirlineInitWinbar',
        once = true,
        callback = function()
          local timer = vim.loop.new_timer()
          if timer then
            timer:start(0, 10000, function()
              util.job(
                'git',
                { 'rev-list', '--count', '--left-right', 'HEAD...@{upstream}' },
                vim.schedule_wrap(function(_, data)
                  local ahead, behind = unpack(vim.split(data or '', '\t'))
                  vim.g.git_rev = {
                    ahead = tonumber(ahead) or 0,
                    behind = tonumber(behind) or 0,
                  }
                end)
              )
              util.job(
                'git',
                { 'status', '--porcelain', '--untracked-files=no' },
                vim.schedule_wrap(function(_, data)
                  vim.g.git_status = data ~= '' and true or false
                end)
              )
            end)
          end
        end,
      })
    end

    local Align = { provider = '%=' }
    local Space = { provider = ' ' }

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
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd.redrawstatus()
        end),
      },
      provider = function(self)
        return '%2(' .. self.mode_names[self.mode] .. '%)'
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode] }
      end,
    }

    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    local FileIcon = {
      init = function(self)
        local filename = vim.fs.basename(self.filename)
        local extension = vim.fn.fnamemodify(filename, ':e')
        local ok, devicons = pcall(require, 'nvim-web-devicons')
        if ok then
          self.icon, self.icon_color =
            devicons.get_icon_color(filename, extension, { default = true })
        end
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = '%t',
    }

    local FilePath = {
      provider = function(self)
        local filepath = vim.fn.fnamemodify(self.filename, ':.:h')
        if not filepath then
          return
        end
        if not conditions.width_percent_below(#filepath, 0.5) then
          filepath = vim.fn.pathshorten(filepath)
        end
        return filepath
      end,
      hl = 'Comment',
    }

    local FileFlags = {
      {
        provider = '%M', -- '
        hl = 'DiagnosticWarn',
      },
      {
        provider = '%R',
        hl = 'DiagnosticWarn',
      },
    }

    FileNameBlock = utils.insert(FileNameBlock, FileIcon, FileName, FileFlags, Space, FilePath)

    local FileType = {
      provider = '%Y',
    }

    local FileEncoding = {
      provider = function()
        local encoding = (vim.bo.fileencoding ~= '' and vim.bo.fileencoding) or vim.o.encoding
        return encoding:upper()
      end,
    }

    local FileFormat = {
      provider = function()
        return vim.bo.fileformat:upper()
      end,
    }

    local Ruler = {
      provider = '%3l/%3L:%3c',
    }

    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      provider = function()
        local clients = table.concat(vim.tbl_map(function(client)
          return client and string.len(client.name) > 3 and string.format('%.3s…', client.name)
        end, vim.lsp.get_active_clients({ bufnr = 0 })) or {}, ' ')
        if not conditions.width_percent_below(#clients, 0.25) then
          return
        end
        return clients
      end,
    }

    local Diagnostics = {
      condition = not vim.diagnostic.is_disabled,
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
      update = function()
        return vim.api.nvim_get_mode().mode:sub(1, 1) ~= 'i'
      end,
      {
        provider = function(self)
          return self.errors > 0 and self.error_icon .. self.errors .. ' '
        end,
        hl = 'DiagnosticError',
      },
      {
        provider = function(self)
          return self.warnings > 0 and self.warn_icon .. self.warnings .. ' '
        end,
        hl = 'DiagnosticWarn',
      },
      {
        provider = function(self)
          return self.info > 0 and self.info_icon .. self.info .. ' '
        end,
        hl = 'DiagnosticInfo',
      },
      {
        provider = function(self)
          return self.hints > 0 and self.hint_icon .. self.hints
        end,
        hl = 'DiagnosticHint',
      },
    }

    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        ---@diagnostic disable-next-line: undefined-field
        self.status_dict = vim.b.gitsigns_status_dict
      end,
      {
        provider = function(self)
          return icons.git.branch .. ' ' .. self.status_dict.head
        end,
      },
      {
        condition = function()
          return vim.g.git_status ~= nil
        end,
        provider = function()
          return vim.g.git_status and '* '
        end,
      },
      {
        condition = function()
          return vim.g.git_rev ~= nil
        end,
        provider = function()
          return (icons.git.behind .. vim.g.git_rev.behind)
            .. ' '
            .. (icons.git.ahead .. vim.g.git_rev.ahead)
        end,
      },
    }

    local GitStatus = {
      condition = conditions.is_git_repo,
      init = function(self)
        ---@diagnostic disable-next-line: undefined-field
        self.status_dict = vim.b.gitsigns_status_dict
      end,
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and icons.git.add .. count .. ' '
        end,
        hl = 'DiagnosticHint',
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and icons.git.remove .. count .. ' '
        end,
        hl = 'DiagnosticError',
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and icons.git.change .. count
        end,
        hl = 'DiagnosticWarn',
      },
    }

    local QuickfixName = {
      condition = function()
        return vim.bo.filetype == 'qf'
      end,
      init = function(self)
        self.qflist = vim.fn.getqflist({ winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
        self.loclist = vim.fn.getloclist(0, { winid = 0, title = 0, size = 0, nr = 0, idx = 0 })
        self.quickfix = self.qflist.winid ~= 0
      end,
      Space,
      {
        provider = function(self)
          return self.quickfix and 'Q' or self.loc_open and 'L'
        end,
        hl = 'Comment',
      },
      Space,
      {
        provider = function(self)
          return self.qflist.title or self.loclist.title
        end,
        hl = 'Title',
      },
      Space,
      {
        provider = function(self)
          local idx = self.quickfix and self.qflist.idx or self.loclist.idx
          local size = self.quickfix and self.qflist.size or self.loclist.size
          return string.format('[%s/%s]', idx, size)
        end,
        hl = 'Comment',
      },
      Space,
      {
        provider = function(self)
          local nr = self.quickfix and self.qflist.nr or self.loclist.nr
          local nrs = self.quickfix and vim.fn.getqflist({ nr = '$' }).nr
            or vim.fn.getloclist(0, { nr = '$' }).nr
          return string.format('(%s of %s)', nr, nrs)
        end,
        hl = 'Comment',
      },
    }

    local LirName = {
      condition = function()
        return vim.bo.filetype == 'lir'
      end,
      init = function(self)
        local dir = require('lir').get_context().dir
        self.dir = vim.fn.fnamemodify(dir, ':.:h')
        self.show_hidden_files = require('lir.config').values.show_hidden_files
      end,
      Space,
      {
        provider = function(self)
          return self.dir
        end,
        hl = 'Comment',
      },
      Space,
      {
        provider = function(self)
          return self.show_hidden_files and ' ' or ' '
        end,
        hl = function(self)
          return self.show_hidden_files and 'DiagnosticWarn' or 'NonText'
        end,
      },
    }

    local Spell = {
      condition = function()
        return vim.wo.spell
      end,
      provider = 'Spell',
    }

    local WinBars = {
      fallthrough = false,
      LirName,
      {
        condition = function()
          return conditions.buffer_matches({
            buftype = { 'nofile', 'prompt', 'terminal' },
            filetype = { '^git.*' },
          })
        end,
        init = function()
          vim.opt_local.winbar = nil
        end,
      },
      QuickfixName,
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
        return conditions.is_active() and 'WinBar' or 'WinBarNC'
      end,
    }

    local Tabpage = {
      provider = function(self)
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(-1, self.tabnr), ':~')
        local bufs = vim.fn.tabpagebuflist(self.tabnr)
        for _, buf in ipairs(bufs) do
          if vim.bo[buf].filetype == 'DiffviewFiles' then
            cwd = cwd .. ' ' .. 'DiffviewFiles'
            break
          end
          if vim.bo[buf].filetype == 'DiffviewFileHistory' then
            cwd = cwd .. ' ' .. 'DiffviewFileHistory'
            break
          end
        end
        if not conditions.width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        return '%' .. self.tabnr .. 'T' .. ' ' .. cwd .. ' '
      end,
      hl = function(self)
        return self.is_active and 'TabLineSel' or 'TabLine'
      end,
    }

    local TabPages = {
      utils.make_tablist(Tabpage),
    }

    local TabLine = { TabPages }

    local DisableStatusLine = {
      condition = function()
        return vim.o.laststatus == 0
      end,
      provider = function()
        return string.rep('─', vim.api.nvim_win_get_width(0))
      end,
      hl = 'WinSeparator',
    }

    local DefaultStatusLine = {
      ViMode,
      Space,
      Git,
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

    local StatusLines = {
      fallthrough = false,
      DisableStatusLine,
      DefaultStatusLine,
      hl = function()
        return conditions.is_active() and 'StatusLine' or 'StatusLineNC'
      end,
    }

    local StatusColumn = {
      {
        provider = "%4{v:virtnum ? '' : &nu ? (&rnu && v:relnum ? v:relnum : v:lnum) . ' ' : ''}",
      },
      { provider = '%s' },
    }

    heirline.setup({
      statusline = StatusLines,
      statuscolumn = StatusColumn,
      winbar = WinBars,
      tabline = TabLine,
      opts = {
        disable_winbar_cb = function(args)
          local buf = args.buf
          local buftype =
            vim.tbl_contains({ 'prompt', 'nofile', 'help' }, vim.bo[buf].buftype)
          local filetype =
            vim.tbl_contains({ 'gitcommit', 'fugitive', 'Trouble', 'packer' }, vim.bo[buf].filetype)
          return (buftype or filetype) and vim.bo.filetype ~= 'lir'
        end,
      },
    })
  end,
}
