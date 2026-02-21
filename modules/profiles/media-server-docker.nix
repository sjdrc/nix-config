{...}: let
  homeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.profiles.media-server-docker.enable = lib.mkEnableOption "Docker-based media server suite";

    config = lib.mkIf config.custom.profiles.media-server-docker.enable {
    };
  };
in {
  nixosModule = {
    config,
    lib,
    ...
  }: let
    cfg = config.custom.profiles.media-server-docker;

    puid = "1000";
    pgid = "1000";
    tz = config.time.timeZone;

    stateDir = "/data/.state/nixarr";
    mediaDir = "/data/media";
    networkName = "media-server";

    containerNames = ["sabnzbd" "jellyfin" "jellyseerr" "sonarr" "radarr" "prowlarr" "homarr"];

    # Common environment for linuxserver.io containers
    lsioEnv = {
      PUID = puid;
      PGID = pgid;
      TZ = tz;
    };

    # Systemd dependency overrides so all containers wait for the Docker network
    networkDeps = lib.listToAttrs (map (name: {
      name = "docker-${name}";
      value = {
        after = ["docker-network-media-server.service"];
        requires = ["docker-network-media-server.service"];
      };
    }) containerNames);
  in {
    options.custom.profiles.media-server-docker.enable = lib.mkEnableOption "Docker-based media server suite";

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !(config.custom.profiles.media-server.enable or false);
          message = "media-server and media-server-docker cannot be enabled simultaneously (port conflicts)";
        }
      ];

      virtualisation.oci-containers.backend = "docker";
      virtualisation.docker.enable = true;

      # Create Docker network via systemd oneshot
      systemd.services =
        networkDeps
        // {
          docker-network-media-server = {
            description = "Create Docker network for media server";
            after = ["docker.service" "docker.socket"];
            requires = ["docker.service"];
            wantedBy = ["multi-user.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              ${config.virtualisation.docker.package}/bin/docker network inspect ${networkName} >/dev/null 2>&1 || \
              ${config.virtualisation.docker.package}/bin/docker network create ${networkName}
            '';
            postStop = ''
              ${config.virtualisation.docker.package}/bin/docker network rm ${networkName} || true
            '';
          };
        };

      virtualisation.oci-containers.containers = {
        sabnzbd = {
          image = "lscr.io/linuxserver/sabnzbd:latest";
          environment = lsioEnv;
          volumes = [
            "${stateDir}/sabnzbd:/config"
            "${mediaDir}/usenet:/data/usenet"
          ];
          ports = ["8080:8080"];
          networks = [networkName];
        };

        jellyfin = {
          image = "lscr.io/linuxserver/jellyfin:latest";
          environment = lsioEnv;
          volumes = [
            "${stateDir}/jellyfin:/config"
            "${mediaDir}/library:/data/library:ro"
          ];
          ports = ["8096:8096"];
          networks = [networkName];
          devices = lib.optionals (config.hardware.nvidia-container-toolkit.enable or false) [
            "/dev/dri:/dev/dri"
          ];
          extraOptions = lib.optionals (config.hardware.nvidia-container-toolkit.enable or false) [
            "--runtime=nvidia"
            "--gpus=all"
          ];
        };

        jellyseerr = {
          image = "fallenbagel/jellyseerr:latest";
          environment = {
            TZ = tz;
          };
          volumes = [
            "${stateDir}/jellyseerr:/app/config"
          ];
          ports = ["5055:5055"];
          networks = [networkName];
        };

        sonarr = {
          image = "lscr.io/linuxserver/sonarr:latest";
          environment = lsioEnv;
          volumes = [
            "${stateDir}/sonarr:/config"
            "${mediaDir}:/data"
          ];
          ports = ["8989:8989"];
          networks = [networkName];
        };

        radarr = {
          image = "lscr.io/linuxserver/radarr:latest";
          environment = lsioEnv;
          volumes = [
            "${stateDir}/radarr:/config"
            "${mediaDir}:/data"
          ];
          ports = ["7878:7878"];
          networks = [networkName];
        };

        prowlarr = {
          image = "lscr.io/linuxserver/prowlarr:latest";
          environment = lsioEnv;
          volumes = [
            "${stateDir}/prowlarr:/config"
          ];
          ports = ["9696:9696"];
          networks = [networkName];
        };

        homarr = {
          image = "ghcr.io/homarr-dev/homarr:latest";
          environment = {
            TZ = tz;
          };
          volumes = [
            "${stateDir}/homarr:/appdata"
          ];
          ports = ["7575:7575"];
          networks = [networkName];
        };
      };

      # Create state and media directories
      systemd.tmpfiles.rules = [
        "d ${stateDir}/sabnzbd 0700 ${puid} ${pgid} -"
        "d ${stateDir}/jellyfin 0700 ${puid} ${pgid} -"
        "d ${stateDir}/jellyseerr 0700 ${puid} ${pgid} -"
        "d ${stateDir}/sonarr 0700 ${puid} ${pgid} -"
        "d ${stateDir}/radarr 0700 ${puid} ${pgid} -"
        "d ${stateDir}/prowlarr 0700 ${puid} ${pgid} -"
        "d ${stateDir}/homarr 0700 ${puid} ${pgid} -"
        "d ${mediaDir} 0775 root ${pgid} -"
        "d ${mediaDir}/library 0775 root ${pgid} -"
        "d ${mediaDir}/usenet 0775 ${puid} ${pgid} -"
      ];

      # Open firewall ports for LAN access
      networking.firewall.allowedTCPPorts = [
        8080 # sabnzbd
        8096 # jellyfin
        5055 # jellyseerr
        8989 # sonarr
        7878 # radarr
        9696 # prowlarr
        7575 # homarr
      ];
    };
  };

  inherit homeModule;
}
