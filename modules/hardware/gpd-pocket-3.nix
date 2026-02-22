{...}: {
  flake.homeModules.gpd-pocket-3 = {osConfig, lib, ...}: lib.mkIf (osConfig.custom.gpd-pocket-3.enable && (osConfig.custom.niri.enable or false)) {
    programs.niri.settings = {
      outputs = {
        DSI-1 = {
          transform.rotation = 270;
          scale = 1.5;
        };
      };
    };
  };

  flake.nixosModules.gpd-pocket-3 = {config, lib, pkgs, ...}: let
    kver = config.boot.kernelPackages.kernel.version;
    oldKernel = lib.versionOlder kver "6.8";
  in {
    options.custom.gpd-pocket-3.enable = lib.mkEnableOption "GPD Pocket 3 hardware tweaks";

    config = lib.mkIf config.custom.gpd-pocket-3.enable {
        # Initrd modules (from upstream gpd/pocket-3)
        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "usbhid"
          "thunderbolt"
        ];
        boot.initrd.kernelModules = ["i915"];

        boot.loader.systemd-boot.consoleMode = "5";

        boot.kernelParams = [
          "i915.enable_psr=1"
          "i915.enable_fbc=1"
          "pcie_aspm=force"
          "intel_idle.max_cstate=9"
          # Display rotation (from upstream gpd/pocket-3)
          "fbcon=rotate:1"
          "video=DSI-1:panel_orientation=right_side_up"
        ];

        # Intel GPU packages (from upstream gpd/pocket-3)
        hardware.graphics.extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
        ];

        # Audio support for 1195G7 model (from upstream gpd/pocket-3)
        boot.extraModprobeConfig = ''
          options snd-intel-dspcfg dsp_driver=1
        '';

        # Display configuration (from upstream gpd/pocket-3)
        fonts.fontconfig = {
          subpixel.rgba = "vbgr";
          hinting.enable = lib.mkDefault false;
        };
        services.xserver.dpi = 280;

        # HiDPI console font for older kernels (from common/hidpi.nix)
        console.font = lib.mkIf oldKernel (
          lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz"
        );
        console.earlySetup = lib.mkIf oldKernel (lib.mkDefault true);

        # Blacklist ath3k when redistributable firmware is disabled (from common/pc)
        boot.blacklistedKernelModules = lib.optionals (!config.hardware.enableRedistributableFirmware) [
          "ath3k"
        ];

        # SSD TRIM (from common/pc/ssd)
        services.fstrim.enable = lib.mkDefault true;

        # IIO sensor and udev
        services.udev.packages = [pkgs.iio-sensor-proxy];
        hardware.sensor.iio.enable = lib.mkDefault true;
        programs.captive-browser.interface = "wlp174s0";
    };
  };
}
