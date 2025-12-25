{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/hardware.nix
    ./modules/system/networking.nix
    ./modules/desktop/services.nix
    ./modules/desktop/hyprland.nix
    ./users/art
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 21d";
    };
  };

  environment.systemPackages = with pkgs; [vim wget git curl tree];

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  security.pam.services = {
    hyprlock = {fprintAuth = true;};
    greetd.fprintAuth = true;
    login.fprintAuth = true;
  };

  time.timeZone = "Asia/Bangkok";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}
