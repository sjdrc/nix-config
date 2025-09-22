{...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usbhid"
  ];

  # Graphical boot
  #boot.plymouth.enable = true;

  # Quiet boot
  #boot.initrd.verbose = false;
  #boot.consoleLogLevel = 0;
  #boot.initrd.systemd.enable = true;
  #boot.kernelParams = [
  #  "quiet"
  #  "splash"
  #  "systemd.show_status=auto"
  #  "rd.udev.log_level=3"
  #];
}
