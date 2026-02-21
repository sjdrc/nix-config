flakeArgs @ {inputs, ...}: {
  flake.homeModules.user = {...}: {
    xdg = {
      enable = true;
      configFile."mimeapps.list".force = true;
      mimeApps.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        music = "$HOME/media/music";
        pictures = "$HOME/media/images";
        videos = "$HOME/media/videos";
        desktop = "$HOME/other/desktop";
        publicShare = "$HOME/other/public";
        templates = "$HOME/other/templates";
      };
    };

    programs.git.enable = true;
  };

  flake.nixosModules.user = {config, lib, ...}: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    options.custom.user = {
      enable = lib.mkEnableOption "user profile" // {default = true;};
      name = lib.mkOption {
        type = lib.types.str;
        default = "sebastien";
        description = "Primary user name";
      };
    };

    config = lib.mkIf config.custom.user.enable {
      users.users.${config.custom.user.name} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
        ];
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs;};
        backupFileExtension = "backup";

        sharedModules = [flakeArgs.config.flake.homeModules.user];

        users.${config.custom.user.name} = {
          home = {
            username = config.custom.user.name;
            homeDirectory = "/home/${config.custom.user.name}";
            stateVersion = "24.05";
          };

          programs.home-manager.enable = true;
          systemd.user.startServices = "sd-switch";
        };
      };
    };
  };
}
