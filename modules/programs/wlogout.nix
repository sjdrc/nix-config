flakeArgs @ {...}: {
  flake.homeModules.wlogout = {
    pkgs,
    config,
    lib,
    ...
  }: let
    colors = config.lib.stylix.colors.withHashtag;
    fonts = config.stylix.fonts;
    opacity = config.stylix.opacity;

    iconNames = ["hibernate" "lock" "logout" "reboot" "shutdown" "suspend"];

    # Generate colored icons from wlogout SVG assets (same approach as stylix PR #1645)
    coloredIcons = pkgs.runCommand "wlogout-icons" {buildInputs = [pkgs.imagemagick];} ''
      ICONS=(${lib.escapeShellArgs iconNames})
      mkdir -p $out
      for icon in "''${ICONS[@]}"; do
        sed ${pkgs.wlogout.src}/assets/$icon.svg \
          -e "s/<svg/<svg fill=\"${colors.base0E}\"/" \
          | convert -background none - -resize 512x512 $out/$icon.png
      done
    '';

    mkIconStyle = name: ''
      #${name} {
        background-image: url("${coloredIcons}/${name}.png");
      }
    '';
  in {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "niri msg action quit";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "Suspend";
          keybind = "u";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "Hibernate";
          keybind = "h";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
      ];
      style = ''
        * {
          background-image: none;
          box-shadow: none;
          font-family: "${fonts.sansSerif.name}";
          font-size: ${toString fonts.sizes.desktop}pt;
        }

        window {
          background-color: alpha(${colors.base00}, ${toString opacity.popups});
        }

        button {
          color: ${colors.base05};
          background-color: ${colors.base01};
          border: 1px solid ${colors.base03};
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
          border-radius: 16px;
          margin: 8px;
        }

        button:focus, button:active, button:hover {
          background-color: ${colors.base02};
          outline-style: none;
        }

        ${lib.concatStringsSep "\n" (map mkIconStyle iconNames)}
      '';
    };
  };

  flake.nixosModules.wlogout = {config, lib, ...}: {
    options.custom.wlogout.enable = lib.mkEnableOption "wlogout power menu";
    config = lib.mkIf config.custom.wlogout.enable {
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.wlogout];
    };
  };
}
