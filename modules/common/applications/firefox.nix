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
    programs.firefox = {
      enable = true;
      policies = {
        AppAutoUpdate = false;
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        PasswordManagerEnabled = false;
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings."*".installation_mode = "force_installed";
        ExtensionSettings."*".updates_disabled = true;
      };
      profiles.sebastien = {
        id = 0;
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.download.start_downloads_in_tmp_dir" = true;
          "cookiebanners.service.mode" = 2;
          "cookiebanners.service.mode.privateBrowsing" = 2;
          "browser.fullscreen.autohide" = false;
          "extensions.autoDisableScopes" = 0;
          # Reduce File IO / SSD abuse
          # Otherwise, Zen bombards the HD with writes. Not so nice for SSDs.
          # This forces it to write every 30 minutes, rather than 15 seconds.
          "browser.sessionstore.interval" = "1800000";
          "sidebar.verticalTabs" = true;
        };
        extensions = {
          force = true;
          packages = with addons; [
            ublock-origin
            sponsorblock
            behind-the-overlay-revival
            consent-o-matic
            decentraleyes
            dark-mode-website-switcher
            gaoptout
            multi-account-containers
            no-pdf-download
            old-reddit-redirect
            terms-of-service-didnt-read
            faststream
            localcdn
            unpaywall
            onepassword-password-manager
          ];
          settings = {
            "uBlock0@raymondhill.net" = {
              # Home-manager skip collision check
              force = true;
              settings = {
                selectedFilterLists = [
                  "easylist"
                  "easylist-annoyances"
                  "easylist-chat"
                  "easylist-newsletters"
                  "easylist-notifications"
                  "ublock-annoyances"
                  "ublock-badware"
                  "ublock-cookies-easylist"
                  "ublock-filters"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-unbreak"
                ];
              };
            };
          };
        };
        containers = {
          Personal = {
            id = 1;
            color = "orange";
            icon = "chill";
          };
          Work = {
            id = 2;
            color = "blue";
            icon = "briefcase";
          };
        };
        containersForce = true;
      };
    };
  };
}
