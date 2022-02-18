set fish_greeting

if test -d ~/.asdf
    if not test -L ~/.config/fish/completions/asdf.fish
        mkdir -p ~/.config/fish/completions; and ln -s ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    end
end

if command -q direnv
    direnv hook fish | source
end

if command -q chezmoi
    if not test -e ~/.config/fish/completions/chezmoi.fish
        chezmoi completion fish --output ~/.config/fish/completions/chezmoi.fish
    end
end

if command -q gh
    if not test -e ~/.config/fish/completions/gh.fish
        gh completion --shell fish >~/.config/fish/completions/gh.fish
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
    abbr -a -g dor docker run
    abbr -a -g dob docker build
    abbr -a -g dop docker ps
    abbr -a -g dol docker logs
    abbr -a -g dol docker images
    abbr -a -g n npm
    abbr -a -g ns npm start
end

if command -q zoxide
    zoxide init fish | source
end

if command -q starship
    starship init fish | source
end

set -x GPG_TTY (tty)
