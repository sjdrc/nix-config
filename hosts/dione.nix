flakeArgs @ {inputs, ...}: {
  flake.nixosConfigurations.dione = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with flakeArgs.config.flake.nixosModules; [
      system user shell desktop development gaming media-server _3d-printing
      cpu-intel gpu-nvidia
      {
        imports = [
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        networking.hostName = "dione";
        nixpkgs.overlays = [
          inputs.self.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
        custom.desktop.enable = true;
        custom.development.enable = true;
        custom.gaming.enable = true;
        custom.media-server.enable = true;
        custom._3d-printing.enable = true;
        custom.cpu-intel.enable = true;
        custom.gpu-nvidia.enable = true;
      }
    ];
    specialArgs = {inherit inputs;};
  };
}
