{inputs, ...}: {
  nixosModule = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.nirinit.nixosModules.nirinit];

    options.custom.programs.nirinit.enable = lib.mkEnableOption "nirinit session persistence";

    config = lib.mkIf config.custom.programs.nirinit.enable {
      services.nirinit = {
        enable = true;
        settings = {
          skip.apps = [];
          launch = {};
        };
      };
    };
  };
}
