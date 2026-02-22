{inputs, ...}: {
  flake.homeModules.zen-browser = {
    osConfig,
    lib,
    pkgs,
    ...
  }: let
    firefox-addons = pkgs.callPackage inputs.firefox-addons {};
  in {
    imports = [inputs.zen-browser.homeModules.default];

    config = lib.mkIf osConfig.custom.zen-browser.enable {
      stylix.targets.zen-browser.profileNames = ["sebastien"];

      programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [pkgs.firefoxpwa];
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
      };
      profiles.sebastien = {
        id = 0;
        extensions = {
          force = true;
          packages = with firefox-addons; [
            ublock-origin
            sponsorblock
            behind-the-overlay-revival
            consent-o-matic
            decentraleyes
            dark-mode-website-switcher
            multi-account-containers
            no-pdf-download
            old-reddit-redirect
            terms-of-service-didnt-read
            localcdn
            unpaywall
          ];
          settings = {
            "uBlock0@raymondhill.net" = {
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
        mods = [];
        search = {
          force = true;
          default = "google";
          engines = {
            mynixos = {
              name = "My NixOS";
              urls = [
                {
                  template = "https://mynixos.com/search?q={searchTerms}";
                  params = [
                    {
                      name = "query";
                      value = "searchTerms";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@nx"];
            };
          };
        };
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.fullscreen.autohide" = false;
          "cookiebanners.service.mode" = 2;
          "cookiebanners.service.mode.privateBrowsing" = 2;
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
          "extensions.autoUpdate" = false;
          "extensions.update.enabled" = false;
          "zen.theme.color-prefs.use-workspace-colors" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.hide-toolbar" = false;
          "zen.view.sidebar-expanded" = true;
          "zen.view.use-single-toolbar" = false;
          "zen.welcome-screen.seen" = true;
          "zen.workspaces.container-specific-essentials-enabled" = true;
          "zen.workspaces.force-container-workspace" = true;
          "zen.workspaces.hide-deactivated-workspaces" = true;
          "zen.workspaces.hide-default-container-indicator" = false;
          "zen.workspaces.show-workspace-indicator" = false;
          "zen.workspaces.individual-pinned-tabs" = true;
          "zen.workspaces.show-icon-strip" = true;
          "zen.splitView.change-on-hover" = true;
          "browser.tabs.hoverPreview.enabled" = true;
          "browser.tabs.groups.enabled" = true;
          "zen.tabs.select-recently-used-on-close" = false;
        };
        containersForce = true;
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
      };
    };
    };
  };

  flake.nixosModules.zen-browser = {config, lib, ...}: {
    options.custom.zen-browser.enable = lib.mkEnableOption "Zen Browser";
    config = lib.mkIf config.custom.zen-browser.enable {
      environment.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
  };
}
