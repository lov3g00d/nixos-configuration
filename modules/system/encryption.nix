{ lib, ... }:
{
  # Required for TPM2 unlock (systemd in the initrd).
  boot.initrd.systemd.enable = true;

  # Swapfile on the encrypted root (encrypted for free). zram stays primary.
  # Drop this entry if zram is enough for you.
  swapDevices = lib.mkForce [
    {
      device = "/swapfile";
      size = 16 * 1024; # MiB -> 16 GiB
    }
  ];

  # OPTIONAL, stronger-but-experimental: binds TPM unlock to the UKI (see guide step 11 note).
  # NOT needed for the default PCR7+PIN enrollment. If you enable it, rebuild then re-enroll.
  # boot.lanzaboote.measuredBoot.enable = true;
}
