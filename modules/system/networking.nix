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
    dnssec = "allow-downgrade";
    dnsovertls = "opportunistic";
    domains = ["~."];
    fallbackDns = ["1.1.1.1#cloudflare-dns.com" "1.0.0.1#cloudflare-dns.com"];
  };
}
