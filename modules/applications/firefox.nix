{
  inputs,
  pkgs,
  ...
}: let
  addons = pkgs.callPackage inputs.firefox-addons {};
in {
  environment.sessionVariables = {
    # Force wayland for firefox
    MOZ_ENABLE_WAYLAND = "1";
  };
  home-manager.users.sebastien = {
    programs.firefox = {
      enable = true;
      profiles.sebastien = {
        settings = {
          "extensions.autoDisableScopes" = 0;
        };
        extensions = with addons; [
          ublock-origin
          sponsorblock
          bitwarden
          behind-the-overlay-revival
          #bypass-paywalls-clean
          consent-o-matic
          decentraleyes
          dark-mode-website-switcher
          gaoptout
          #floccus
          multi-account-containers
          no-pdf-download
          old-reddit-redirect
          re-enable-right-click
          terms-of-service-didnt-read
          faststream
          localcdn
          linkwarden
        ];
      };
    };
  };
}
