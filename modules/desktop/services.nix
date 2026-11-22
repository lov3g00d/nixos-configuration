{
  pkgs,
  lib,
  ...
}: {
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
  security.pam.services.swaylock = {};

  programs.regreet = {
    enable = true;
    theme = {
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        variant = "mocha";
      };
      name = "catppuccin-mocha-mauve-standard";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
    };
    settings = {
      background.fit = "Cover";
      GTK = {
        application_prefer_dark_theme = true;
        font_name = lib.mkForce "JetBrainsMono Nerd Font 14";
      };
      commands = {
        reboot = ["systemctl" "reboot"];
        poweroff = ["systemctl" "poweroff"];
      };
    };
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
