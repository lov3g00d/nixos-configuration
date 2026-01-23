{pkgs, ...}: {
  services = {
    xserver.enable = true;
    desktopManager.gnome.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

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
        font_name = "JetBrainsMono Nerd Font 14";
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
    gnome-photos
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
