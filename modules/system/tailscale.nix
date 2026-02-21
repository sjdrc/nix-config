{...}: {
  flake.nixosModules.tailscale = {
    lib,
    config,
    ...
  }: {
    options.custom.system.tailscale.enable =
      lib.mkEnableOption "Tailscale VPN";

    config = lib.mkIf config.custom.system.tailscale.enable {
      #services.tailscale.enable = true;

      # Trust the Tailscale interface so all tailnet traffic is allowed
      #networking.firewall.trustedInterfaces = ["tailscale0"];
    };
  };
}
