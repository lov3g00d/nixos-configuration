{...}: {
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  services.thermald.enable = false;

  services.thinkfan = {
    enable = true;
    sensors = [
      {
        type = "hwmon";
        query = "/sys/devices/platform/coretemp.0/hwmon";
        indices = [1];
      }
    ];
    levels = [
      [0 0 55]
      [1 50 60]
      [3 55 65]
      [5 60 75]
      [7 70 85]
      ["level auto" 80 32767]
    ];
  };
  boot.extraModprobeConfig = "options thinkpad_acpi fan_control=1";
  # https://github.com/NixOS/nixpkgs/issues/395739
  systemd.services.thinkfan.preStart = ''
    if ! grep -q "^commands:" /proc/acpi/ibm/fan 2>/dev/null; then
      /run/current-system/sw/bin/modprobe -r thinkpad_acpi || true
      /run/current-system/sw/bin/modprobe thinkpad_acpi
    fi
  '';

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services = {
    blueman.enable = true;
    fwupd.enable = true;
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
      enableNotifications = true;
    };
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 80;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 60;
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        PLATFORM_PROFILE_ON_AC = "balanced";
        PLATFORM_PROFILE_ON_BAT = "low-power";
        WIFI_PWR_ON_AC = 0;
        WIFI_PWR_ON_BAT = 1;
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
