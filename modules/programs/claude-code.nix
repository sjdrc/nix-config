flakeArgs @ {...}: {
  flake.homeModules.claude-code = {pkgs, ...}: {
    programs.claude-code = {
      enable = true;
      settings = {
        permissions = {
          allow = [
            "WebFetch"
            "WebSearch"
          ];
        };
      };
      mcpServers = {
        nixos = {
          command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        };
      };
    };
  };

  flake.nixosModules.claude-code = {config, lib, ...}: {
    options.custom.claude-code.enable = lib.mkEnableOption "Claude Code";
    config = lib.mkIf config.custom.claude-code.enable {
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.claude-code];
    };
  };
}
