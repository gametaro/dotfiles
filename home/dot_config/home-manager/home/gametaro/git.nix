{pkgs, ...}: {
  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
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
        ls = "ls-files";
        ma = "merge --abort";
        mc = "merge --continue";
        ra = "restore .";
        rs = "restore --staged";
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
        pushy = "push --force-with-lease";
      };
      difftastic.enable = true;
      extraConfig = {
        branch.autoSetupRebase = "always";
        commit = {
          gpgSign = true;
          verbose = true;
        };
        diff.renames = "copy";
        fetch = {
          prune = true;
          writeCommitGraph = true;
        };
        gpg = {
          format = "ssh";
          "ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        };
        init.defaultBranch = "main";
        merge.conflictStyle = "zdiff3";
        mergetool.keepBackup = false;
        pull.rebase = true;
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
        status.showUntrackedFiles = "all";
        tag.gpgSign = true;
        user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKfA4i4/FZSyrYZRHPbnzQHRyMlGdJwPxKQRhFucf6h";
      };
    };
  };
}
