{pkgs, lib, ...}: {
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    # Arrow Lake-H (Core Ultra Series 2) benefits from latest mainline kernel:
    # newer Intel Thread Director scheduling for the 6P+8E+2LP-E hybrid layout,
    # and Xe-LPG iGPU driver patches that land mainline before stable LTS.
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      # Arrow Lake Xe-LPG iGPU: GuC submission (render+media) and FBC.
      "i915.enable_guc=3"
      "i915.enable_fbc=1"
    ];
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = [(pkgs.catppuccin-plymouth.override {variant = "mocha";})];
    };
    kernel.sysctl = {
      # High swappiness because zramSwap (priority 5) absorbs pressure in RAM;
      # the disk swap partition is only an overflow fallback. Pairs with
      # vfs_cache_pressure=50 — both bias the kernel toward keeping page cache
      # and freely compressing cold anon pages.
      "vm.swappiness" = 180;
      # Zram decompresses per-page; swap-in readahead just wastes CPU.
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "fs.inotify.max_user_watches" = 524288;
    };
  };

}
