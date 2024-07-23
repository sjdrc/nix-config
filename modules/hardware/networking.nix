{ ... }:
{
  # Networking
  networking.networkmanager.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable tailscale VPN
  services.tailscale.enable = true;
}
