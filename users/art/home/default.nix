{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../../modules/home/welcome.nix
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./editors.nix
    ./terminals.nix
    ./desktop-shared.nix
    ./niri-desktop.nix
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
    AWS_CLI_AUTO_PROMPT = "on-partial";
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
    platformTheme.name = "gtk3";
    style.name = "kvantum";
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser = "vivaldi-stable.desktop";
        mail = "thunderbird.desktop";
        telegram = "org.telegram.desktop.desktop";
      in
      {
        "text/html" = browser;
        "application/xhtml+xml" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "x-scheme-handler/mailto" = mail;
        "x-scheme-handler/mid" = mail;
        "message/rfc822" = mail;
        "x-scheme-handler/webcal" = mail;
        "x-scheme-handler/webcals" = mail;
        "text/calendar" = mail;
        "x-scheme-handler/tg" = telegram;
        "x-scheme-handler/tonsite" = telegram;
        "x-scheme-handler/ton" = telegram;
        "x-scheme-handler/slack" = "slack.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
  };

  programs.welcome.enable = true;
}
