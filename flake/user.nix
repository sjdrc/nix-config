{lib, ...}: {
  flake = {
    nixosModules.default = {config, ...}: {
      time.timeZone = "Australia/Melbourne";
      users.users.sebastien = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "video"
        ];
      };
    };
    homeModules.default = {config, ...}: {
      home = {
        username = "sebastien";
        homeDirectory = "/home/sebastien";
      };
      xdg = {
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
  };
}
