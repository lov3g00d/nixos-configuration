{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      monitor = ",preferred,auto,auto";

      exec-once = [
        "waybar"
        "mako"
        "swayosd-server"
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
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindle = [
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
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
      height = 36;
      margin-top = 6;
      margin-left = 12;
      margin-right = 12;
      spacing = 0;

      modules-left = ["custom/logo" "hyprland/workspaces" "hyprland/window"];
      modules-center = ["custom/weather" "custom/media"];
      modules-right = ["tray" "custom/powerprofile" "bluetooth" "pulseaudio" "backlight" "network" "cpu" "memory" "temperature" "battery" "clock" "hyprland/language" "custom/power"];

      "custom/logo" = {
        format = "󱄅";
        tooltip = false;
        on-click = "rofi -show drun";
      };

      "custom/power" = {
        format = "󰐥";
        tooltip = false;
        on-click = "systemctl suspend";
        on-click-right = "systemctl poweroff";
      };

      "custom/powerprofile" = {
        format = "{icon}";
        return-type = "json";
        interval = 5;
        exec = ''
          profile=$(powerprofilesctl get)
          case $profile in
            "performance") icon="󰓅" ;;
            "balanced") icon="󰾅" ;;
            "power-saver") icon="󰾆" ;;
            *) icon="󰾅"; profile="unknown" ;;
          esac
          echo "{\"text\": \"$icon\", \"tooltip\": \"Power: $profile\", \"class\": \"$profile\"}"
        '';
        format-icons = {
          "default" = "󰾅";
        };
        on-click = ''
          current=$(powerprofilesctl get)
          case $current in
            "balanced") powerprofilesctl set performance ;;
            "performance") powerprofilesctl set power-saver ;;
            "power-saver") powerprofilesctl set balanced ;;
          esac
        '';
      };

      "hyprland/language" = {
        format = "{short}";
        on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
      };

      "custom/weather" = {
        format = "{}";
        interval = 900;
        exec = ''curl -sf "wttr.in/?format=%l:+%c%t" | tr -d "+"'';
        tooltip-format = "Click for details";
        on-click = "xdg-open https://wttr.in";
      };


      "hyprland/window" = {
        format = "{title}";
        max-length = 35;
        separate-outputs = true;
        rewrite = {
          "(.*) — Mozilla Firefox" = "󰈹 $1";
          "(.*) - Visual Studio Code" = "󰨞 $1";
          "(.*)~(.*)" = "󰆍 $2";
          "(.*) - Discord" = "󰙯 $1";
          "Spotify" = "󰓇 Spotify";
        };
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
          "2" = "󰅩";
          "3" = "󰖟";
          "4" = "󰍡";
          "5" = "󰉋";
          "6" = "󰝚";
          "7" = "󰕧";
          "8" = "󰒓";
          "9" = "󰇮";
          "10" = "󰮂";
          urgent = "󰀦";
          default = "󰝥";
        };
        persistent-workspaces = {
          "*" = 5;
        };
      };

      "custom/media" = {
        format = "{icon} {}";
        return-type = "json";
        format-icons = {
          Playing = "󰐊";
          Paused = "󰏤";
        };
        exec = ''playerctl -a metadata --format '{"text": "{{artist}} - {{title}}", "tooltip": "{{playerName}}: {{artist}} - {{title}}", "alt": "{{status}}", "class": "{{status}}"}' -F 2>/dev/null'';
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
        max-length = 45;
      };

      bluetooth = {
        format = "󰂯";
        format-on = "󰂯";
        format-off = "󰂲";
        format-disabled = "󰂲";
        format-connected = "󰂱 {num_connections}";
        format-connected-battery = "󰂱 {device_battery_percentage}%";
        tooltip-format = "{controller_alias}: {status}";
        tooltip-format-connected = "{controller_alias}\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "󰂱 {device_alias}\n󰁹 {device_battery_percentage}%";
        on-click = "blueman-manager";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 Mute";
        format-icons = {
          headphone = "󰋋";
          hands-free = "󰋎";
          headset = "󰋎";
          phone = "󰏲";
          portable = "󰏲";
          default = ["󰕿" "󰖀" "󰕾"];
        };
        tooltip-format = "{desc}";
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
        tooltip-format = "Brightness: {percent}%";
        on-scroll-up = "brightnessctl set +3%";
        on-scroll-down = "brightnessctl set 3%-";
      };

      network = {
        format-wifi = "{icon} {signalStrength}%";
        format-ethernet = "󰈀 Wired";
        format-disconnected = "󰖪 Off";
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        tooltip-format-wifi = "󰖩 {essid}\n󰩟 {ipaddr}\n󰁅 {bandwidthDownBytes}  󰁝 {bandwidthUpBytes}";
        tooltip-format-ethernet = "󰈀 {ifname}\n󰩟 {ipaddr}";
        tooltip-format-disconnected = "Disconnected";
        on-click = "ghostty -e nmtui";
        interval = 2;
      };

      cpu = {
        format = "{icon} {usage}%";
        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        interval = 2;
        tooltip-format = "CPU: {usage}%\n{avg_frequency}GHz";
        states = {warning = 70; critical = 90;};
      };

      memory = {
        format = "{icon} {percentage}%";
        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        interval = 3;
        tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        states = {warning = 70; critical = 90;};
      };

      temperature = {
        format = "{icon} {temperatureC}°";
        format-icons = ["󱃃" "󰔏" "󱃂"];
        critical-threshold = 80;
        tooltip-format = "CPU Temp: {temperatureC}°C";
      };

      battery = {
        states = {good = 80; warning = 30; critical = 15;};
        format = "{icon} {capacity}%";
        format-charging = "󱐋 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-full = "󰁹 Full";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        tooltip-format = "{timeTo}\n{power}W";
      };

      tray = {
        icon-size = 15;
        spacing = 6;
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%a %d %b}";
        tooltip-format = "<big>{:%B %Y}</big>\n<tt>{calendar}</tt>";
        calendar = {
          format = {
            months = "<span color='#cba6f7'><b>{}</b></span>";
            today = "<span color='#f38ba8'><b>{}</b></span>";
          };
        };
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
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      tooltip {
        background: @base;
        border: 1px solid @surface1;
        border-radius: 8px;
        padding: 4px 8px;
      }

      tooltip label {
        color: @text;
      }

      .modules-left {
        background: alpha(@base, 0.9);
        border-radius: 12px;
        margin-right: 8px;
        padding: 0 4px;
      }

      .modules-center {
        background: alpha(@base, 0.9);
        border-radius: 12px;
        padding: 0 12px;
      }

      .modules-right {
        background: alpha(@base, 0.9);
        border-radius: 12px;
        margin-left: 8px;
        padding: 0 4px;
      }

      #custom-logo {
        color: @blue;
        font-size: 17px;
        padding: 0 12px 0 8px;
      }
      #custom-logo:hover { color: @lavender; }

      #custom-power {
        color: @overlay1;
        font-size: 15px;
        padding: 0 8px 0 6px;
      }
      #custom-power:hover { color: @red; }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        color: @overlay1;
        padding: 2px 8px;
        margin: 2px;
        border-radius: 8px;
        font-size: 14px;
      }

      #workspaces button:hover {
        color: @text;
        background: @surface0;
      }

      #workspaces button.active {
        color: @crust;
        background: @mauve;
        font-weight: bold;
      }

      #workspaces button.urgent {
        color: @crust;
        background: @red;
      }

      #window {
        color: @subtext0;
        padding: 0 12px;
        font-style: italic;
      }

      #custom-weather {
        color: @sky;
        padding: 0 8px;
      }

      #custom-media {
        color: @mauve;
        padding: 0 8px;
      }
      #custom-media.Playing { color: @green; }
      #custom-media.Paused { color: @overlay0; }

      #tray {
        padding: 0 8px;
      }
      #tray > .passive { -gtk-icon-effect: dim; }

      /* Individual modules */
      #bluetooth, #pulseaudio, #backlight, #network,
      #cpu, #memory, #temperature, #battery,
      #custom-powerprofile, #language {
        padding: 0 8px;
      }

      #custom-powerprofile { color: @green; }
      #custom-powerprofile.performance { color: @red; }
      #custom-powerprofile.power-saver { color: @blue; }

      #language { color: @flamingo; }

      #bluetooth { color: @blue; }
      #bluetooth.connected { color: @sapphire; }
      #bluetooth.disabled { color: @surface2; }

      #pulseaudio { color: @pink; }
      #pulseaudio.muted { color: @surface2; }

      #backlight { color: @yellow; }

      #network { color: @sapphire; }
      #network.disconnected { color: @surface2; }

      #cpu { color: @green; }
      #cpu.warning { color: @yellow; }
      #cpu.critical { color: @red; }

      #memory { color: @peach; }
      #memory.warning { color: @yellow; }
      #memory.critical { color: @red; }

      #temperature { color: @teal; }
      #temperature.critical { color: @red; }

      #battery { color: @green; }
      #battery.warning { color: @yellow; }
      #battery.critical { color: @red; }
      #battery.charging { color: @sapphire; }

      #clock {
        color: @lavender;
        font-weight: bold;
        padding: 0 12px;
      }

      /* Hover */
      #bluetooth:hover, #pulseaudio:hover, #backlight:hover,
      #network:hover, #cpu:hover, #memory:hover,
      #temperature:hover, #battery:hover, #clock:hover,
      #custom-weather:hover, #custom-powerprofile:hover, #language:hover {
        background: @surface0;
        border-radius: 6px;
      }
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
        ready_message = "Scan fingerprint or type password";
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
          placeholder_text = "Password...";
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
          text = "cmd[update:3600000] date +'%a, %d %b'";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgb(b4befe)";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Use fingerprint or type password";
          font_size = 12;
          font_family = "JetBrainsMono Nerd Font";
          color = "rgb(6c7086)";
          position = "0, -120";
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
