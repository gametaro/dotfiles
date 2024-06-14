{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./i18n.nix
    ./mako.nix
    ./qt.nix
    ./swayidle.nix
    ./swaylock.nix
    ./window-manager
  ];

  home = {
    packages = with pkgs; [
      wl-clipboard

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      font-awesome
    ];
  };

  xdg.portal.enable = true;
}
