{...}: {
  flake.overlays.default = final: prev:
    final.lib.optionalAttrs (final.stdenv.hostPlatform.system == "x86_64-linux") {
      bambu-studio = final.callPackage ./bambu-studio {};
      orca-slicer = final.callPackage ./orca-slicer {};
      openlens = final.callPackage ./openlens {};
    };
}
