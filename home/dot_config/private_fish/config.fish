set fish_greeting
set -gx EDITOR nvim
set -gx VISUAL nvim

fish_add_path ~/.local/bin

if test -d ~/.asdf
    source ~/.asdf/asdf.fish
    if not test -L ~/.config/fish/completions/asdf.fish
        mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    end
    set -q ASDF_CONFIG_FILE; or set -gx ASDF_CONFIG_FILE ~/.config/asdf/config
end

if command -q rg
    set -q RIPGREP_CONFIG_PATH; or set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/config
end

if status --is-interactive
    abbr -a -g mv mv -i
    abbr -a -g cp cp -i
    abbr -a -g rm rm -i
    abbr -a -g g git
    abbr -a -g v nvim
    abbr -a -g vim nvim
    abbr -a -g grep rg
    abbr -a -g cat bat
    abbr -a -g ccd chezmoi cd
    abbr -a -g cap chezmoi apply
    abbr -a -g ced chezmoi edit $argv
end

command -q starship; and starship init fish | source
