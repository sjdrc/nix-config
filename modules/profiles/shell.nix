{...}: let
  homeModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.profiles.shell.enable = lib.mkEnableOption "shell environment" // {default = true;};

    config = lib.mkIf config.custom.profiles.shell.enable {
      # Enable custom terminal programs
      custom.programs.bash.enable = true;
      custom.programs.tmux.enable = true;
      custom.programs.sshrc.enable = true;

      # User-level shell programs
      programs = {
        fzf.enable = true;
        atuin.enable = true;
        htop.enable = true;
        starship.enable = true;
        eza = {
          enable = true;
          extraOptions = [
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
  };
in {
  nixosModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.profiles.shell.enable = lib.mkEnableOption "shell environment" // {default = true;};

    config = lib.mkIf config.custom.profiles.shell.enable {
      # System-level shell configuration
      fonts.packages = with pkgs.nerd-fonts; [fira-code];
      users.defaultUserShell = pkgs.bash;

      environment.systemPackages = with pkgs; [
        systemctl-tui
        lnav
      ];
    };
  };

  inherit homeModule;
}
