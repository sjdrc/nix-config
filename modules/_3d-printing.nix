{...}: {
  flake.nixosModules._3d-printing = {config, lib, pkgs, ...}: {
    options.custom._3d-printing.enable = lib.mkEnableOption "3D printing tools";

    config = lib.mkIf config.custom._3d-printing.enable {
      environment.systemPackages = with pkgs; [
        bambu-studio
      ];
    };
  };
}
