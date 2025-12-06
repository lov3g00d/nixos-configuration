{ config, lib, pkgs, ... }:

{
  # Define your user account
  users.users.art = {
    isNormalUser = true;
    description = "Art";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      thunderbird
    ];
  };

  # Enable ZSH system-wide
  programs.zsh.enable = true;
}

