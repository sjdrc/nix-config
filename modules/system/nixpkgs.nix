{...}: {
  flake.nixosModules.nixpkgs = {config, lib, ...}: {
    options.custom.nixpkgs.enable =
      lib.mkEnableOption "nixpkgs configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.nixpkgs.enable {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowBroken = true;
    };
  };
}
