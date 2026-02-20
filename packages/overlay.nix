{...}: {
  flake.overlays.default = final: prev: {
    bambu-studio = final.callPackage ./bambu-studio {};
    orca-slicer = final.callPackage ./orca-slicer {};
    openlens = final.callPackage ./openlens {};
  };
}
