{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/hardware.nix
    ./modules/system/networking.nix
    ./modules/system/security.nix
    ./modules/system/endpoint-verification
    ./modules/system/tor.nix
    ./modules/system/miniflux.nix
    ./modules/system/virtualisation.nix
    ./modules/system/encryption.nix
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

  environment.systemPackages = with pkgs; [vim git ghostty.terminfo sbctl];

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

  catppuccin = {
    enable = true;
    autoEnable = false;
  };

  # Automatic security updates: pull nixpkgs daily and stage the new generation
  # for next boot. "boot" over "switch" so an unstable bump never live-switches
  # mid-work; --commit-lock-file records the bumped flake.lock (root-authored,
  # unsigned).
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    operation = "boot";
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    dates = "daily";
    randomizedDelaySec = "45min";
    persistent = true;
  };

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}
