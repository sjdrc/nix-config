{
  homeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.programs.tmux.enable = lib.mkEnableOption "tmux terminal multiplexer";

    config = lib.mkIf config.custom.programs.tmux.enable {
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
  };
}
