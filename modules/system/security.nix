{...}: {
  services.fprintd.enable = true;

  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.yama.ptrace_scope" = 1;
  };

  security = {
    protectKernelImage = true;
    forcePageTableIsolation = true;
    virtualisation.flushL1DataCache = "always";
  };
}
