{...}: {
  flake.nixosModules.locale = {config, lib, ...}: {
    options.custom.locale.enable =
      lib.mkEnableOption "locale configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.locale.enable {
      i18n.defaultLocale = "en_AU.UTF-8";
      time.timeZone = lib.mkDefault "Australia/Melbourne";
    };
  };
}
