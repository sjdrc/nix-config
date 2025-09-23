{
  lib,
  pkgs,
  ...
}: {
  imports = lib.custom.scanPaths ./.;

  config = {
    environment.systemPackages = with pkgs; [
      mpv
    ];
  };
}
