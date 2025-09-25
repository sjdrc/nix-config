{...}: {
  flake = rec {
    nixosModules.default = {config, pkgs, ...}: {
    };
    homeModules.default = {pkgs, ...}: {
    };
  };
}
