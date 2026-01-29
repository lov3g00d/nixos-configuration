{
  pkgs,
  pkgs-24-05,
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
    ttyper
    typioca
    nmap
    openssl

    # Nix tools
    nh
    nix-output-monitor
    nix-fast-build
    nixpkgs-review
    nix-update
    vulnix

    # Git tools
    lazygit
    lazydocker
    gh
    git-absorb
    difftastic

    # Desktop/Wayland
    libnotify
    cliphist
    pavucontrol
    brightnessctl
    playerctl
    grim
    slurp
    wl-clipboard
    swww
    swayosd
    gammastep
    wayland-utils

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
    xournalpp
    libreoffice

    # Containers & K8s
    docker-compose
    podman
    kubectl
    krew
    k9s
    kubernetes-helm
    helmfile
    lens
    argocd
    velero

    # Cloud & IaC
    awscli2
    (pkgs-24-05.google-cloud-sdk.withExtraComponents [
      pkgs-24-05.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    terraform
    terragrunt
    ansible

    # Development
    vscode
    devbox
    devenv
    gcc
    gnumake
    dbeaver-bin
    claude-code

    # Fonts
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  fonts.fontconfig.enable = true;
}
