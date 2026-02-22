{...}: {
  flake.homeModules.code-server = {osConfig, lib, config, ...}: lib.mkIf osConfig.custom.code-server.enable {
    # Symlink VS Code settings into code-server's data dir
    home.file.".local/share/code-server/User/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink
      "/home/${config.home.username}/.config/Code/User/settings.json";
  };

  flake.nixosModules.code-server = {config, lib, pkgs, ...}: let
    user = config.custom.user.name;
  in {
    options.custom.code-server.enable =
      lib.mkEnableOption "code-server (VS Code in the browser)";

    config = lib.mkIf config.custom.code-server.enable {
      services.code-server = {
        enable = true;
        user = user;
        group = "users";
        extraGroups = ["docker"];
        host = "127.0.0.1";
        port = 4444;
        auth = "none";
        disableTelemetry = true;
        disableUpdateCheck = true;

        # Reuse extensions managed by home-manager's programs.vscode
        extensionsDir = "/home/${user}/.vscode/extensions";

        extraPackages = with pkgs; [
          nixd
          alejandra
          git
        ];

        extraArguments = [
          "--disable-getting-started-override"
        ];
      };
    };
  };
}
