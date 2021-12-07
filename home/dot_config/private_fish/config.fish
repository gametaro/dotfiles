set fish_greeting
set -gx EDITOR nvim
set -Ux EDITOR nvim
set -Ux VISUAL nvim

abbr v nvim
abbr g git

if test -d $HOME/.local/bin
  set PATH $HOME/.local/bin $PATH
end

if test -d $HOME/.asdf
  source $HOME/.asdf/asdf.fish
  if ! test -L $HOME/.config/fish/completions/asdf.fish
    mkdir -p $HOME/.config/fish/completions; and ln -s $HOME/.asdf/completions/asdf.fish $HOME/.config/fish/completions
  end
  set ASDF_CONFIG_FILE $HOME/.config/asdf/config
end

if command -s rg > /dev/null
  set RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
end

if command -s starship > /dev/null
  starship init fish | source
end
