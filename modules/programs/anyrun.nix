{...}: {
  flake.homeModules.anyrun = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.custom.programs.anyrun.enable = lib.mkEnableOption "anyrun launcher";

    config = lib.mkIf config.custom.programs.anyrun.enable {
      # Run anyrun as a daemon so it stays resident in memory
      # and subsequent launches are instant (no cold-start plugin loading)
      systemd.user.services.anyrun = {
        Unit = {
          Description = "Anyrun launcher daemon";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Service = {
          ExecStart = "${pkgs.anyrun}/bin/anyrun daemon";
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install.WantedBy = ["graphical-session.target"];
      };

      programs.anyrun = {
        enable = true;

        config = {
          x.fraction = 0.5;
          y.fraction = 0.3;
          width.absolute = 600;
          height.absolute = 0;
          hideIcons = false;
          ignoreExclusiveZones = false;
          layer = "overlay";
          hidePluginInfo = false;
          closeOnClick = true;
          showResultsImmediately = false;
          maxEntries = 10;
          plugins = [
            "${pkgs.anyrun}/lib/libapplications.so"
            "${pkgs.anyrun}/lib/libsymbols.so"
            "${pkgs.anyrun}/lib/librink.so"
            "${pkgs.anyrun}/lib/libshell.so"
            "${pkgs.anyrun}/lib/libwebsearch.so"
            "${pkgs.anyrun}/lib/libdictionary.so"
            "${pkgs.anyrun}/lib/libniri_focus.so"
          ];
        };

        extraConfigFiles = {
          "applications.ron".text = ''
            Config(
              desktop_actions: true,
              max_entries: 5,
              terminal: Some(Terminal(
                command: "kitty",
                args: "-e {}",
              )),
            )
          '';
          "shell.ron".text = ''
            Config(
              prefix: ":sh",
              shell: None,
            )
          '';
          "symbols.ron".text = ''
            Config(
              prefix: "",
              symbols: {},
              max_entries: 3,
            )
          '';
          "websearch.ron".text = ''
            Config(
              prefix: "?",
              engines: [Google],
            )
          '';
          "dictionary.ron".text = ''
            Config(
              prefix: ":def",
              max_entries: 5,
            )
          '';
        };

        extraCss = ''
          @define-color accent #89b4fa;
          @define-color bg-color rgba(30, 30, 46, 0.9);
          @define-color fg-color #cdd6f4;
          @define-color desc-color #a6adc8;

          window {
            background: transparent;
          }

          box.main {
            padding: 8px;
            margin: 10px;
            border-radius: 16px;
            border: 2px solid @accent;
            background-color: @bg-color;
          }

          text {
            min-height: 32px;
            padding: 6px 8px;
            border-radius: 8px;
            color: @fg-color;
          }

          .matches {
            background-color: transparent;
            border-radius: 12px;
          }

          box.plugin:first-child {
            margin-top: 6px;
          }

          box.plugin.info {
            min-width: 200px;
          }

          list.plugin {
            background-color: transparent;
          }

          label.match {
            color: @fg-color;
          }

          label.match.description {
            font-size: 10px;
            color: @desc-color;
          }

          label.plugin.info {
            font-size: 14px;
            color: @fg-color;
          }

          .match {
            background: transparent;
            padding: 4px 8px;
            border-radius: 8px;
          }

          .match:selected {
            background: alpha(@accent, 0.15);
            border-left: 3px solid @accent;
          }
        '';
      };

      custom.programs.niri.launcherCommand = ["anyrun"];
    };
  };
}
