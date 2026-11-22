{ pkgs, ... }: {
  services.envfs = {
    enable = true;
    # bash in the fallback so /bin/bash resolves even for callers with a stripped
    # PATH (e.g. git/CI hooks); plain `sh` and `env` are provided by default.
    extraFallbackPathCommands = "ln -s ${pkgs.bash}/bin/bash $out/bash";
  };
}
