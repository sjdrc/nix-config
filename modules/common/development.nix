{config, ...}: {
  home-manager.users.sebastien = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
  virtualisation.docker.enable = true;
  users.users.sebastien.extraGroups = ["docker"];
}
