{
  pkgs,
  lib,
  config,
  ...
}: let
  desktopItem = "BambuStudio.desktop";
in {
  options = {
    bambu-studio.enable = lib.mkEnableOption "bambu-studio";
  };

  config = lib.mkIf config.bambu-studio.enable {
    environment.systemPackages = [
      pkgs.bambu-studio
    ];
    xdg.mime = {
      defaultApplications = {
        "x-scheme-handler/orcaslicer" = desktopItem;
        "x-scheme-handler/bambustudio" = desktopItem;
        "x-scheme-handler/bambustudiolink" = desktopItem;
        "x-scheme-handler/prusaslicer" = desktopItem;
      };
    };
  };
}
