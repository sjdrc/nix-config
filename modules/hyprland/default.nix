{inputs, ...}: {
  imports = [
    ./hyprland.nix
    ./launcher
    ./layouts
    ./plugins
    ./statusbar
    ./utilities
  ];

  #nixpkgs.overlays = [
  #  inputs.hyprland.overlays.default
  #  inputs.hypridle.overlays.default
  #  inputs.hyprlock.overlays.default
  #  inputs.hyprpaper.overlays.default
  #  (
  #    final: prev: let
  #      system = prev.stdenv.hostPlatform.system;
  #    in {
  #      hyprlandPlugins = {
  #        hy3 = inputs.hy3.packages.${system}.default;
  #        hypr-dynamic-cursors = inputs.hypr-dynamic-cursors.packages.${system}.default;
  #        hyprscroller = inputs.hyprscroller.packages.${system}.default;
  #      };
  #    }
  #  )
  #];
}
