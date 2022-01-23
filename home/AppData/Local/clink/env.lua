local home = os.getenv 'HOME'
os.setenv('XDG_CONFIG_HOME', string.format([[%s\.config]], home))
os.setenv('XDG_DATA_HOME', string.format([[%s\.local\share]], home))
os.setenv('XDG_CACHE_HOME', string.format([[%s\.cache]], home))

local config = os.getenv 'XDG_CONFIG_HOME'
os.setenv('STARSHIP_CONFIG', string.format([[%s\starship\starship.toml]], config))
os.setenv('RIPGREP_CONFIG_PATH', string.format([[%s\ripgrep\config]], config))

local path = os.getenv 'Path'
os.setenv('Path', string.format([[%s;%s\bin]], path, home))
