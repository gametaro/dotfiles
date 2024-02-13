{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      wl-clipboard

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      font-awesome
      fira-code
      fira-code-symbols
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];
    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 20;
    };
  };
  fonts.fontconfig.enable = true;
  xdg = {
    portal = {
      enable = true;
      config.common.default = "gtk";
      config.sway.default = ["wlr" "gtk"];
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
  wayland = {
    windowManager = {
      sway = {
        enable = true;
        config = {
          input = {
            "*" = {
              repeat_delay = "250";
              repeat_rate = "50";
            };
          };
          menu = "killall -q -e wofi || wofi --show drun";
          startup = [{command = "exec mako";}];
        };
        swaynag.enable = true;
        systemd.enable = true;
        wrapperFeatures = {
          base = true;
          gtk = true;
        };
      };
    };
  };
}
