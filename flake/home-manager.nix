{ inputs, ... }: {
  flake = rec {
    nixosModules.home-manager = {config, pkgs, ...}: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };
      home-manager.backupFileExtension = "backup";

      home-manager.sharedModules = [homeModules.home-manager];
    };

    homeModules.home-manager = {pkgs, ...}: {
      # Allow home-manager to manage itself
      programs.home-manager.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "24.05";
      home.username = "sebastien";
      home.homeDirectory = "/home/sebastien";
    };
  };
}
