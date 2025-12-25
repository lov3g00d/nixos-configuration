{pkgs, ...}: {
  hardware.graphics.extraPackages = [pkgs.intel-compute-runtime];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  services = {
    blueman.enable = true;
    fprintd.enable = true;
    fwupd.enable = true;
  };
}
