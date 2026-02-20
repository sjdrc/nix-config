{...}: let
  homeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.programs.code-server.enable =
      lib.mkEnableOption "code-server (VS Code in the browser)";

    # Symlink VS Code settings into code-server's data dir
    config = lib.mkIf config.custom.programs.code-server.enable {
      home.file.".local/share/code-server/User/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink
        "/home/${config.home.username}/.config/Code/User/settings.json";
    };
  };
in {
  nixosModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    user = config.custom.profiles.user.name;
  in {
    options.custom.programs.code-server.enable =
      lib.mkEnableOption "code-server (VS Code in the browser)";

    config = lib.mkIf config.custom.programs.code-server.enable {
      services.code-server = {
        enable = true;
        user = user;
        group = "users";
        extraGroups = ["docker"];
        host = "0.0.0.0";
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

  inherit homeModule;
}
