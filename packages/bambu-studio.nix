{...}: {
  perSystem = {pkgs, ...}: {
    packages.bambu-studio = pkgs.callPackage ./bambu-studio {};
  };
}
