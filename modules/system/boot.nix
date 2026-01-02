{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        theme = pkgs.catppuccin-grub.override {flavor = "mocha";};
        gfxmodeEfi = "2880x1800";
      };
      timeout = 5;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "i915.enable_guc=3"
    ];
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    };
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

  hardware.enableRedistributableFirmware = true;
}
