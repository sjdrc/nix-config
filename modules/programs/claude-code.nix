{...}: {
  flake.homeModules.claude-code = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.custom.programs.claude-code.enable = lib.mkEnableOption "Claude Code";

    config = lib.mkIf config.custom.programs.claude-code.enable {
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
  };
}
