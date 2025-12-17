{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.welcome;

in {
  options.programs.welcome = {
    enable = mkEnableOption "custom welcome message";
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "nixos_small";
          padding = {
            top = 1;
            left = 1;
            right = 1;
          };
        };
        display = {
          separator = " ";
        };
        modules = [
          {
            type = "title";
            format = "{6}@{3}";
          }
          "separator"
          {
            type = "os";
            key = "󱄅 OS";
            format = "{3} {12}";
          }
          {
            type = "kernel";
            key = "󰌽 Kernel";
            format = "{2}";
          }
          {
            type = "uptime";
            key = "󰅐 Up";
          }
          {
            type = "packages";
            key = "󰏔 Pkgs";
            format = "{1} (nix)";
          }
          {
            type = "shell";
            key = "󰆍 Shell";
            format = "{1}";
          }
          {
            type = "wm";
            key = "󰖲 WM";
            format = "{2}";
          }
          {
            type = "terminal";
            key = "󰞷 Term";
            format = "{5}";
          }
          "break"
          {
            type = "cpu";
            key = "󰍛 CPU";
            format = "{1}";
            temp = true;
          }
          {
            type = "gpu";
            key = "󰢮 GPU";
            format = "{1} {2}";
            driverSpecific = true;
            detectionMethod = "pci";
          }
          {
            type = "memory";
            key = "󰍹 Mem";
          }
          {
            type = "disk";
            key = "󰋊 Disk";
            folders = "/";
          }
          {
            type = "battery";
            key = "󰁹 Bat";
          }
          "break"
          {
            type = "localip";
            key = "󰖟 IP";
            format = "{1}";
          }
          {
            type = "wifi";
            key = "󰖩 WiFi";
            format = "{4} ({6})";
          }
          {
            type = "display";
            key = "󰍹 Disp";
            format = "{1}x{2} @ {3}Hz";
          }
          {
            type = "sound";
            key = "󰕾 Audio";
            format = "{2}";
          }
          "break"
          {
            type = "datetime";
            key = "󰃰 Time";
            format = "{1}-{4}-{11} {14}:{17}";
          }
          {
            type = "weather";
            key = "󰖐 Weath";
            timeout = 1000;
          }
          "break"
          "colors"
        ];
      };
    };

    programs.zsh.initContent = lib.mkBefore ''
      # Run fastfetch on new interactive shell
      if [[ -o interactive && -z "$DIRENV_IN_ENVRC" ]]; then
        fastfetch
      fi
    '';
  };
}
