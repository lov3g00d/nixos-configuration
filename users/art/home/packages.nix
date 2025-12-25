{
  pkgs,
  pkgs-24-05,
  ...
}: {
  home.packages = with pkgs; [
    # CLI utilities
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

    # Nix tools
    nh
    nix-output-monitor
    nvd

    # Git tools
    lazygit
    lazydocker
    gh
    git-absorb
    difftastic

    # Desktop/Wayland
    cliphist
    pavucontrol
    brightnessctl
    playerctl
    grim
    slurp
    wl-clipboard
    swww

    # Network
    wireguard-tools
    speedtest-cli
    bandwhich
    dogdns

    # Communication
    slack
    telegram-desktop
    thunderbird

    # Productivity
    _1password-cli
    _1password-gui

    # Containers & K8s
    docker-compose
    kubectl
    krew
    k9s
    kubernetes-helm
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
