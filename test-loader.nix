{inputs, ...}: {
  imports = [
    (let
      imported = import ./modules/system/boot.nix;
      module = imported;
    in
      module.nixosModule)
  ];
}
