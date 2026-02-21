{...}: {
  flake.nixosModules.tailscale = {config, lib, ...}: {
    options.custom.tailscale.enable =
      lib.mkEnableOption "Tailscale VPN";

    config = lib.mkIf config.custom.tailscale.enable {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = ["tailscale0"];
    };
  };
}
