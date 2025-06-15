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
        lsp = let
          nixosConfig = ''
            (with builtins; "/etc/nixos" |> toString |> getFlake).nixosConfigurations."${config.networking.hostName}"
          '';
        in {
          nixd.options.nixos.expr = "${nixosConfig}.options";
          nixd.options.home-manager.expr = "${nixosConfig}.options.home-manager.users.type.getSubOptions []";
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
