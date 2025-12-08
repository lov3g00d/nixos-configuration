{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal for screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Required packages for a good Hyprland experience
  environment.systemPackages = with pkgs; [
    # Terminal
    kitty

    # App launcher
    rofi

    # Status bar
    waybar

    # Notifications
    mako

    # Screenshot
    grim
    slurp

    # Wallpaper
    hyprpaper

    # Screen lock
    swaylock

    # Clipboard
    wl-clipboard

    # File manager
    nautilus
  ];

  # Enable required services
  services.gnome.gnome-keyring.enable = true;
}
