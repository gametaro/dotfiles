{pkgs, ...}: {
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc fcitx5-gtk libsForQt5.fcitx5-qt];
  };
}
