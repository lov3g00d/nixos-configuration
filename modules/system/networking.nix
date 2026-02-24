{...}: {
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall.enable = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
      Domains = ["~."];
      FallbackDNS = ["1.1.1.1#cloudflare-dns.com" "1.0.0.1#cloudflare-dns.com"];
    };
  };
}
