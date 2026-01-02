{...}: {
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services = {
    blueman.enable = true;
    fwupd.enable = true;
    # thermald enabled by nixos-hardware module (lenovo-thinkpad-x1-13th-gen)
    power-profiles-daemon.enable = false; # Conflicts with TLP, stuttering on Core Ultra
    tlp = {
      enable = true;
      settings = {
        # CPU
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        # Platform profiles (TLP 1.9+ defaults)
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";
        # Battery care (ThinkPad specific)
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
