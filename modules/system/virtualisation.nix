{pkgs, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Ships /etc/containers/policy.json + registries.conf so rootless podman can
  # pull images; the bare podman package provides neither.
  virtualisation.containers.enable = true;

  # Web console for managing libvirt VMs (localhost only). The cockpit-machines
  # plugin adds the Machines tab; container view is podman-only, so Docker
  # containers stay on the CLI (docker ps / lazydocker).
  services.cockpit = {
    enable = true;
    openFirewall = false;
  };

  environment.systemPackages = [pkgs.cockpit-machines];
}
