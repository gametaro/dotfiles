local lsp = require('feline.providers.lsp')
local vi_mode = require('feline.providers.vi_mode')
local git = require('feline.providers.git')

local colorscheme = require('ky.ui').colorscheme
local spec = require('nightfox.spec').load(colorscheme)
local palette = require('nightfox.palette').load(colorscheme)

local theme = {
  fg = spec.fg2,
  bg = spec.bg0,
  black = palette.black.base,
  blue = palette.blue.base,
  cyan = palette.cyan.base,
  green = palette.green.base,
  magenta = palette.magenta.base,
  orange = palette.orange.base,
  pink = palette.pink.base,
  red = palette.red.base,
  white = palette.white.dim,
  yellow = palette.yellow.dim,
}

local vi_mode_colors = {
  NORMAL = 'green',
  OP = 'green',
  INSERT = 'red',
  VISUAL = 'blue',
  LINES = 'blue',
  BLOCK = 'blue',
  REPLACE = 'magenta',
  ['V-REPLACE'] = 'magenta',
  ENTER = 'cyan',
  MORE = 'cyan',
  SELECT = 'orange',
  COMMAND = 'green',
  SHELL = 'green',
  TERM = 'green',
  NONE = 'yellow',
}

local vi_mode_symbol = {
  provider = '▊',
  hl = function()
    return {
      fg = vi_mode.get_mode_color(),
      bg = 'bg',
      style = 'bold',
    }
  end,
  right_sep = ' ',
}

local file_info = {
  provider = {
    name = 'file_info',
    opts = {
      type = 'unique',
      file_modified_icon = '',
    },
  },
  hl = {
    style = 'bold',
  },
  right_sep = {
    str = ' ',
    hl = {
      bg = 'bg',
      style = 'bold',
    },
  },
}

local git_branch = {
  provider = 'git_branch',
  enabled = function()
    return git.git_info_exists()
  end,
  hl = {
    fg = 'magenta',
    style = 'bold',
  },
}

local git_diff_added = {
  provider = 'git_diff_added',
  enabled = function()
    return git.git_info_exists()
  end,
  hl = {
    fg = spec.git.add,
    style = 'bold',
  },
}

local git_diff_changed = {
  provider = 'git_diff_changed',
  enabled = function()
    return git.git_info_exists()
  end,
  hl = {
    fg = spec.git.changed,
    style = 'bold',
  },
}

local git_diff_removed = {
  provider = 'git_diff_removed',
  enabled = function()
    return git.git_info_exists()
  end,
  hl = {
    fg = spec.git.removed,
    style = 'bold',
  },
}

local diagnostic_errors = {
  provider = 'diagnostic_errors',
  enabled = function()
    return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR)
  end,
  hl = {
    fg = spec.diag.error,
    style = 'bold',
  },
}

local diagnostic_warnings = {
  provider = 'diagnostic_warnings',
  enabled = function()
    return lsp.diagnostics_exist(vim.diagnostic.severity.WARN)
  end,
  hl = {
    fg = spec.diag.warn,
    style = 'bold',
  },
}

local diagnostic_hints = {
  provider = 'diagnostic_hints',
  enabled = function()
    return lsp.diagnostics_exist(vim.diagnostic.severity.HINT)
  end,
  hl = {
    fg = spec.diag.hint,
    style = 'bold',
  },
}

local diagnostic_info = {
  provider = 'diagnostic_info',
  enabled = function()
    return lsp.diagnostics_exist(vim.diagnostic.severity.INFO)
  end,
  hl = {
    fg = spec.diag.info,
    style = 'bold',
  },
}

local lsp_client_names = {
  provider = 'lsp_client_names',
  hl = {
    fg = 'yellow',
    style = 'bold',
  },
  right_sep = ' ',
}

local file_icon = {
  provider = function()
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local icon = require('nvim-web-devicons').get_icon(filename, extension)
    return icon or '?'
  end,
  hl = function()
    local val = {}
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local icon, name = require('nvim-web-devicons').get_icon(filename, extension)
    if icon ~= nil then
      val.fg = vim.fn.synIDattr(vim.fn.hlID(name), 'fg')
    else
      val.fg = 'fg'
    end
    val.style = 'bold'
    return val
  end,
  right_sep = ' ',
}

local file_type = {
  provider = 'file_type',
  hl = function()
    local filename = vim.fn.expand('%:t')
    local extension = vim.fn.expand('%:e')
    local icon, name = require('nvim-web-devicons').get_icon(filename, extension)
    return {
      fg = icon and vim.fn.synIDattr(vim.fn.hlID(name), 'fg') or 'fg',
      style = 'bold',
    }
  end,
  right_sep = ' ',
}

local file_size = {
  provider = 'file_size',
  enabled = function()
    return vim.fn.getfsize(vim.fn.expand('%:p')) > 0
  end,
  hl = {
    fg = 'blue',
    style = 'bold',
  },
  right_sep = ' ',
}

local file_format = {
  provider = function()
    local ff = vim.bo.fileformat:upper()
    return (ff == 'UNIX' and '')
      or (ff == 'MAC' and '')
      or (ff == 'WINDOWS' and '')
      or ''
  end,
  hl = {
    style = 'bold',
  },
  right_sep = ' ',
}

local file_encoding = {
  provider = 'file_encoding',
  hl = {
    style = 'bold',
  },
  right_sep = ' ',
}

local position = {
  provider = 'position',
  hl = {
    style = 'bold',
  },
  right_sep = ' ',
}

local line_percentage = {
  provider = 'line_percentage',
  hl = {
    style = 'bold',
  },
  right_sep = ' ',
}

local scroll_bar = {
  provider = 'scroll_bar',
  hl = {
    fg = 'yellow',
  },
}

local active = {
  {
    vi_mode_symbol,
    file_info,
    -- file_size,
    -- file_icon,
    -- file_type,
    diagnostic_errors,
    diagnostic_warnings,
    diagnostic_hints,
    diagnostic_info,
  },
  {
    git_branch,
    git_diff_added,
    git_diff_changed,
    git_diff_removed,
  },
  {
    lsp_client_names,
    file_format,
    file_encoding,
    -- position,
    -- line_percentage,
    scroll_bar,
  },
}

local inactive = {
  { file_info },
  { position, line_percentage, scroll_bar },
}

require('feline').setup {
  theme = theme,
  vi_mode_colors = vi_mode_colors,
  force_inactive = {
    filetypes = {
      '^lir$',
      '^packer$',
      '^Neogit',
      '^Telescope',
      '^qf$',
      '^help$',
    },
  },
  components = {
    active = active,
    inactive = inactive,
  },
}
