{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;

  # Intel laptop power management
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;

  # Intel graphics
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [intel-media-driver];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
}
