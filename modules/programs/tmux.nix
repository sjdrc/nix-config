flakeArgs @ {...}: {
  flake.homeModules.tmux = {...}: {
    programs.tmux = {
      enable = true;
      clock24 = true;
      focusEvents = true;
      historyLimit = 10000;
      mouse = true;
      newSession = true;
      extraConfig = ''
        bind-key e set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
      '';
    };
    programs.fzf.tmux.enableShellIntegration = true;
  };

  flake.nixosModules.tmux = {config, lib, ...}: {
    options.custom.tmux.enable = lib.mkEnableOption "tmux terminal multiplexer";
    config = lib.mkIf config.custom.tmux.enable {
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.tmux];
    };
  };
}
