{...}: {
  imports = [
    ./programs/vscode.nix
    ./programs/code-server.nix
    ./programs/nvim.nix
    ./programs/claude-code.nix
  ];

  flake.homeModules.development = {osConfig, lib, pkgs, ...}: lib.mkIf osConfig.custom.development.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.btop = {
      enable = true;
      package = pkgs.btop.override {cudaSupport = true;};
      settings = {
        show_gpu = true;
      };
    };

    home.packages = with pkgs; [
      lazydocker
      dive
      librealsense-gui
    ];
  };

  flake.nixosModules.development = {config, lib, pkgs, ...}: let
    gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
  in {
    options.custom.development.enable = lib.mkEnableOption "development environment";

    config = lib.mkIf config.custom.development.enable {
      custom.vscode.enable = true;
      custom.code-server.enable = true;
      custom.nvim.enable = true;
      custom.claude-code.enable = true;
      custom.tailscale.enable = true;

      virtualisation.docker.enable = true;
      hardware.nvidia-container-toolkit.enable = lib.mkDefault (config.hardware.nvidia.enabled or false);

      users.users.${config.custom.user.name}.extraGroups = ["docker"];

      environment.systemPackages = with pkgs; [
        glab
        gh
        gdk
        kubectl
        freelens-bin
        kubelogin-oidc
        openlens
        (peakperf.override {enableCuda = true;})
      ];

    };
  };
}
