{...}: {
  flake.homeModules.claude-code = {osConfig, lib, pkgs, ...}: lib.mkIf osConfig.custom.claude-code.enable {
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

  flake.nixosModules.claude-code = {lib, ...}: {
    options.custom.claude-code.enable = lib.mkEnableOption "Claude Code";
  };
}
