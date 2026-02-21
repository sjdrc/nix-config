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

        # Data SSD
        # sudo e2label <disk> data
        fileSystems."/data" = {
          label = "data";
          fsType = "ext4";
          options = ["noatime" "nodiratime" "discard"];
        };

        # Intel AC 9560: v46 firmware crashes (NMI_INTERRUPT_UMAC_FATAL) under network
        # load, but older versions (v43/v38/v34) don't support this hardware revision.
        # Disable 802.11n TX aggregation to reduce firmware stress.
        boot.extraModprobeConfig = "options iwlwifi 11n_disable=8";
      }
    ];
    specialArgs = {inherit inputs;};
  };
}
