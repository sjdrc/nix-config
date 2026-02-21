flakeArgs @ {inputs, ...}: {
  flake.nixosConfigurations.pallas = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with flakeArgs.config.flake.nixosModules; [
      system user shell laptop
      gpd-pocket-3
      {
        imports = [
          inputs.nixos-hardware.nixosModules.gpd-pocket-3
        ];
        networking.hostName = "pallas";
        nixpkgs.overlays = [
          inputs.self.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
        custom.laptop.enable = true;
        custom.gpd-pocket-3.enable = true;
      }
    ];
    specialArgs = {inherit inputs;};
  };
}
