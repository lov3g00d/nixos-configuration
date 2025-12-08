{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;

    # Enable firewall (best practice for security)
    firewall = {
      enable = true;
      # Allow specific ports as needed
      # allowedTCPPorts = [ 22 80 443 ];
      # allowedUDPPorts = [ ];
    };
  };

  # Better DNS
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];
  };
}
