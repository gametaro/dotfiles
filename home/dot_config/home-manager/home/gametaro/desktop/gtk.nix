{pkgs, ...}: {
  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-show-input-method-menu = 1;
    };
  };
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };
}
