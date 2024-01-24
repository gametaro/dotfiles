{
  perSystem = {
    config,
    inputs',
    ...
  }: {
    packages = {
      inherit (inputs'.neovim.packages) nvim;
      default = config.packages.nvim;
    };
  };
}
