{ pkgs, ... }:

{
  # Define user account
  users.users.art = {
    isNormalUser = true;
    description = "Art";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
    ];
    shell = pkgs.zsh;
  };

  # Enable ZSH system-wide
  programs.zsh.enable = true;
}
