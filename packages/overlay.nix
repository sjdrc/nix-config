{inputs, ...}: let
  customOverlay = final: prev: {
    bambu-studio = final.callPackage ./bambu-studio {};
    orca-slicer = final.callPackage ./orca-slicer {};
    openlens = final.callPackage ./openlens {};
  };
in {
  flake.overlays.default = customOverlay;

  # NixOS module that applies overlays directly, avoiding inputs.self
  # which causes infinite recursion in flake-parts' module system.
  flake.nixosModules.overlays = {inputs, ...}: {
    nixpkgs.overlays = [
      customOverlay
      inputs.nix-vscode-extensions.overlays.default
    ];
  };
}
