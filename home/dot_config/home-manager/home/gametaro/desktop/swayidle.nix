{config, ...}: {
  services.swayidle.enable = true;
  services.swayidle.timeouts = [
    {
      timeout = 300;
      command = "${config.programs.swaylock.package}/bin/swaylock --daemonize";
    }
  ];
}
