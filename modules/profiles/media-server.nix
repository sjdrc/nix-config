{inputs, ...}: {
  flake.nixosModules.media-server = {
    inputs,
    lib,
    config,
    ...
  }: {
    imports = [inputs.nixarr.nixosModules.default];

    options.custom.profiles.media-server.enable = lib.mkEnableOption "media server suite";

    config = lib.mkIf config.custom.profiles.media-server.enable {
      nixarr = {
        enable = true;

        # Downloader
        sabnzbd.enable = true;

        # Media server
        jellyfin.enable = true;
        jellyseerr.enable = true;

        # Media managers
        sonarr.enable = true;
        radarr.enable = true;

        # Index manager
        prowlarr.enable = true;

        # Settings unifier
        recyclarr = {
          enable = true;
          configuration = {
            sonarr = {
              series = {
                base_url = "http://localhost:8989";
                api_key = "!env_var SONARR_API_KEY";
                quality_definition = {
                  type = "series";
                };
                delete_old_custom_formats = true;
              };
            };
            radarr = {
              movies = {
                base_url = "http://localhost:7878";
                api_key = "!env_var RADARR_API_KEY";
                quality_definition = {
                  type = "movie";
                };
                delete_old_custom_formats = true;
              };
            };
          };
        };
      };
    };
  };

  flake.homeModules.media-server = {
    config,
    lib,
    ...
  }: {
    options.custom.profiles.media-server.enable = lib.mkEnableOption "media server suite";

    config = lib.mkIf config.custom.profiles.media-server.enable {
      # Media server user tools can go here if needed
    };
  };
}
