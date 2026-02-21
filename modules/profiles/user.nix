{inputs, config, ...}: let
  flakeConfig = config.flake;
  userHomeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.profiles.user.enable = lib.mkEnableOption "user profile" // {default = true;};

    config = lib.mkIf config.custom.profiles.user.enable {
      xdg = {
        enable = true;
        configFile."mimeapps.list".force = true;
        mimeApps.enable = true;

        # Set directories for application defaults
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
  };
in {
  flake.nixosModules.user = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.home-manager.nixosModules.home-manager];

    options.custom.profiles.user = {
      enable = lib.mkEnableOption "user profile" // {default = true;};
      name = lib.mkOption {
        type = lib.types.str;
        default = "sebastien";
        description = "Primary user name";
      };
    };

    config = lib.mkIf config.custom.profiles.user.enable {
      # Create system user
      users.users.${config.custom.profiles.user.name} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
        ];
      };

      # Setup home-manager
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {inherit inputs;};
        backupFileExtension = "backup";

        # Configure home-manager for this user
        users.${config.custom.profiles.user.name} = {
          imports = [
            userHomeModule
            flakeConfig.homeModules.default
          ];

          home = {
            username = config.custom.profiles.user.name;
            homeDirectory = "/home/${config.custom.profiles.user.name}";
            stateVersion = "24.05";
          };

          programs.home-manager.enable = true;
          systemd.user.startServices = "sd-switch";
        };
      };
    };
  };

  flake.homeModules.user = userHomeModule;
}
