{...}: let
  homeModule = {
    lib,
    pkgs,
    osConfig,
    ...
  }: {
    config = lib.mkIf osConfig.custom.profiles.development.enable {
      # Custom programs
      custom.programs.vscode.enable = true;
      custom.programs.nvim.enable = true;

      custom.programs.claude-code.enable = true;

      # User-level development tools
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      home.packages = with pkgs; [
        lazydocker
        dive
        librealsense-gui
      ];
    };
  };
in {
  nixosModule = {
    config,
    lib,
    pkgs,
    ...
  }: let
    gdk = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);
  in {
    options.custom.profiles.development.enable = lib.mkEnableOption "development environment";

    config = lib.mkIf config.custom.profiles.development.enable {
      # System-level development setup
      virtualisation.docker.enable = true;
      hardware.nvidia-container-toolkit.enable = lib.mkDefault (config.hardware.nvidia.enabled or false);

      # Add user to docker group
      users.users.${config.custom.profiles.user.name}.extraGroups = ["docker"];

      environment.systemPackages = with pkgs; [
        glab
        gh
        gdk
        kubectl
        freelens-bin
        kubelogin-oidc
        openlens
      ];
    };
  };

  inherit homeModule;
}
