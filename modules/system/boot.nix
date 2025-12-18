{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Ryzen 5 5600H freeze workarounds (none worked, kept for reference)
  boot.kernelParams = [
    # "processor.max_cstate=1"    # disable deep C-states
    # "idle=nomwait"              # skip mwait-based idle
    # "amdgpu.runpm=0"            # disable GPU runtime PM
    # "amdgpu.aspm=0"             # disable GPU ASPM
    # "pcie_aspm=off"             # disable PCIe ASPM globally
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
}
