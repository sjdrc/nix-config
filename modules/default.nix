{ inputs, ... }:
{
  imports = [
    ./common
    ./hardware
    ./users
    ./targets/graphical.nix
    ./targets/terminal.nix
  ];

  options = {
    user = inputs.nixpkgs.lib.mkOption {
      type = inputs.nixpkgs.lib.types.str;
      description = "Primary user of the system";
    };
  };
}
