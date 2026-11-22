{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # CLI utilities
    aria2
    ripgrep
    fd
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
    gh
    git-absorb
    difftastic
    git-cliff

    # Desktop/Wayland
    xwayland-satellite
    libnotify
    pavucontrol
    playerctl
    slurp
    wl-clipboard
    glow
    nvtopPackages.intel
    wl-screenrec
    libva-utils
    hyprpicker
    wayland-utils

    # Network
    wireguard-tools
    speedtest-cli
    bandwhich
    doggo
    rclone

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
    podman-compose
    kubectl
    krew
    kubernetes-helm
    helmfile
    lens
    argocd
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
    go
    gcc
    gnumake
    dbeaver-bin
    pgadmin4-desktopmode

    # AI
    claude-code
    codex
    antigravity-cli
    pi-coding-agent

    # Fonts
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-multi-rtmp
      obs-vkcapture
    ];
  };

  fonts.fontconfig.enable = true;
}
