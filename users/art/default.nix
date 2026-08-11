{pkgs, ...}: {
  users.users.art = {
    isNormalUser = true;
    description = "Art";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
}
