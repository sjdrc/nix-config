{
  ...
}: {
  flake.nixosModules.steam = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
    services.udev.packages = [pkgs.game-devices-udev-rules];
    hardware.uinput.enable = true;
  };
}
