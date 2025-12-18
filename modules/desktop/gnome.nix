{pkgs, ...}: {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us,ua,ru";
      variant = "";
    };
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour # welcome tour
    epiphany # web browser
    geary # email client
  ];
}
