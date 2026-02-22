{...}: let
  packageDefs = {
    bambu-studio = ./bambu-studio.nix;
    orca-slicer = ./orca-slicer.nix;
    openlens = ./openlens.nix;
  };
in {
  flake.overlays.default = final: _prev:
    builtins.mapAttrs (_name: path: final.callPackage path {}) packageDefs;

  perSystem = {pkgs, ...}: {
    packages =
      builtins.mapAttrs (_name: path: pkgs.callPackage path {}) packageDefs;
  };
}
