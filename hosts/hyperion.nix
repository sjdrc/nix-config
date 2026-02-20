{inputs, config, ...}: {
  flake.nixosConfigurations.hyperion = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.default
      {
        imports = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
        ];

        networking.hostName = "hyperion";

        # Hardware
        custom.hardware.thinkpad-x1-nano.enable = true;

        # Profiles
        custom.profiles.laptop.enable = true;
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
