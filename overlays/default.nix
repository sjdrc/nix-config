{inputs, ...}: {
  nixpkgs.overlays = [
    #inputs.hyprland.overlays.default
    #inputs.hypridle.overlays.default
    #inputs.hyprlock.overlays.default
    #inputs.hyprpaper.overlays.default

    (
      final: prev: let
        system = prev.stdenv.hostPlatform.system;
      in {
        #hyprlandPlugins = {
        #  hy3 = inputs.hy3.packages.${system}.default;
        #  hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${system}.default;
        #  hyprscroller = inputs.hyprscroller.packages.${system}.default;
        #};
        openlens = inputs.nixpkgs-stable.legacyPackages.${system}.openlens;
        bambu-studio = inputs.nixpkgs-master.legacyPackages.${system}.bambu-studio;
        orca-slicer = inputs.nixpkgs-master.legacyPackages.${system}.orca-slicer;
      }
    )

    (final: prev: import ../pkgs {pkgs = final;})
  ];
}
