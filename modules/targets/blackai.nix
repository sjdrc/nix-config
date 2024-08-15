{ config, pkgs, ... }:
{
  # Enable tailscale VPN
  services.tailscale.enable = true;

  home-manager.users.${config.user} = {
    home.packages = with pkgs; [
      slack
      google-chrome
      # Kubernetes tools
      kubectl
      kubelogin-oidc
      kubernetes-helm
      openlens
      stern # for @andrea-falco/lens-multi-pod-logs extension
    ];

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
    };
  };
}
