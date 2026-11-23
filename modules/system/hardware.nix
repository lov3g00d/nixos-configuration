{ ... }: {
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
        indices = [ 1 ];
      }
    ];
    levels = [
      [
        0
        0
        20
      ]
      [
        1
        15
        30
      ]
      [
        2
        25
        40
      ]
      [
        3
        35
        50
      ]
      [
        4
        45
        60
      ]
      [
        5
        55
        70
      ]
      [
        6
        65
        80
      ]
      [
        7
        75
        90
      ]
      [
        "level full-speed"
        85
        32767
      ]
    ];
  };
  # https://github.com/NixOS/nixpkgs/issues/395739
  systemd.services.thinkfan.preStart = ''
    if ! grep -q "^commands:" /proc/acpi/ibm/fan 2>/dev/null; then
      /run/current-system/sw/bin/modprobe -r thinkpad_acpi || true
      /run/current-system/sw/bin/modprobe thinkpad_acpi
    fi
  '';

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
