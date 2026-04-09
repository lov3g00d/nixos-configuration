{
  pkgs,
  pkgs-25-05,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    # CLI utilities
    aria2
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    yq
    zip
    unzip
    sd
    dust
    duf
    procs
    tokei
    hyperfine
    btop
    tmux
    httpie
    tldr
    mtr
    dnsutils
    nmap
    openssl
    go-task
    helm-docs

    # Typing
    ttyper
    typioca

    # Nix tools
    nix-output-monitor
    nix-fast-build
    nixpkgs-review
    nix-update
    vulnix

    # Git tools
    lazygit
    gh
    git-absorb
    difftastic
    git-cliff

    # Desktop/Wayland
    swayidle
    xwayland-satellite
    libnotify
    cliphist
    pavucontrol
    brightnessctl
    playerctl
    grim
    slurp
    satty
    wl-clipboard
    glow
    nvtopPackages.full
    swayosd
    gammastep
    awww
    wl-screenrec
    hyprpicker
    wayland-utils
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum

    # Network
    wireguard-tools
    speedtest-cli
    bandwhich
    doggo

    # Communication
    slack
    zoom-us
    telegram-desktop
    thunderbird

    # Productivity
    google-chrome
    ungoogled-chromium
    vivaldi
    xournalpp
    libreoffice

    # Containers & k8s
    lazydocker
    docker-compose
    podman
    podman-compose
    kubectl
    krew
    k9s
    kubernetes-helm
    helmfile
    lens
    pkgs-25-05.argocd # pinned to v2 for cluster compat
    velero

    # Cloud & IaC
    awscli2
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    ssm-session-manager-plugin
    terraform
    terragrunt
    ansible

    # Development
    devbox
    devenv
    gcc
    gnumake
    dbeaver-bin

    # AI
    pkgs-unstable.claude-code # nixpkgs-unstable pinned: upstream yanks npm releases frequently
    codex
    gemini-cli

    # Fonts
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  fonts.fontconfig.enable = true;
}
