{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    wayland.windowManager.hyprland = {
      plugins = with pkgs; [
        (hyprlandPlugins.hypr-dynamic-cursors.overrideAttrs (oldAttrs: {
          installPhase = ''
            runHook preInstall

            mkdir -p $out/lib
            mv out/dynamic-cursors.so $out/lib/libhypr-dynamic-cursors.so

            runHook postInstall
          '';
        }))
      ];
      settings = {
        plugin.dynamic-cursors = {
          enabled = true;
          mode = "tilt";
          tilt = {
            limit = 5000;
            function = "quadratic";
          };
          shake.enabled = false;
        };
      };
    };
  };
}
