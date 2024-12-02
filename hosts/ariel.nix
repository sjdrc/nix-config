{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Device config
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Australia/Melbourne";

  # Device options
  steam.enable = true;
  hardware.nvidia.open = true;
  #home-manager.users.sebastien.home.packages = with pkgs; [
  #  orca-slicer
  #];
  services.ollama.enable = true;
  services.nextjs-ollama-llm-ui.enable = true;
  services.ollama.acceleration = "cuda";
}
