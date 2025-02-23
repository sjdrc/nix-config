{
  config,
  lib,
  ...
}: {
  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
      default = "sebastien";
    };
  };

  config = {
    users.users.${config.user} = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
    };

    home-manager.users.${config.user} = {
      home = {
        username = "${config.user}";
        homeDirectory = "/home/${config.user}";
      };

      xdg = {
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
}
