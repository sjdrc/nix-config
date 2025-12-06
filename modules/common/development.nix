{
  config,
  pkgs,
  ...
}: {
  home-manager.users.sebastien = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home.packages = with pkgs; [
      lazydocker
      dive
      (pkgs.code-cursor.overrideAttrs (oldAttrs: {
        # We use postInstall to modify the product.json after it's unpacked
        postInstall =
          (oldAttrs.postInstall or "")
          + ''
            # sed command to inject the marketplace URL
            sed -i 's|"extensionsGallery": *null|"extensionsGallery": {"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery", "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index", "itemUrl": "https://marketplace.visualstudio.com/items"}|g' $out/lib/cursor/resources/app/product.json
          '';
      }))
    ];
  };

  hardware.nvidia-container-toolkit.enable = config.hardware.nvidia.enabled;
  virtualisation.docker.enable = true;
  users.users.sebastien.extraGroups = ["docker"];

  environment.systemPackages = [pkgs.glab];
}
