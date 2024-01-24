{inputs, ...}: {
  perSystem = {
    inputs',
    pkgs,
    ...
  }: {
    legacyPackages.homeConfigurations.gametaro = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home.nix];
      # extraSpecialArgs = {};
    };
  };
}
