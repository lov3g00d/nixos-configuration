{ pkgs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron apps use Wayland
    WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor issues with NVIDIA
  };

  # XDG portal for screen sharing, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable required services
  services.gnome.gnome-keyring.enable = true;
}
