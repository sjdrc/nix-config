{lib, ...}: {
  # flake-parts declares flake.nixosModules but not flake.homeModules,
  # so we declare it here to allow multiple modules to merge their homeModules.
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
  };

  imports = [
    # Module tree (composition modules import their children)
    ../modules/system
    ../modules/user.nix
    ../modules/shell.nix
    ../modules/desktop.nix
    ../modules/development.nix
    ../modules/laptop.nix
    ../modules/gaming.nix
    ../modules/media-server.nix
    ../modules/media-server-docker.nix
    ../modules/_3d-printing.nix

    # Hardware modules (standalone, not children of composition modules)
    ../modules/hardware/cpu-intel.nix
    ../modules/hardware/cpu-amd.nix
    ../modules/hardware/gpu-nvidia.nix
    ../modules/hardware/thinkpad-x1-nano.nix
    ../modules/hardware/gpd-pocket-3.nix

    # Host definitions
    ./dione.nix
    ./ariel.nix
    ./pallas.nix
    ./hyperion.nix
  ];
}
