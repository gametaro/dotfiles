set fish_greeting
set -gx EDITOR nvim
set -Ux EDITOR nvim
set -Ux VISUAL nvim

abbr v nvim
abbr g git

if test -d $HOME/.local/bin
  set PATH $HOME/.local/bin $PATH
end

source ~/.asdf/asdf.fish
if ! test -f $HOME/.config/fish/completions/asdf.fish
  mkdir -p $HOME/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
end

if command -s starship > /dev/null
  starship init fish | source
end
