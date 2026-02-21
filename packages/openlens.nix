{...}: {
  perSystem = {pkgs, system, ...}: {
    packages = pkgs.lib.optionalAttrs (system == "x86_64-linux") {
      openlens = pkgs.callPackage ./openlens {};
    };
  };
}
