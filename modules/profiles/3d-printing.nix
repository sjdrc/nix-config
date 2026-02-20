{...}: {
  flake.nixosModules."3d-printing" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.profiles."3d-printing".enable = lib.mkEnableOption "3D printing tools";

    config = lib.mkIf config.custom.profiles."3d-printing".enable {
      # 3D printing applications
      environment.systemPackages = with pkgs; [
        bambu-studio
      ];
    };
  };

  flake.homeModules."3d-printing" = {
    config,
    lib,
    ...
  }: {
    options.custom.profiles."3d-printing".enable = lib.mkEnableOption "3D printing tools";

    config = lib.mkIf config.custom.profiles."3d-printing".enable {
      # 3D printing user tools can go here if needed
    };
  };
}
