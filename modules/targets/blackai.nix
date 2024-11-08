{pkgs, ...}: {
  # Enable tailscale VPN
  services.tailscale.enable = true;

  home-manager.users.sebastien = {
    home.packages = with pkgs; [
      slack
      google-chrome
      # Kubernetes tools
      kubectl
      kubelogin-oidc
      kubernetes-helm
      fluxcd
      openlens
      seabird
      stern # for @andrea-falco/lens-multi-pod-logs extension
      coder
      bruno
      vscode-fhs
      cilium-cli
      vultr-cli
      omnictl
      direnv
    ];
  };
}
