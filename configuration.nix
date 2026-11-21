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

  # Automatic security updates: build against the latest nixos-unstable daily
  # and stage the generation for next boot. "boot" over "switch" so a bump never
  # live-switches mid-work. --override-input implies --no-write-lock-file: root
  # must not write or commit in this art-owned repo (no git identity, and every
  # attempt left root-owned objects in .git). flake.lock moves only via `update`.
  system.autoUpgrade = {
    enable = true;
    flake = "/etc/nixos";
    operation = "boot";
    upgrade = false;
    flags = [
      "--override-input"
      "nixpkgs"
      "github:NixOS/nixpkgs/nixos-unstable"
    ];
    dates = "daily";
    randomizedDelaySec = "45min";
    persistent = true;
  };

  systemd.services.nixos-upgrade.onFailure = ["nixos-upgrade-failed.service"];
  systemd.services.nixos-upgrade-failed = {
    description = "Desktop notification for a failed nixos-upgrade";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.util-linux}/bin/runuser -u art -- \
        env DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u art)/bus" \
        ${pkgs.libnotify}/bin/notify-send -u critical "nixos-upgrade failed" "journalctl -u nixos-upgrade"
    '';
  };

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.11";
}
