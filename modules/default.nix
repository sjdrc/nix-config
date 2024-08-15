{ lib, ... }:
{
  imports = [
    ./common
    ./graphical
    ./hardware
    ./terminal
  ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
      default = "sebastien";
    };
  };
}
