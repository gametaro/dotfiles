set -gx fish_greeting ''

if type -q nvim
    set -gx EDITOR (which nvim)
    set -gx VISUAL $EDITOR
    set -gx SUDO_EDITOR $EDITOR
    set -gx MANPAGER $EDITOR +Man!
end

fish_add_path -g ~/.local/bin

~/.local/share/rtx/bin/rtx activate fish | source

abbr v nvim

abbr cha chezmoi apply
abbr chu chezmoi update

abbr g git
abbr ga git add
abbr gaa git add --all
abbr gap git add --patch
abbr gassume git update-index --assume-unchanged
abbr gau git add --update
abbr gb git branch
abbr gbed git branch --edit-description
abbr gbm git branch --merged
abbr gbnm git branch --no-merged
abbr gbranches git branch -a
abbr gbv git branch --verbose
abbr gbvv git branch --verbose --verbose
abbr gc git commit
abbr gca git commit --amend
abbr gcam git commit --amend --message
abbr gcane git commit --amend --no-edit
abbr gci git commit --interactive
abbr gcleaner git clean -dff
abbr gcleanest git clean -dffx
abbr gclone-lean git clone --depth 1 --filter=combine:blob:none+tree:0 --no-checkout
abbr gcloner git clone --recursive
abbr gcm git commit --message
abbr gco git checkout
abbr gcong git checkout --no-guess
abbr gcp git cherry-pick
abbr gcpa git cherry-pick --abort
abbr gcpc git cherry-pick --continue
abbr gcpn git cherry-pick -n
abbr gcpnx git cherry-pick -n -x
abbr gcurrent-branch git rev-parse --abbrev-ref HEAD
abbr gcvs-e git cvsexportcommit -u -p
abbr gcvs-i git cvsimport -k -a
abbr gd git diff
abbr gdc git diff --cached
abbr gdd git diff-deep
abbr gdefault-branch git config init.defaultBranch
abbr gdiff-changes git diff --name-status -r
abbr gdiff-deep git diff --check --dirstat --find-copies --find-renames --histogram --color
abbr gdiff-staged git diff --cached
abbr gdiff-stat git diff --stat --ignore-space-change -r
abbr gdiscard git checkout --
abbr gds git diff --staged
abbr gdw git diff --word-diff
abbr gf git fetch
abbr gfa git fetch --all
abbr gfav git fetch --all --verbose
abbr gg git grep
abbr ggg git grep-group
abbr ggn git grep -n
abbr ggrep-ack git -c color.grep.linenumber=\"bold yellow\" -c color.grep.filename=\"bold green\" -c color.grep.match=\"reverse yellow\" grep --break --heading --line-number
abbr ggrep-group git grep --break --heading --line-number --color
abbr giniter git init-empty
abbr gl git log
abbr glast-tag git describe --tags --abbrev=0
abbr glfp git log --first-parent
abbr glg git log --graph
abbr gll git log-list
abbr glll git log-list-long
abbr glo git log --oneline
abbr glog-1-day git log --since=1-day-ago
abbr glog-1-hour git log --since=1-hour-ago
abbr glog-1-month git log --since=1-month-ago
abbr glog-1-week git log --since=1-week-ago
abbr glog-1-year git log --since=1-year-ago
abbr glog-date-last git log -1 --date-order --format=%cI
abbr glog-fetched git log --oneline HEAD..origin/main
abbr glog-fresh git log ORIG_HEAD.. --stat --no-merges
abbr glog-graph git log --graph --all --oneline --decorate
abbr glog-list-long git log --graph --topo-order --date=iso8601-strict --no-abbrev-commit --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn <%ce>]%Creset %Cblue%G?%Creset'
abbr glog-list git log --graph --topo-order --date=short --abbrev-commit --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset'
abbr glog-local git log --oneline origin..HEAD
abbr glog-refs git log --all --graph --decorate --oneline --simplify-by-decoration --no-merges
abbr glog-timeline git log --format='%h %an %ar - %s'
abbr glor git log --oneline --reverse
abbr glp git log --patch
abbr gls git ls-files
abbr glsd git ls-files --debug
abbr glsfn git ls-files --full-name
abbr glsio git ls-files --ignored --others --exclude-standard
abbr glto git log --topo-order
abbr gm git merge
abbr gma git merge --abort
abbr gmc git merge --continue
abbr gmncnf git merge --no-commit --no-ff
abbr gorphans git fsck --full
abbr goutbound git log @{upstream}..
abbr gp git pull
abbr gpf git pull --ff-only
abbr gpr git pull --rebase
abbr gprp git pull --rebase=preserve
abbr grb git rebase
abbr grba git rebase --abort
abbr grbc git rebase --continue
abbr grbi git rebase --interactive
abbr grbiu git rebase --interactive @{upstream}
abbr grbs git rebase --skip
abbr grefs-by-date git for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short) (objectname:short) %(contents:subject)'
abbr grepacker git repack -a -d -f --depth=300 --window=300 --window-memory=1g
abbr greset-commit-hard git reset --hard HEAD~1
abbr greset-commit git reset --soft HEAD~1
abbr grl git reflog
abbr grr git remote
abbr grrp git remote prune
abbr grrs git remote show
abbr grru git remote update
abbr grv git revert
abbr grvnc git revert --no-commit
abbr gs git status
abbr gsb git show-branch
abbr gserve git -c daemon.receivepack=true daemon --base-path=. --export-all --reuseaddr --verbose
abbr gsm git submodule
abbr gsma git submodule add
abbr gsmi git submodule init
abbr gsms git submodule sync
abbr gsmu git submodule update
abbr gsmui git submodule update --init
abbr gsmuir git submodule update --init --recursive
abbr gss git status --short
abbr gssb git status --short --branch
abbr gstashes git stash list
abbr gsvn-b git svn branch
abbr gsvn-c git svn dcommit
abbr gsvn-m git merge --squash
abbr gtags git tag -n1 --list
abbr gtop git rev-parse --show-toplevel
abbr gunadd git reset HEAD
abbr gunassume git update-index --no-assume-unchanged
abbr guncommit git reset --soft HEAD~1
abbr gundo-commit-hard git reset --hard HEAD~1
abbr gundo-commit git reset --soft HEAD~1
abbr gw git whatchanged
abbr gwhatis git show --no-patch --pretty='tformat:%h (%s, %ad)' --date=short
abbr gwho git shortlog --summary --numbered --no-merges
