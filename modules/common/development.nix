{
  config,
  pkgs,
  ...
}: {
  home-manager.users.sebastien = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.packages = with pkgs; [
      lazydocker
      dive
    ];
  };

  hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
  virtualisation.docker.enable = true;
  users.users.sebastien.extraGroups = ["docker"];
}
