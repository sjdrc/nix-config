{
  nixosModule = {
    lib,
    config,
    ...
  }: {
    options.custom.system.nixpkgs.enable =
      lib.mkEnableOption "nixpkgs configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.nixpkgs.enable {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowBroken = true;
    };
  };
}
