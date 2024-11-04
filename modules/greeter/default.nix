{ lib, ... }:
{
  imports = [
    ./regreet.nix
    ./sddm.nix
    ./tuigreet.nix
  ];

  options = {
    greeter = lib.mkOption {
      description = "Display manager to use";
      type = with lib.types; nullOr (enum [ ]);
      default = "regreet";
    };
  };
}
