{ pkgs, ... }: {
  programs.niri.enable = true;
  # niri-flake's own niri-stable build is broken against current nixpkgs
  # (asserts on the removed libdisplay-info_0_2); nixpkgs' niri is newer anyway.
  programs.niri.package = pkgs.niri;
  # niri comes from nixpkgs (cache.nixos.org), so niri.cachix.org serves nothing.
  niri-flake.cache.enable = false;

  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };
}
