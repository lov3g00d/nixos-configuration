{ pkgs, ... }:

{
  # Enable X11 and GNOME
  services.xserver = {
    enable = true;

    # Keyboard layout
    xkb = {
      layout = "us,ua,ru";
      variant = "";
    };
  };

  # Display manager and desktop environment (new options)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Sound with PipeWire (modern audio system)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing support
  services.printing.enable = true;

  # Exclude some default GNOME apps to keep it minimal
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany # GNOME web browser (you have Firefox)
    geary # Email (you have Thunderbird)
  ];
}
