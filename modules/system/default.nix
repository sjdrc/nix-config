flakeArgs @ {...}: {
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

  flake.nixosModules.system = {...}: {
    imports = with flakeArgs.config.flake.nixosModules; [
      audio
      bluetooth
      boot
      disks
      locale
      networking
      nix
      nixpkgs
      platform
      stylix
      tailscale
    ];
  };
}
