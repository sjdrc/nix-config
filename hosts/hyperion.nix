{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # Device hardware
  services.fprintd.enable = true;

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";
}
