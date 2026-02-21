{...}: {
  perSystem = {pkgs, system, ...}: {
    packages = pkgs.lib.optionalAttrs (system == "x86_64-linux") {
      orca-slicer = pkgs.callPackage ./orca-slicer {};
    };
  };
}
