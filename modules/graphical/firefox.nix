{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ firefox ];

  environment.sessionVariables = {
    # Force wayland for firefox
    MOZ_ENABLE_WAYLAND = "1";
  };
}
