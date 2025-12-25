{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      monitor = ",preferred,auto,auto";

      exec-once = [
        "waybar"
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "swww-daemon"
        "~/.local/bin/hypr-session-restore"
      ];

      exec = ["~/.local/bin/wallpaper-random"];

      input = {
        kb_layout = "us,ua,ru";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };
      };

      bind = [
        "$mod, Return, exec, ghostty"
        "$mod SHIFT, Return, exec, alacritty"
        "$mod ALT, Return, exec, kitty"
        "$mod, D, exec, rofi -show drun"
        "$mod, E, exec, nautilus"
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, O, togglesplit"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        "$mod CTRL, H, resizeactive, -40 0"
        "$mod CTRL, L, resizeactive, 40 0"
        "$mod CTRL, K, resizeactive, 0 -40"
        "$mod CTRL, J, resizeactive, 0 40"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"
        "$mod SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +%Y%m%d_%H%M%S).png"
        "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        "$mod, Escape, exec, hyprlock"
        "$mod SHIFT, M, exit"
        "$mod SHIFT, R, exec, hyprctl reload"
        "$mod, B, exec, firefox"
        "$mod, G, centerwindow"
        "$mod, T, pin"
        "$mod, M, layoutmsg, swapwithmaster"
        "$mod, Tab, cyclenext"
        "$mod SHIFT, Tab, cyclenext, prev"
        "$mod CTRL, left, movecurrentworkspacetomonitor, l"
        "$mod CTRL, right, movecurrentworkspacetomonitor, r"
      ];

      bindl = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindle = [
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86KbdBrightnessUp, exec, brightnessctl --device='*::kbd_backlight' set +10%"
        ", XF86KbdBrightnessDown, exec, brightnessctl --device='*::kbd_backlight' set 10%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "workspace 3, class:^(firefox)$"
        "workspace 4, class:^(Slack)$"
        "workspace 9, class:^(thunderbird)$"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };

      dwindle.preserve_split = true;
    };
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      margin-top = 5;
      margin-left = 10;
      margin-right = 10;

      modules-left = ["hyprland/workspaces" "hyprland/window"];
      modules-center = ["custom/media"];
      modules-right = ["pulseaudio" "backlight" "network" "cpu" "memory" "temperature" "battery" "tray" "clock"];

      "hyprland/window" = {
        format = "{}";
        max-length = 45;
        separate-outputs = true;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        all-outputs = false;
        active-only = false;
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        format-icons = {
          "1" = "󰆍";
          "2" = "󰨞";
          "3" = "󰈹";
          "4" = "󰒱";
          "5" = "󰉋";
          "6" = "󰝚";
          "7" = "󰕧";
          "8" = "󰒓";
          "9" = "󰇮";
          "10" = "󰊠";
          urgent = "󰀦";
          default = "󰝥";
        };
      };

      "custom/media" = {
        format = "󰝚 {}";
        exec = "playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo ''";
        interval = 2;
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        max-length = 40;
        tooltip = false;
      };

      pulseaudio = {
        format = "󰕾 {volume}%";
        format-muted = "󰖁 Muted";
        on-click = "pavucontrol";
        tooltip-format = "{desc} | {volume}%";
      };

      backlight = {
        format = "󰃠 {percent}%";
        on-scroll-up = "brightnessctl set +5%";
        on-scroll-down = "brightnessctl set 5%-";
      };

      network = {
        format-wifi = "󰖩 {signalStrength}% {bandwidthDownBytes}";
        format-ethernet = "󰈀";
        format-disconnected = "󰖪";
        tooltip-format-wifi = "{essid} ({signalStrength}%) - {ipaddr}";
        tooltip-format-ethernet = "{ifname} - {ipaddr}";
        on-click = "ghostty -e nmtui";
        interval = 2;
      };

      cpu = {
        format = "󰻠 {usage}%";
        interval = 2;
        tooltip = true;
      };

      memory = {
        format = "󰘚 {percentage}%";
        interval = 2;
        tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
      };

      temperature = {
        format = "󱃃 {temperatureC}°C";
        critical-threshold = 80;
        tooltip = true;
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        tooltip-format = "{timeTo}";
      };

      tray.spacing = 8;

      clock = {
        format = "󰅐 {:%I:%M %p}";
        format-alt = "{:%A, %B %d, %Y}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        interval = 1;
      };
    };

    style = ''
      @define-color rosewater #f5e0dc;
      @define-color flamingo #f2cdcd;
      @define-color pink #f5c2e7;
      @define-color mauve #cba6f7;
      @define-color red #f38ba8;
      @define-color maroon #eba0ac;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color sky #89dceb;
      @define-color sapphire #74c7ec;
      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color text #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color overlay1 #7f849c;
      @define-color overlay0 #6c7086;
      @define-color surface2 #585b70;
      @define-color surface1 #45475a;
      @define-color surface0 #313244;
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;

      * {
        font-family: "Symbols Nerd Font Mono", "JetBrainsMono Nerd Font Mono", monospace;
        font-size: 14px;
        min-height: 0;
        border: none;
        border-radius: 0;
        transition-duration: 0.3s;
      }

      #workspaces button { border-radius: 999px; }
      #workspaces button.active, #workspaces button.urgent { border-radius: 999px; }

      window#waybar { background: rgba(0, 0, 0, 0); }

      .modules-left {
        background-color: @base;
        padding: 0 10px;
        margin: 0;
        border-radius: 15px;
      }

      #window { color: @text; padding: 5px 10px; }

      .modules-center {
        background-color: @base;
        padding: 0 5px;
        margin: 0;
        border-radius: 15px;
      }

      #workspaces { padding: 0; }

      #workspaces button {
        padding: 5px 10px;
        color: @overlay0;
        background: transparent;
        transition: all 0.3s ease;
      }

      #workspaces button.active { background-color: @lavender; color: @base; }
      #workspaces button.urgent { background-color: @red; color: @base; }
      #workspaces button:hover { box-shadow: inset 0 -3px @lavender; }

      #custom-media { padding: 5px 10px; color: @mauve; }

      .modules-right {
        background-color: @base;
        padding: 0 10px;
        margin: 0;
        border-radius: 15px;
      }

      #pulseaudio, #backlight, #network, #cpu, #memory, #temperature, #battery, #tray, #clock {
        padding: 5px 10px;
        color: @text;
      }

      #pulseaudio { color: @pink; }
      #backlight  { color: @sky; }
      #network    { color: @blue; }
      #cpu        { color: @green; }
      #memory     { color: @yellow; }
      #temperature{ color: @peach; }
      #battery    { color: @teal; }
      #clock      { color: @lavender; }

      #temperature.critical { color: @red; animation: blink 1s linear infinite; }
      #battery.warning { color: @yellow; }
      #battery.critical { color: @red; animation: blink 1s linear infinite; }
      #battery.charging { color: @sapphire; }

      @keyframes blink { to { background-color: @red; color: @base; } }
    '';
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 10;
      border-size = 2;
      padding = "15";
      margin = "10";
      layer = "overlay";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
        hide_cursor = true;
      };
      "auth:fingerprint" = {
        enabled = true;
        ready_message = "Scan fingerprint to unlock";
        present_message = "Scanning...";
      };
      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "rgb(b4befe)";
          inner_color = "rgb(1e1e2e)";
          font_color = "rgb(cdd6f4)";
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
      label = [
        {
          monitor = "";
          text = "$TIME";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgb(cdd6f4)";
          position = "0, 150";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:3600000] date +'%a, %b %d'";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgb(b4befe)";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.file.".local/bin/wallpaper-random" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      DIR="$HOME/Pictures/wallpapers"
      IMG=$(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | shuf -n 1)
      [ -n "$IMG" ] && swww img "$IMG" --transition-type random --transition-duration 1
    '';
  };

  home.file."Pictures/screenshots/.keep".text = "";

  systemd.user.services.hypr-session-save = {
    Unit = {
      Description = "Hyprland session auto-save";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "%h/.local/bin/hypr-session-save";
    };
  };

  systemd.user.timers.hypr-session-save = {
    Unit = {
      Description = "Periodic Hyprland session save";
      PartOf = ["graphical-session.target"];
    };
    Timer = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
    Install.WantedBy = ["timers.target"];
  };

  home.file.".local/bin/hypr-session-save" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SESSION_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/hyprland"
      SESSION_FILE="$SESSION_DIR/session.json"
      mkdir -p "$SESSION_DIR"

      hyprctl clients -j 2>/dev/null | jq '[.[] | {
        workspace: .workspace.id,
        class: .class,
        initialClass: .initialClass,
        floating: .floating,
        fullscreen: .fullscreen,
        position: {x: .at[0], y: .at[1]},
        size: {w: .size[0], h: .size[1]}
      }]' > "$SESSION_FILE" 2>/dev/null || true
    '';
  };

  home.file.".local/bin/hypr-session-restore" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SESSION_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/hyprland"
      SESSION_FILE="$SESSION_DIR/session.json"

      [ ! -f "$SESSION_FILE" ] && exit 0

      find_desktop_file() {
        local class="$1"
        local class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
        local search_paths=(
          "$HOME/.local/share/applications"
          "$HOME/.nix-profile/share/applications"
          "/run/current-system/sw/share/applications"
          "/usr/share/applications"
        )

        for dir in "''${search_paths[@]}"; do
          [ ! -d "$dir" ] && continue
          for pattern in "$class.desktop" "$class_lower.desktop" "*$class*.desktop" "*$class_lower*.desktop"; do
            local found=$(find "$dir" -maxdepth 1 -iname "$pattern" 2>/dev/null | head -1)
            [ -n "$found" ] && echo "$found" && return 0
          done
        done
        return 1
      }

      launch_app() {
        local class="$1"
        local workspace="$2"

        case "$class" in
          ""|"xdg-desktop-portal"*|"polkit"*|"waybar"|"mako"|"swww"*|"rofi") return 0 ;;
        esac

        local desktop_file
        if desktop_file=$(find_desktop_file "$class"); then
          hyprctl dispatch workspace "$workspace" >/dev/null
          gtk-launch "$(basename "$desktop_file" .desktop)" &
          sleep 0.8
          return 0
        fi

        if command -v "$class" &>/dev/null; then
          hyprctl dispatch workspace "$workspace" >/dev/null
          "$class" &
          sleep 0.8
          return 0
        fi

        local class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')
        if command -v "$class_lower" &>/dev/null; then
          hyprctl dispatch workspace "$workspace" >/dev/null
          "$class_lower" &
          sleep 0.8
        fi
      }

      sleep 2

      declare -A launched
      jq -r '.[] | "\(.workspace) \(.class) \(.initialClass)"' "$SESSION_FILE" | while read -r workspace class initialClass; do
        [ -z "$class" ] && continue
        app_class="''${class:-$initialClass}"
        [ -z "$app_class" ] && continue
        [ -n "''${launched[$app_class]:-}" ] && continue
        launched[$app_class]=1
        launch_app "$app_class" "$workspace"
      done

      sleep 1
      hyprctl dispatch workspace 1 >/dev/null
      notify-send -u low "Session Restored" "Applications restored from previous session"
    '';
  };
}
