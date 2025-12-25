{pkgs, ...}: {
  hardware = {
    graphics = {
      enable = true;
      extraPackages = [pkgs.intel-media-driver];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    thermald.enable = true;
    blueman.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
    fstrim = {
      enable = true;
      interval = "weekly";
    };
  };

  powerManagement.powertop.enable = true;
}
