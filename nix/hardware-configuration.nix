# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a62ae7e2-1abc-4424-8c51-97d4a20bfcf9";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-2f957f11-b1fc-46cf-8ea1-4dc08faf192b".device = "/dev/disk/by-uuid/2f957f11-b1fc-46cf-8ea1-4dc08faf192b";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5BF6-CFCE";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/4a553c75-51a2-4c19-ad84-26a099479f8e";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-1c93ac5c-e671-46bc-bd1a-7eb41f4bdcfb".device = "/dev/disk/by-uuid/1c93ac5c-e671-46bc-bd1a-7eb41f4bdcfb";

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wwp0s20u4.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}