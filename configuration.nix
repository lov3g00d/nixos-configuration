{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/hardware.nix
    ./modules/system/networking.nix
    ./modules/system/security.nix
    ./modules/system/miniflux.nix
    ./modules/desktop/services.nix
    ./modules/desktop/niri.nix
    ./users/art
  ];

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = ["root" "@wheel"];
      http-connections = 128; # default: 25
      max-substitution-jobs = 64; # default: 16
      extra-substituters = ["https://niri.cachix.org"];
      extra-trusted-public-keys = ["niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z8eAQW2/mDiJ2t2ws="];
    };
    registry.seashells.to = {
      type = "github";
      owner = "lov3g00d";
      repo = "seashells";
    };
  };

  environment.systemPackages = with pkgs; [vim wget git curl tree ghostty.terminfo sbctl];

  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["art"];
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/etc/nixos";
  };
  nixpkgs.config.allowUnfree = true;
  virtualisation.docker.enable = true;

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}
