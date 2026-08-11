{pkgs, ...}: {
  services.tor = {
    enable = true;
    client.enable = true; # SOCKS5 listener on 127.0.0.1:9050
  };

  # No global proxy. Opt individual commands in with `torsocks <cmd>`; browse with Tor Browser.
  environment.systemPackages = [pkgs.torsocks pkgs.tor-browser];
}
