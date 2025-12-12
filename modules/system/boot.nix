{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable latest kernel for better hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Firmware + Microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Kernel parameters for Ryzen/ASUS ROG stability
  boot.kernelParams = [
    # === CPU Power Management ===

    # Prevents deep C-states (C3/C6/C7) - known to cause freezes/reboots
    # "processor.max_cstate=1"

    # Avoid AMD's mwait-based idle - ASUS firmware handles it poorly
    # "idle=nomwait"

    # === AMD GPU (iGPU) Power Management ===

    # Disable runtime power management for amdgpu - prevents freeze on idle
    # "amdgpu.runpm=0"

    # Disable ASPM for amdgpu - fixes PCIe power state issues
    # "amdgpu.aspm=0"

    # Disable BAPM (bidirectional application power management)
    # "amdgpu.bapm=0"

    # === PCIe Power Management ===

    # Disable PCIe ASPM system-wide (aggressive but effective)
    # "pcie_aspm=off"

    # NOTE: None of this setting did not fixed the sudden freeze/restart
    # isue for AMD Ryzen 5 5600H
  ];

  # Kernel parameters for better performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
}
