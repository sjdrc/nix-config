{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (lib.mkAliasOptionModule
      [
        "hmConfig"
      ]
      [
        "home-manager"
        "users"
        "${config.user}"
      ]
    )
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit inputs;
  };
  home-manager.backupFileExtension = "backup";

  hmConfig = {
    # Allow home-manager to manage itself
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
  };
}
