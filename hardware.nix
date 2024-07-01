{ config, lib, pkgs, modulesPath, ...}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  ### Boot Configuration
  boot = {
    loader = {
	  systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
	};
    initrd = {
	  availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
      luks.devices = {
	    "root".device = "/dev/disk/by-label/nixos-luks";
        "swap".device = "/dev/disk/by-label/swap-luks";
	  };
	};
	kernelModules = [ "kvm-amd" ];
  };
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };
  swapDevices = [
	{ 
      device = "/dev/disk/by-label/swap";
	}
  ];

  ### Graphics configuration
  services.xserver.videoDrivers = ["amdgpu"];
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
  };

  ### Wireless communication
  hardware.bluetooth = {
	enable = true;
	powerOnBoot = true;
  };
 
  # Audio device configuration
  #services.pipewire.wireplumber.extraConfig."50-alsa-rename" = {
  #  rule = {
  #    matches = {
  #      {
  #        { "api.alsa.path", "equals", "hw:4" },
  #      },
  #    },
  #    apply_properties = {
  #      ["node.description"] = "Behringer",
  #      ["node.nick"] = "Behringer",
  #    },
  #  }
  #  
  #  table.insert(alsa_monitor.rules,rule)
  #};

  networking.useDHCP = lib.mkDefault true;
																		
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
