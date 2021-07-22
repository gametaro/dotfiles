set fish_greeting
set -gx EDITOR nvim
set -Ux EDITOR nvim
set -Ux VISUAL nvim

abbr v nvim
abbr g git

source ~/.asdf/asdf.fish
if ! test -d $HOME/.config/fish/completions
  mkdir -p $HOME/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
end

if command -s starship > /dev/null
  starship init fish | source
end
