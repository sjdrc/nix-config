{inputs, config, ...}: {
  flake.nixosConfigurations.pallas = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.default
      {
        imports = [
          inputs.nixos-hardware.nixosModules.gpd-pocket-3
        ];

        networking.hostName = "pallas";

        # Hardware
        custom.hardware.gpd-pocket-3.enable = true;

        # Profiles
        custom.profiles.laptop.enable = true;
      }
    ];
    specialArgs = {
      inherit inputs;
      lib = config.flake.lib;
    };
  };
}
