{
  config,
  pkgs,
  ...
}: let
  gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in {
  home-manager.users.sebastien = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.packages = with pkgs; [
      lazydocker
      dive
      librealsense-gui
    ];
  };

  hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
  virtualisation.docker.enable = true;
  users.users.sebastien.extraGroups = ["docker"];

  environment.systemPackages = with pkgs; [
    glab
    gdk
  ];
}
