{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable latest kernel for better hardware support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Firmware + Microcode
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Kernel parameters for Ryzen stability
  boot.kernelParams = [

    # Prevents the CPU from entering deep C-states (C3/C6/C7),
    # which are known to cause hard freezes and instant reboots
    # on many Ryzen 4000/5000/7000 laptops when Linux is in
    # powersave or balanced modes.
    #
    # "processor.max_cstate=1"

    # Forces the kernel to avoid AMD's mwait-based idle mechanism.
    # Some ASUS + Ryzen firmwares handle mwait poorly and will
    # drop power rails too aggressively → sudden resets.
    #
    # This parameter makes Linux use a safer idle loop that
    # dramatically improves stability in low-power modes.
    # "idle=nomwait"

    # Alternative fix for PCI-related freezes
    # Disables Message Signaled Interrupts (MSI) which can cause
    # freezes on some Ryzen configurations
    # Uncomment if still experiencing freezes after the above fixes
    # "pci=nomsi"

    # RCU soft lock fix
    # Moves RCU callbacks off all CPUs, can help with soft lock freezes
    # Uncomment if experiencing "rcu_sched detected stalls" messages
    # "rcu_nocbs=0-15"  # Adjust number based on your CPU core count

    # Disable the AMD P-state driver and fall back to the older
    # acpi-cpufreq driver.
    # "amd_pstate=disable"
  ];

  # Kernel parameters for better performance
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };
}
