{config, ...}: {
  imports = [
    ../../../modules/home/welcome.nix
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./editors.nix
    ./terminals.nix
    ./desktop.nix
  ];

  home.stateVersion = "25.11";

  catppuccin = {
    enable = true;
    flavor = "mocha";
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

  programs.welcome.enable = true;
}
