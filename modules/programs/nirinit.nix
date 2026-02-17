{inputs, ...}: {
  nixosModule = {
    pkgs,
    config,
    lib,
    ...
  }: let
    userName = config.custom.profiles.user.name;
    waitForNiri = pkgs.writeShellScript "wait-for-niri" ''
      for i in $(seq 1 50); do
        [ -S "$XDG_RUNTIME_DIR"/niri.*.sock ] && exit 0
        sleep 0.1
      done
      echo "timed out waiting for niri socket" >&2
      exit 1
    '';
  in {
    imports = [inputs.nirinit.nixosModules.nirinit];

    options.custom.programs.nirinit.enable = lib.mkEnableOption "nirinit session persistence";

    config = lib.mkIf config.custom.programs.nirinit.enable {
      services.nirinit = {
        enable = true;
        settings = {
          skip.apps = [];
          launch = {};
        };
      };

      # Fix nirinit service: add user PATH and wait for niri socket
      systemd.user.services.nirinit = {
        after = ["niri.service"];
        serviceConfig = {
          Environment = lib.mkForce [
            "PATH=/etc/profiles/per-user/${userName}/bin:/run/current-system/sw/bin"
          ];
          ExecStartPre = waitForNiri;
        };
      };
    };
  };
}
