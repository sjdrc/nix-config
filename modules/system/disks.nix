{...}: {
  flake.nixosModules.disks = {
    lib,
    config,
    ...
  }: {
    options.custom.system.disks.enable =
      lib.mkEnableOption "disk configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.disks.enable {
      # Root filesystem
      # lsblk -o name,mountpoint,label,size,uuid
      # sudo cryptsetup config <disk> --label nixos-luks
      boot.initrd.luks.devices."nixos".device = "/dev/disk/by-label/nixos-luks";
      fileSystems = {
        "/" = {
          # sudo e2label <disk> nixos
          label = "nixos";
          fsType = "ext4";
          options = ["noatime" "nodiratime" "discard"];
        };
        "/boot" = {
          # sudo fatlabel <disk> boot
          label = "boot";
          fsType = "vfat";
          options = ["fmask=0022" "dmask=0022"];
        };
      };

      # Swap
      # sudo cryptsetup config <disk> --label swap-luks
      boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/swap-luks";
      swapDevices = [
        {
          label = "swap";
        }
      ];
    };
  };
}
