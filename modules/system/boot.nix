{ config, lib, pkgs, ... }:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable latest kernel for better hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Firmware + Microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Kernel parameters for Ryzen stability
  boot.kernelParams = [
    "amd_pstate=disable"
    "processor.max_cstate=5"
    "idle=nomwait"
  ];

  # Kernel parameters for better performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
}
