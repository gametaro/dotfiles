{
  perSystem = _: {
    pre-commit = {
      settings = {
        hooks = {
          alejandra.enable = true;
          nil.enable = true;
          statix.enable = true;
        };
      };
    };
  };
}
