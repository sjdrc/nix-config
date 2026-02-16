{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    kubectl
    freelens-bin
    kubelogin-oidc
  ];
}
