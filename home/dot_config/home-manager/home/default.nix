{
  inputs,
  self,
  ...
}: {
  perSystem = {
    lib,
    pkgs,
    inputs',
    ...
  }: let
    mkUser = username: args:
      inputs.home-manager.lib.homeManagerConfiguration (lib.recursiveUpdate args {
        pkgs = args.pkgs or pkgs;

        modules =
          [
            ./${username}
            inputs.arkenfox.hmModules.arkenfox
            inputs.nix-index-database.hmModules.nix-index
            {
              _module.args.osConfig = {};
              programs.home-manager.enable = true;
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
          ]
          ++ (args.modules or []);

        extraSpecialArgs = {
          inherit inputs inputs' self;
        };
      });

    mapUsers = lib.mapAttrs mkUser;
  in {
    legacyPackages.homeConfigurations = mapUsers {
      gametaro = {};
    };
  };
}
