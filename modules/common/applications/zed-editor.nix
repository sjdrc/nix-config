{pkgs, ...}: {
  home-manager.users.sebastien = {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
      ];
      extraPackages = with pkgs; [
        direnv
        postgres-lsp
        cmake-language-server
        nixd
        nil
      ];
      installRemoteServer = true;
      userSettings = {
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
        assistant.enabled = false;
        lsp = {
          nixd.options.nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.(builtins.getEnv HOSTNAME).options";
          nixd.options.home-manager.expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.(builtins.getEnv HOSTNAME).options";
        };
        languages = {
          Nix = {
            language_servers = [
              "!nil"
              "nixd"
            ];
            formatter.external.command = "${pkgs.alejandra}/bin/alejandra";
          };
        };
      };
    };
  };
}
