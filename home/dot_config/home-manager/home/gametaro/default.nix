{...}: {
  imports = [
    ./browser.nix
    ./git.nix
    ./home.nix
    ./shell.nix
    ./desktop
    # ./wayland.nix
  ];
}
