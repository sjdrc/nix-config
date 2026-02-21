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
          skip.apps = ["steam"];
          launch = {};
        };
      };

      # Fix nirinit service: add user PATH and wait for niri socket
      systemd.user.services.nirinit = {
        after = ["niri.service"];
        path = [
          "/etc/profiles/per-user/${userName}"
          "/run/current-system/sw"
        ];
        serviceConfig = {
          ExecStartPre = waitForNiri;
          ExecStart = let
            configFile = (pkgs.formats.toml {}).generate "nirinit.toml" config.services.nirinit.settings;
          in
            lib.mkForce "${lib.getExe config.services.nirinit.package} --config ${configFile} --save-interval 60";
          # Kill immediately on stop — nirinit's exit handler does a final
          # save_session, but by then niri is already dead so it saves an
          # empty session, clobbering the good periodic save.
          KillSignal = "SIGKILL";
        };
      };
    };
  };
}
