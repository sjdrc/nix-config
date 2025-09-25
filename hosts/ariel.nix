{self, inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    "${inputs.nixos-hardware}/common/gpu/nvidia/ampere"
    #self.nixosModules.orca-slicer
    #self.nixosModules.steam
    #self.nixosModules.nixarr
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
}
