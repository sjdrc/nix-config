{
  inputs,
  lib,
  pkgs,
  ...
}: let
in {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        # When using disko-install, we will overwrite this value from the commandline
        type = "disk";
        device = "/dev/disk/by-id/some-disk-id";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults" "umask=0077"];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings = {
                  allowDiscards = true;
                  bypassWorkqueues = true;
                };
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  subvolumes = let
                    commonMountOptions = [
                      "noatime"
                      "discard=async"
                    ];
                  in {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = commonMountOptions ++ ["compress=zstd:1" "autodefrag"];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = commonMountOptions ++ ["compress=zstd:1" "autodefrag"];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions =
                        commonMountOptions
                        ++ [
                          "compress=zstd:3"
                          "nodatacow"
                        ];
                    };
                    "@var" = {
                      mountpoint = "/var";
                      mountOptions = commonMountOptions ++ ["compress=zstd:1" "autodefrag"];
                    };

                    "@swap" = {
                      mountpoint = "/swap";
                      mountOptions =
                        commonMountOptions
                        ++ [
                          "nodatacow"
                          "nocompress"
                        ];
                    };
                    "@snapshots" = {
                      mountpoint = "/.snapshots";
                      mountOptions = commonMountOptions;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/" "/home" "/nix" "/var"];
  };

  systemd.services.btrfs-balance = {
    description = "Balance BTRFS filesystem";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=50 -musage=50 /";
    };
  };

  systemd.timers.btrfs-balance = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}
