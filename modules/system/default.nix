{...}: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./disks.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./nixpkgs.nix
    ./platform.nix
    ./stylix.nix
    ./tailscale.nix
  ];

  # Children are auto-included via mkHost autowiring.
  flake.nixosModules.system = {...}: {};
}
