{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../../modules/home/welcome.nix
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./editors.nix
    ./terminals.nix
    ./desktop-shared.nix
    ./niri-desktop.nix
    ./newsboat.nix
    ./security.nix
    ./endpoint-verification.nix
  ];

  home.stateVersion = "25.11";

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
    waybar.enable = false;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    KREW_ROOT = "${config.home.homeDirectory}/.krew";
    TF_PLUGIN_CACHE_DIR = "${config.home.homeDirectory}/.terraform.d/plugin-cache";
  };

  # Terraform won't create the cache dir itself; ensure it exists.
  home.file.".terraform.d/plugin-cache/.keep".text = "";

  home.sessionPath = [
    "${config.home.homeDirectory}/.krew/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.pointerCursor = {
    enable = true;
    name = "catppuccin-mocha-mauve-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  programs.welcome.enable = true;
}
