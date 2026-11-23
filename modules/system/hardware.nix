{ ... }: {
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # thermald refuses to run on ThinkPads with lap-mode detection; the firmware
  # owns thermals and the fan.
  services.thermald.enable = false;

  hardware.flipperzero.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.FastConnectable = true;
  };

  services = {
    fwupd.enable = true;
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
      enableNotifications = true;
    };
    power-profiles-daemon.enable = false;
    fstrim.enable = true;
    # TLP is the single owner of platform_profile and CPU policy. It switches on
    # AC/BAT transitions by itself; tlp-pd adds the manual profile switch.
    tlp = {
      enable = true;
      pd.enable = true;
      settings = {
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_HWP_DYN_BOOST_ON_AC = 1;
        CPU_HWP_DYN_BOOST_ON_BAT = 0;
        PCIE_ASPM_ON_BAT = "powersupersave";
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
