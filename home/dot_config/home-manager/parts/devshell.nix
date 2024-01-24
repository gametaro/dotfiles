{
  perSystem = {pkgs, ...}: {
    devshells.default = {
      packages = with pkgs; [
        alejandra
        nil
        statix
      ];
    };
  };
}
