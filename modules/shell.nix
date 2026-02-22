flakeArgs @ {...}: {
  imports = [
    ./programs/bash.nix
    ./programs/tmux.nix
    ./programs/sshrc.nix
  ];

  flake.homeModules.shell = {pkgs, ...}: {
    programs = {
      fzf.enable = true;
      atuin = {
        enable = true;
        settings = {
          filter_mode = "global";
          search_mode = "prefix";
        };
      };
      htop.enable = true;
      starship.enable = true;
      eza = {
        enable = true;
        extraOptions = [
          "--long"
          "--all"
          "--binary"
          "--group-directories-first"
          "--header"
        ];
        git = true;
        icons = "auto";
      };
    };

    home.packages = with pkgs; [
      wget
      systemctl-tui
      lnav
      lazydocker
      dive
    ];
  };

  flake.nixosModules.shell = {config, lib, pkgs, ...}: {
    options.custom.shell.enable = lib.mkEnableOption "shell environment" // {default = true;};

    config = lib.mkIf config.custom.shell.enable {
      custom.bash.enable = true;
      custom.tmux.enable = true;
      custom.sshrc.enable = true;

      fonts.packages = with pkgs.nerd-fonts; [fira-code];
      users.defaultUserShell = pkgs.bash;

      environment.systemPackages = with pkgs; [
        systemctl-tui
        lnav
      ];

      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.shell];
    };
  };
}
