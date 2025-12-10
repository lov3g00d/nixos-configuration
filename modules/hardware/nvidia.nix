{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use proprietary drivers (open drivers don't support kernel 6.18 yet)
    open = false;

    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Power management (helps with suspend/resume and battery)
    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Use the stable driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME offload configuration
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # Provides nvidia-offload command
      };

      # Bus IDs from lspci
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}
