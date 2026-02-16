{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixarr.nixosModules.default
  ];

  options = {
    arr.enable = lib.mkEnableOption "arr";
  };

  config =
    lib.mkIf config.arr.enable
    {
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
}
