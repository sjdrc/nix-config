{pkgs, ...}: let
  version = "2.3.1";

  appimageSource = pkgs.fetchurl {
    url = "https://github.com/OrcaSlicer/OrcaSlicer/releases/download/v${version}/OrcaSlicer_Linux_AppImage_Ubuntu2404_V${version}.AppImage";
    hash = "sha256-8ZnlQIkU79u7+k/WdSzWrUcnIJtIi8R7/5oNpfBTpwE=";
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    pname = "orca-slicer";
    inherit version;
    src = appimageSource;
  };
in
  pkgs.appimageTools.wrapType2 {
    pname = "orca-slicer";
    inherit version;

    src = appimageSource;

    profile = ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
      export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
      export WEBKIT_DISABLE_DMABUF_RENDERER=1
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export MESA_LOADER_DRIVER_OVERRIDE=nvidia
    '';

    extraPkgs = pkgs:
      with pkgs; [
        cacert
        curl
        glib
        glib-networking
        glibcLocales
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        webkitgtk_4_1
      ];

    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/OrcaSlicer.desktop $out/share/applications/OrcaSlicer.desktop
      substituteInPlace $out/share/applications/OrcaSlicer.desktop \
        --replace 'Exec=AppRun' 'Exec=orca-slicer' \
        --replace 'Icon=OrcaSlicer' 'Icon=orca-slicer'

      mkdir -p $out/share/pixmaps
      cp ${appimageContents}/resources/images/OrcaSlicer.png $out/share/pixmaps/orca-slicer.png 2>/dev/null || \
      cp ${appimageContents}/.DirIcon $out/share/pixmaps/orca-slicer.png 2>/dev/null || true
    '';
  }
