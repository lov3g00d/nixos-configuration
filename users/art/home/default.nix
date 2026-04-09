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
  ];

  home.stateVersion = "25.11";

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    waybar.enable = false;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    KREW_ROOT = "${config.home.homeDirectory}/.krew";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.krew/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.pointerCursor = {
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
