{
  config,
  pkgs,
  ...
}: {
  home = {
    username = "gametaro";
    homeDirectory = "/home/gametaro";
    stateVersion = "23.11";

    packages = with pkgs; [
      curl
      fd
    ];

    file = {};

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "${config.home.sessionVariables.EDITOR}";
      SUDO_EDITOR = "${config.home.sessionVariables.EDITOR}";
      MANPAGER = "nvim +Man!";
    };

    shellAliases = {
      g = "git";
      v = "nvim";
    };
  };
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
    bash = {
      enable = true;
      enableVteIntegration = true;
      historyControl = ["erasedups" "ignoredups" "ignorespace"];
      # bashrcExtra = {};
      shellAliases = {
        ".." = "cd ..";
        grep = "grep --color=auto";
        ls = "ls --color=auto";
        l = "ls -CF";
        la = "ls -A";
        ll = "ls -alF";
      };
    };
    fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
      '';
      shellAbbrs = {
        v = "nvim";
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gau = "git add --update";
        gb = "git branch";
        gc = "git commit";
        gca = "git commit --amend";
        gcam = "git commit --amend --message";
        gcane = "git commit --amend --no-edit";
        gco = "git checkout";
        gd = "git diff";
        gdc = "git diff --cached";
        gf = "git fetch";
        gfa = "git fetch --all";
        gg = "git grep";
        ggg = "git grep-group";
        gl = "git log";
        glg = "git log --graph";
        gll = "git log-list";
        glo = "git log --oneline";
        glp = "git log --patch";
        gls = "git ls-files";
        gm = "git merge";
        gma = "git merge --abort";
        gmc = "git merge --continue";
        gp = "git pull";
        gpf = "git pull --ff-only";
        gpr = "git pull --rebase";
        grb = "git rebase";
        gs = "git status";
        gss = "git status --short";
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    readline = {
      enable = true;
      variables = {
        colored-completion-prefix = true;
        colored-stats = true;
        completion-ignore-case = true;
        completion-map-case = true;
        mark-modified-lines = true;
        visible-stats = true;
      };
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        prompt = "enabled";
        aliases = {
          co = "pr checkout";
          s = "status";
        };
      };
    };
    git = {
      enable = true;
      userName = "Kotaro Yamada";
      userEmail = "32237320+gametaro@users.noreply.github.com";
      signing = {
        key = null;
        signByDefault = true;
      };
      aliases = {
        a = "add";
        b = "branch";
        c = "commit";
        d = "diff";
        f = "fetch";
        g = "grep";
        l = "log";
        m = "merge";
        o = "checkout";
        p = "pull";
        s = "status";
        w = "whatchanged";

        aa = "add --all";
        au = "add --update";
        bm = "branch --merged";
        ca = "commit --amend";
        cam = "commit --amend --message";
        cane = "commit --amend --no-edit";
        co = "checkout";
        cm = "commit --message";
        cp = "cherry-pick";
        dc = "diff --cached";
        ds = "diff --staged";
        dw = "diff --word-diff";
        dd = "diff-deep";
        fa = "fetch --all";
        gg = "grep --break --heading --line-number --color";
        lg = "log --graph";
        lo = "log --oneline";
        lp = "log --patch";
        ll = "log-list";
        lll = "log-list-long";
        ls = "git ls-files";
        ma = "merge --abort";
        mc = "merge --continue";
        rb = "rebase";
        rba = "rebase --abort";
        rbc = "rebase --continue";
        rbs = "rebase --skip";
        rbi = "rebase --interactive";
        rl = "reflog";
        rr = "remote";
        ss = "status --short";

        uncommit = "reset --soft HEAD~1";
        unadd = "reset HEAD";
        discard = "checkout --";
        cleaner = "clean -dff";
        cleanest = "clean -dffx";
        pushy = "!git push --force-with-lease";
      };
      difftastic.enable = true;
      extraConfig = {
        init = {defaultBranch = "main";};
        branch = {autoSetupRebase = "always";};
        commit = {verbose = true;};
        diff = {renames = "copy";};
        fetch = {
          prune = true;
          writeCommitGraph = true;
        };
        merge = {conflictStyle = "zdiff3";};
        mergetool = {keepBackup = false;};
        pull = {rebase = true;};
        push = {
          autoSetupRemote = true;
          followTags = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          stat = true;
          updateRefs = true;
        };
        rerere = {
          autoUpdate = true;
          enabled = true;
        };
        status = {showUntrackedFiles = "all";};
      };
    };
    starship.enable = true;
    zoxide.enable = true;
  };
}
