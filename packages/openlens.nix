{...}: {
  perSystem = {pkgs, ...}: {
    packages.openlens = pkgs.callPackage ./openlens {};
  };
}
