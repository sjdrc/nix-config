{
  pkgs,
  lib,
  config,
  ...
}: let
  orcaSlicerDesktopItem = pkgs.makeDesktopItem {
    name = "orca-slicer-dri";
    desktopName = "OrcaSlicer (DRI)";
    genericName = "3D Printing Software";
    icon = "OrcaSlicer";
    exec = "env GBM_BACKEND=dri ${pkgs.orca-slicer}/bin/orca-slicer %U";
    terminal = false;
    type = "Application";
    mimeTypes = [
      "model/stl"
      "model/3mf"
      "application/vnd.ms-3mfdocument"
      "application/prs.wavefront-obj"
      "application/x-amf"
      "x-scheme-handler/orcaslicer"
    ];
    categories = ["Graphics" "3DGraphics" "Engineering"];
    keywords = ["3D" "Printing" "Slicer" "slice" "3D" "printer" "convert" "gcode" "stl" "obj" "amf" "SLA"];
    startupNotify = false;
    startupWMClass = "orca-slicer";
  };

  orcaSlicerMimeappsList = pkgs.writeText "orca-slicer-mimeapps.list" ''
    [Default Applications]
    model/stl=orca-slicer-dri.desktop;
    model/3mf=orca-slicer-dri.desktop;
    application/vnd.ms-3mfdocument=orca-slicer-dri.desktop;
    application/prs.wavefront-obj=orca-slicer-dri.desktop;
    application/x-amf=orca-slicer-dri.desktop;

    [Added Associations]
    model/stl=orca-slicer-dri.desktop;
    model/3mf=orca-slicer-dri.desktop;
    application/vnd.ms-3mfdocument=orca-slicer-dri.desktop;
    application/prs.wavefront-obj=orca-slicer-dri.desktop;
    application/x-amf=orca-slicer-dri.desktop;
  '';
in {
  options = {
    orca-slicer.enable = lib.mkEnableOption "orca-slicer";
  };

  config = lib.mkIf config.orca-slicer.enable {
    environment.systemPackages = [
      orcaSlicerDesktopItem
    ];
    environment.etc."xdg/mimeapps.list".source = orcaSlicerMimeappsList;
    environment.etc."xdg/mimeapps.list".mode = "0644";
  };
}
