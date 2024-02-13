{config, ...}: let
  shellAliases = {
    g = "git";
    n = "nix";
    v = "nvim";
  };
  gitAliases = {
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
in {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        strict_env = true;
        warn_timeout = "10s";
      };
      stdlib = ''
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "${config.xdg.cacheHome}/direnv/layouts/$hash$path"
            )}"
        }
      '';
    };
    bash = {
      enable = true;
      enableVteIntegration = true;
      historyControl = ["erasedups" "ignoredups" "ignorespace"];
      shellAliases =
        gitAliases
        // {
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
      shellAbbrs = shellAliases // gitAliases;
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
  };
}
