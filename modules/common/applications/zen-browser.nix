{
  inputs,
  pkgs,
  ...
}: let
  addons = pkgs.callPackage inputs.firefox-addons {};
in {
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };
  home-manager.users.sebastien = {
    imports = [inputs.zen-browser.homeModules.default];
    programs.zen-browser = {
      enable = true;
      profiles.sebastien = {
        profiles.default = {
          id = 0;
          settings = {
            "extensions.autoDisableScopes" = 0;
          };
          extensions = with addons; [
            ublock-origin
            sponsorblock
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
          containers = {
            Personal = {
              id = 0;
              color = "orange";
              icon = "chill";
            };
            Work = {
              id = 1;
              color = "blue";
              icon = "briefcase";
            };
          };
          containersForce = true;
        };
      };
    };
  };
}
