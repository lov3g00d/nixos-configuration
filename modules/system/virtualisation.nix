{...}: {
  virtualisation.docker.enable = true;
  # Docker DNATs published ports ahead of the NixOS firewall, so `-p 5432:5432`
  # would be reachable from any network. Default every publish to loopback;
  # pass an explicit host IP (`-p 0.0.0.0:...`) to expose one on purpose.
  virtualisation.docker.daemon.settings = {
    ip = "127.0.0.1";
    default-network-opts.bridge."com.docker.network.bridge.host_binding_ipv4" = "127.0.0.1";
  };
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Ships /etc/containers/policy.json + registries.conf so rootless podman can
  # pull images; the bare podman package provides neither.
  virtualisation.containers.enable = true;
}
