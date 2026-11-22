{ lib, ... }:
{
  # Let fstrim reach the SSD through dm-crypt. Tradeoff: reveals which blocks are
  # in use (not their contents).
  boot.initrd.luks.devices.cryptroot.allowDiscards = true;

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
