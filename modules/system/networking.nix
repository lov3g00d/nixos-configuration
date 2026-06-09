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
      FallbackDNS = ["1.1.1.1#cloudflare-dns.com" "9.9.9.9#dns.quad9.net"];
      LLMNR = "no";
      MulticastDNS = "no";
    };
  };
}
