{
  pkgs,
  inputs',
  ...
}: {
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "auto-allocate-uids"
        "cgroups"
        # "configurable-impure-env"
        "flakes"
        "nix-command"
      ];
      auto-optimise-store = true;
      max-jobs = "auto";
      warn-dirty = false;
    };
  };
  nixpkgs.config.allowUnfree = true;
  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      _1password
      _1password-gui
      cachix
      curl
      fd
      inputs'.neovim.packages.default
      nix-output-monitor
      wget
      xdg-utils
    ];

    sessionVariables = rec {
      EDITOR = "nvim";
      VISUAL = EDITOR;
      SUDO_EDITOR = EDITOR;
      MANPAGER = "nvim +Man!";
    };
  };
  programs = {
    ssh = {
      enable = true;
      forwardAgent = true;
      extraConfig = ''
        IdentityAgent ~/.1password/agent.sock
      '';
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob=!.git/*"
      ];
    };
    atuin.enable = true;
    jq.enable = true;
    less.enable = true;
    nix-index-database.comma.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    wofi.enable = true;
  };
  xdg.enable = true;
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 100;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };
}
