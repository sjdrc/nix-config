{
...
}: {
  flake = rec {
    nixosModules.development = {config, pkgs, ...}: {
      hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
      virtualisation.docker.enable = true;
      users.users.sebastien.extraGroups = ["docker"];
      environment.systemPackages = [pkgs.glab];

      home-manager.sharedModules = [homeModules.development];
    };

    homeModules.development = {pkgs, ...}: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      home.packages = with pkgs; [
        lazydocker
        dive
      ];
    };
  };
}
