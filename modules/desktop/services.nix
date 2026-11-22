{ config, pkgs, ... }:
{
  services = {
    xserver.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;
    # GNOME turns on avahi, which turns on cups-browsed (a root daemon that builds
    # print queues from network adverts) and opens UDP 5353. No network printers
    # are used, and nsswitch has no mdns, so neither is needed.
    printing.browsed.enable = false;
    avahi.openFirewall = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

  # Noctalia's lock screen checks passwords against the login stack and drives
  # the fingerprint reader itself, so pam_fprintd must stay out of login.
  security.pam.services.login.fprintAuth = false;

  # The greeter sends the typed password first. Mirror the login stack and try
  # the reader only after the password fails (an empty one included), so a
  # correct password logs in at once and still unlocks the keyring.
  security.pam.services.greetd.rules.auth =
    let
      unix = "${config.security.pam.package}/lib/security/pam_unix.so";
    in
    {
      login.enable = false;
      unix-early = {
        order = 10100;
        control = "optional";
        modulePath = unix;
        args = [
          "likeauth"
          "nullok"
        ];
      };
      gnome_keyring = {
        order = 10200;
        control = "optional";
        modulePath = "${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so";
      };
      unix = {
        order = 10300;
        control = "sufficient";
        modulePath = unix;
        args = [
          "likeauth"
          "nullok"
          "try_first_pass"
        ];
      };
      fprintd = {
        order = 10400;
        control = "sufficient";
        modulePath = "${config.services.fprintd.package}/lib/security/pam_fprintd.so";
      };
      deny = {
        order = 10500;
        control = "required";
        modulePath = "${config.security.pam.package}/lib/security/pam_deny.so";
      };
    };

  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ "art" ];
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    gnome-music
    gnome-maps
    gnome-weather
    gnome-contacts
    gnome-calendar
    gnome-clocks
    totem
    yelp
    cheese
    simple-scan
    gnome-connections
  ];
}
