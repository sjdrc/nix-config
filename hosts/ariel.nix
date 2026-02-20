{inputs, config, ...}: {
  flake.nixosConfigurations.ariel = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.default
      {
        imports = [
          inputs.nixos-hardware.nixosModules.common-cpu-amd
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];

        networking.hostName = "ariel";

        # Hardware
        custom.hardware.cpu.amd.enable = true;
        custom.hardware.gpu.nvidia.enable = true;

        # Profiles
        custom.profiles.desktop.enable = true;
        custom.profiles.gaming.enable = true;
      }
      {
        nixpkgs.overlays = [
          inputs.self.overlays.default
          inputs.nix-vscode-extensions.overlays.default
        ];
      }
    ];
    specialArgs = {
      inherit inputs;
      lib = config.flake.lib;
    };
  };
}
