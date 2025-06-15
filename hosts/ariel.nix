{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixarr.nixosModules.default
  ];

  nixarr = {
    enable = true;

    # Media server
    jellyfin.enable = true;

    # Management plugin
    jellyseerr.enable = true;

    # Subtitle search
    bazarr.enable = true;

    # Music manager
    lidarr.enable = true;

    # Indexer
    prowlarr.enable = true;

    # Movie manager
    radarr.enable = true;

    # eBook manager
    readarr.enable = true;

    # TV show manager
    sonarr.enable = true;
  };

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  # Device programs
  steam.enable = true;
  #services.ollama.enable = true;
  #services.ollama.acceleration = "cuda";
  #services.nextjs-ollama-llm-ui.enable = true;

  environment.systemPackages = with pkgs; [
    orca-slicer
  ];
}
