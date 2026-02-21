{...}: {
  flake.nixosModules.locale = {
    lib,
    config,
    ...
  }: {
    options.custom.system.locale.enable =
      lib.mkEnableOption "locale configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.locale.enable {
      # Localisation
      i18n.defaultLocale = "en_AU.UTF-8";

      # Default timezone (can be overridden per-host)
      time.timeZone = lib.mkDefault "Australia/Melbourne";
    };
  };
}
