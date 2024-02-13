{pkgs, ...}: {
  xdg.portal = {
    config.sway.default = ["wlr" "gtk"];
    extraPortals = with pkgs; [xdg-desktop-portal-wlr];
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
