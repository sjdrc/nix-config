{
  pkgs,
  config,
  ...
}: {
  home-manager.users.sebastien = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
      ];
      extraPackages = with pkgs; [
        postgres-lsp
        cmake-language-server
        nixd
      ];
      installRemoteServer = true;
      userSettings = {
        agent.enabled = true;
        autosave = "on_focus_change";
        restore_on_startup = "last_session";
        auto_update = false;
        load_direnv = "shell_hook";
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        terminal = {
          copy_on_select = true;
        };
        vim_mode = true;
      };
    };
  };
}
