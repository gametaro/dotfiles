set fish_greeting

if command -q nvim
    set -gx EDITOR (which nvim)
    set -gx VISUAL (which nvim)
end

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

if command -q chezmoi
    if not test -e ~/.config/fish/completions/chezmoi.fish
        chezmoi completion fish --output ~/.config/fish/completions/chezmoi.fish
    end
end

if status --is-interactive
    abbr -a -g mv mv -i
    abbr -a -g cp cp -i
    abbr -a -g rm rm -i
    abbr -a -g g git
    abbr -a -g v nvim
    abbr -a -g vi nvim
    abbr -a -g vim nvim
    abbr -a -g grep rg
    abbr -a -g cat bat
    abbr -a -g ch chezmoi
    abbr -a -g chc chezmoi cd
    abbr -a -g cha chezmoi apply
    abbr -a -g che chezmoi edit $argv
    abbr -a -g do docker
    abbr -a -g dor docker run
    abbr -a -g dob docker build
    abbr -a -g dop docker ps
    abbr -a -g dol docker logs
    abbr -a -g dol docker images
end

if command -q starship
    set -q STARSHIP_CONFIG; or set -gx STARSHIP_CONFIG ~/.config/starship/starship.toml
    starship init fish | source
end

set -x GPG_TTY (tty)
