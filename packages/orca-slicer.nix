{...}: {
  perSystem = {pkgs, ...}: {
    packages.orca-slicer = pkgs.callPackage ./orca-slicer {};
  };
}
