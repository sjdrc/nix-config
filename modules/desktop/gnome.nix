{pkgs, ...}: let
  bob = prev: {
    buildInputs =
      prev.buildInputs
      ++ [
        pkgs.gst_all_1.gst-plugins-bad
      ];
  };
in {
  #services.gnome.sushi.enable = true;
  environment.systemPackages = [
    (pkgs.nautilus.overrideAttrs bob)
    (pkgs.sushi.overrideAttrs bob)
  ];
  services.gvfs.enable = true;
}
