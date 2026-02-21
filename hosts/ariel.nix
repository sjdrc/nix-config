flakeArgs @ {inputs, ...}: {
  flake.nixosConfigurations.ariel = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with flakeArgs.config.flake.nixosModules; [
      system user shell desktop gaming
      cpu-amd gpu-nvidia
      {
        imports = [
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];
        networking.hostName = "ariel";
        nixpkgs.overlays = [
          inputs.self.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
        custom.desktop.enable = true;
        custom.gaming.enable = true;
        custom.cpu-amd.enable = true;
        custom.gpu-nvidia.enable = true;
      }
    ];
    specialArgs = {inherit inputs;};
  };
}
