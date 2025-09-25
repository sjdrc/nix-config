{
  inputs,
  lib,
  pkgs,
  ...
}: {
  flake.nixosModules.nixarr = {...}: {
    imports = [
      inputs.nixarr.nixosModules.default
    ];

    nixarr = {
      enable = true;
      # Media server
      jellyfin.enable = true;
      # Management plugin
      jellyseerr.enable = true;
      # Music manager
      lidarr.enable = true;
      # Indexer
      prowlarr.enable = true;
      # Movie manager
      radarr.enable = true;
      # eBook manager
      readarr.enable = true;
      # TV show manager
      sonarr.enable = true;
      # Usenet downloader
      sabnzbd.enable = true;
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
    # Runtime
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
    virtualisation.oci-containers.backend = "docker";

    # Containers
    virtualisation.oci-containers.containers."homarr" = {
      image = "ghcr.io/ajnart/homarr:latest";
      volumes = [
        "/home/user/docker/homarr/config/:/app/data/configs:rw"
        "/home/user/docker/homarr/data/:/data:rw"
        "/home/user/docker/homarr/icons/:/app/public/icons:rw"
        "/var/run/docker.sock:/var/run/docker.sock:rw"
      ];
      ports = [
        "7575:7575/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=homarr"
        "--network=homarr_default"
      ];
    };
    systemd.services."docker-homarr" = {
      serviceConfig = {
        Restart = lib.mkOverride 500 "always";
        RestartMaxDelaySec = lib.mkOverride 500 "1m";
        RestartSec = lib.mkOverride 500 "100ms";
        RestartSteps = lib.mkOverride 500 9;
      };
      after = [
        "docker-network-homarr_default.service"
      ];
      requires = [
        "docker-network-homarr_default.service"
      ];
      partOf = [
        "docker-compose-homarr-root.target"
      ];
      wantedBy = [
        "docker-compose-homarr-root.target"
      ];
    };

    # Networks
    systemd.services."docker-network-homarr_default" = {
      path = [pkgs.docker];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.docker}/bin/docker network rm -f homarr_default";
      };
      script = ''
        docker network inspect homarr_default || docker network create homarr_default
      '';
      partOf = ["docker-compose-homarr-root.target"];
      wantedBy = ["docker-compose-homarr-root.target"];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."docker-compose-homarr-root" = {
      wantedBy = ["multi-user.target"];
    };
  };
}
