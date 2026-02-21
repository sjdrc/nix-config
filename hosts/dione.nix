{inputs, config, ...}: {
  flake.nixosConfigurations.dione = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.default
      {
        imports = [
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        ];

        networking.hostName = "dione";

        # Hardware
        custom.hardware.cpu.intel.enable = true;
        custom.hardware.gpu.nvidia.enable = true;

        # Data SSD
        # sudo e2label <disk> data
        #fileSystems."/data" = {
        #  label = "data";
        #  fsType = "ext4";
        #  options = ["noatime" "nodiratime" "discard"];
        #};

        # Profiles
        custom.profiles.desktop.enable = true;
        custom.profiles.development.enable = true;
        custom.profiles.gaming.enable = true;
        custom.profiles.media-server.enable = true;
        custom.profiles."3d-printing".enable = true;
      }
    ];
    specialArgs = {
      inherit inputs;
      lib = config.flake.lib;
    };
  };
}
