{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  steam.enable = true;
  #bambu-studio.enable = true;
  #orca-slicer.enable = true;
  arr.enable = true;

  environment.systemPackages = with pkgs; [
    bambu-studio
  ];

  #  services.gnome.gnome-keyring.enable = true;
  #  services.dbus.enable = true;
  #  programs.dconf.enable = true;
  #
  #  environment.systemPackages = with pkgs; [
  #    bambu-studio
  #    glib-networking # Required for TLS/SSL in the login window
  #    webkitgtk_4_1 # Required for the actual web rendering
  #  ];
  #
  #  xdg.mime.defaultApplications = {
  #    "x-scheme-handler/bambustudio" = ["bambu-studio.desktop"];
  #    "x-scheme-handler/bambustudiolink" = ["bambu-studio.desktop"];
  #  };
  #
  #  environment.sessionVariables = {
  #    # Tells the app to expect a callback from the browser
  #    BAMBU_STUDIO_APPIMAGE = "1";
  #  };
  #
  #  nixpkgs.overlays = [
  #    (final: prev: {
  #      bambu-studio = prev.bambu-studio.overrideAttrs (oldAttrs: {
  #        buildInputs = oldAttrs.buildInputs or [] ++ [pkgs.makeWrapper];
  #        postInstall =
  #          oldAttrs.postInstall or ""
  #          + ''
  #            wrapProgram $out/bin/bambu-studio \
  #               --set __GLX_VENDOR_LIBRARY_NAME mesa \
  #              --set __EGL_VENDOR_LIBRARY_FILENAMES "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json" \
  #              --set MESA_LOADER_DRIVER_OVERRIDE zink \
  #              --set GALLIUM_DRIVER zink \
  #              --set WEBKIT_DISABLE_DMABUF_RENDERER 1
  #          '';
  #      });
  #    })
  #  ];

  #environment.systemPackages = [pkgs.prismlauncher];
  networking.firewall.enable = false;
}
