{lib, inputs, config, ...}: {
  # Helper to create a NixOS host with all modules auto-included.
  # Hosts only need to set custom.*.enable for the features they want.
  options.mkHost = lib.mkOption {
    type = lib.types.raw;
    readOnly = true;
  };

  config.mkHost = {
    system ? "x86_64-linux",
    hostModule,
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        builtins.attrValues config.flake.nixosModules
        ++ [
          {
            nixpkgs.overlays = [
              inputs.self.overlays.default
              inputs.nix-vscode-extensions.overlays.default
            ];
            home-manager.sharedModules = builtins.attrValues config.flake.homeModules;
          }
          hostModule
        ];
      specialArgs = {inherit inputs;};
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
    ../modules/hardware/gpu-intel.nix
    ../modules/hardware/thinkpad-x1-nano.nix
    ../modules/hardware/gpd-pocket-3.nix
    ../modules/hardware/gpd-win-4.nix

    # Host definitions
    ./dione.nix
    ./ariel.nix
    ./pallas.nix
    ./hyperion.nix
  ];
}
