{...}: {
  perSystem = {pkgs, system, ...}: {
    packages = pkgs.lib.optionalAttrs (system == "x86_64-linux") {
      bambu-studio = pkgs.callPackage ./bambu-studio {};
    };
  };
}
