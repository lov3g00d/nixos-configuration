{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri.settings = {
    cursor = {
      theme = "catppuccin-mocha-mauve-cursors";
      size = 24;
      hide-when-typing = true;
    };

    input = {
      keyboard = {
        xkb.layout = "us,ua,ru";
        xkb.options = "grp:alt_shift_toggle";
        repeat-delay = 600;
        repeat-rate = 25;
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true;
        scroll-factor = 0.3;
      };
      mouse = {
        scroll-factor = 0.3;
      };
      focus-follows-mouse.enable = false;
      workspace-auto-back-and-forth = true;
    };

    outputs."eDP-1" = {
      scale = 1.75;
      mode = {
        width = 2880;
        height = 1800;
        refresh = 120.0;
      };
    };

    layout = {
      gaps = 8;
      center-focused-column = "on-overflow";

      preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 0.5;}
        {proportion = 2.0 / 3.0;}
      ];

      default-column-width = {proportion = 0.5;};

      focus-ring = {
        enable = true;
        width = 2;
        active.color = "#cba6f7";
        inactive.color = "#313244";
      };

      border.enable = false;

      shadow = {
        enable = true;
        softness = 10;
        spread = 3;
        offset = {
          x = 0;
          y = 3;
        };
        color = "#00000064";
      };
    };

    prefer-no-csd = true;
    screenshot-path = "~/Pictures/screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    hotkey-overlay.skip-at-startup = false;

    environment = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };

    spawn-at-startup = [
      {command = ["swayosd-server"];}

      {command = ["1password" "--silent"];}
      {command = ["${config.home.homeDirectory}/.local/bin/gammastep-auto"];}
      {command = ["${config.home.homeDirectory}/.local/bin/bt-autoconnect"];}
      {command = ["awww-daemon"];}
      {command = ["sh" "-c" "sleep 1 && awww img ${config.home.homeDirectory}/Pictures/wallpapers/pokemon-rowlet-sleeping-in-wreath-desktop-wallpaper.jpg --transition-type grow --transition-duration 2"];}
      {command = ["wl-paste" "--type" "text" "--watch" "cliphist" "store"];}
      {command = ["wl-paste" "--type" "image" "--watch" "cliphist" "store"];}
    ];

    window-rules = [
      {
        geometry-corner-radius = let
          r = 10.0;
        in {
          top-left = r;
          top-right = r;
          bottom-left = r;
          bottom-right = r;
        };
        clip-to-geometry = true;
        opacity = 0.99;
      }
      {
        matches = [{is-focused = false;}];
        opacity = 0.92;
      }
      {
        matches = [{app-id = "^1Password$";}];
        open-floating = true;
        block-out-from = "screencast";
      }
      {
        matches = [
          {
            app-id = "^firefox$";
            title = "Picture-in-Picture";
          }
        ];
        open-floating = true;
      }
    ];

    # --- Keybindings ---
    # Modifier hierarchy:
    #   Super + key         = focus / navigate
    #   Super + Shift + key = move the thing
    #   Super + Ctrl + key  = resize / cross boundaries
    binds = {
      "Mod+Return" = {
        action.spawn = ["ghostty"];
        hotkey-overlay.title = "Terminal (Ghostty)";
      };
      "Mod+Shift+Return" = {
        action.spawn = ["alacritty"];
        hotkey-overlay.title = "Terminal (Alacritty)";
      };
      "Mod+D" = {
        action.spawn = ["rofi" "-show" "drun"];
        hotkey-overlay.title = "App Launcher";
      };
      "Mod+B" = {
        action.spawn = ["firefox"];
        hotkey-overlay.title = "Browser";
      };
      "Mod+C" = {
        action.spawn = ["sh" "-c" "cliphist list | rofi -dmenu | cliphist decode | wl-copy"];
        hotkey-overlay.title = "Clipboard History";
      };

      "Mod+Q" = {
        action.close-window = [];
        hotkey-overlay.title = "Close Window";
      };
      "Mod+F" = {
        action.fullscreen-window = [];
        hotkey-overlay.title = "Fullscreen";
      };
      "Mod+V" = {
        action.toggle-window-floating = [];
        hotkey-overlay.title = "Toggle Floating";
      };
      "Mod+Space" = {
        action.switch-focus-between-floating-and-tiling = [];
        hotkey-overlay.title = "Focus Float/Tile";
      };

      "Mod+H".action.focus-column-left = [];
      "Mod+J".action.focus-window-down = [];
      "Mod+K".action.focus-window-up = [];
      "Mod+L".action.focus-column-right = [];
      "Mod+Left".action.focus-column-left = [];
      "Mod+Down".action.focus-window-down = [];
      "Mod+Up".action.focus-window-up = [];
      "Mod+Right".action.focus-column-right = [];
      "Mod+Home".action.focus-column-first = [];
      "Mod+End".action.focus-column-last = [];
      "Mod+Tab" = {
        action.focus-window-down-or-column-right = [];
        hotkey-overlay.title = "Next Window/Column";
      };
      "Mod+Shift+Tab".action.focus-window-up-or-column-left = [];

      "Mod+Shift+H".action.move-column-left = [];
      "Mod+Shift+J".action.move-window-down = [];
      "Mod+Shift+K".action.move-window-up = [];
      "Mod+Shift+L".action.move-column-right = [];
      "Mod+Shift+Left".action.move-column-left = [];
      "Mod+Shift+Down".action.move-window-down = [];
      "Mod+Shift+Up".action.move-window-up = [];
      "Mod+Shift+Right".action.move-column-right = [];
      "Mod+Shift+Home".action.move-column-to-first = [];
      "Mod+Shift+End".action.move-column-to-last = [];

      "Mod+BracketLeft" = {
        action.consume-or-expel-window-left = [];
        hotkey-overlay.title = "Consume/Expel Left";
      };
      "Mod+BracketRight" = {
        action.consume-or-expel-window-right = [];
        hotkey-overlay.title = "Consume/Expel Right";
      };
      "Mod+W" = {
        action.toggle-column-tabbed-display = [];
        hotkey-overlay.title = "Toggle Tabs";
      };

      "Mod+R" = {
        action.switch-preset-column-width = [];
        hotkey-overlay.title = "Cycle Width (⅓ ½ ⅔)";
      };
      "Mod+M" = {
        action.maximize-column = [];
        hotkey-overlay.title = "Maximize Column";
      };
      "Mod+G" = {
        action.center-column = [];
        hotkey-overlay.title = "Center Column";
      };
      "Mod+Ctrl+F" = {
        action.expand-column-to-available-width = [];
        hotkey-overlay.title = "Fill Available Width";
      };
      "Mod+Ctrl+H".action.set-column-width = "-5%";
      "Mod+Ctrl+L".action.set-column-width = "+5%";
      "Mod+Ctrl+K".action.set-window-height = "-5%";
      "Mod+Ctrl+J".action.set-window-height = "+5%";
      "Mod+Ctrl+Left".action.set-column-width = "-5%";
      "Mod+Ctrl+Right".action.set-column-width = "+5%";
      "Mod+Ctrl+Up".action.set-window-height = "-5%";
      "Mod+Ctrl+Down".action.set-window-height = "+5%";

      "Mod+Page_Up" = {
        action.focus-workspace-up = [];
        hotkey-overlay.title = "Workspace Up";
      };
      "Mod+Page_Down" = {
        action.focus-workspace-down = [];
        hotkey-overlay.title = "Workspace Down";
      };
      "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [];
      "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [];
      "Mod+Ctrl+Page_Up".action.move-workspace-up = [];
      "Mod+Ctrl+Page_Down".action.move-workspace-down = [];

      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;

      "Mod+O" = {
        action.toggle-overview = [];
        hotkey-overlay.title = "Overview (all workspaces)";
      };

      "Print" = {
        action.spawn = ["sh" "-c" "grim -g \"$(slurp)\" - | satty -f -"];
        hotkey-overlay.title = "Screenshot + Annotate";
      };
      "Mod+Print".action.screenshot-screen = [];
      "Mod+Shift+Print".action.screenshot-window = [];

      "Mod+Alt+R" = {
        action.spawn = ["sh" "-c" "pkill wl-screenrec && notify-send 'Recording' 'Saved to ~/Videos/recordings/' || (mkdir -p ~/Videos/recordings && wl-screenrec -g \"$(slurp)\" -f ~/Videos/recordings/rec-$(date +%Y%m%d-%H%M%S).mp4 & notify-send 'Recording' 'Started — Mod+Shift+R to stop')"];
        hotkey-overlay.title = "Toggle Screen Recording";
      };
      "Mod+P" = {
        action.spawn = ["sh" "-c" "hyprpicker -a && notify-send 'Color Picker' 'Copied to clipboard'"];
        hotkey-overlay.title = "Color Picker";
      };

      "Mod+Escape" = {
        action.spawn = ["swaylock" "-f"];
        hotkey-overlay.title = "Lock Screen";
      };
      "Mod+Shift+E" = {
        action.quit = [];
        hotkey-overlay.title = "Quit Niri";
      };
      "Mod+Shift+P".action.power-off-monitors = [];
      "Mod+Shift+Slash" = {
        action.show-hotkey-overlay = [];
        hotkey-overlay.title = "Show This Overlay";
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["swayosd-client" "--output-volume" "raise"];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["swayosd-client" "--output-volume" "lower"];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = ["swayosd-client" "--output-volume" "mute-toggle"];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = ["swayosd-client" "--input-volume" "mute-toggle"];
      };
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "play-pause"];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "next"];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = ["playerctl" "previous"];
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["swayosd-client" "--brightness" "raise"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["swayosd-client" "--brightness" "lower"];
      };
      "XF86KbdBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["brightnessctl" "--device=*::kbd_backlight" "set" "+10%"];
      };
      "XF86KbdBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["brightnessctl" "--device=*::kbd_backlight" "set" "10%-"];
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 36;
      margin-top = 6;
      margin-left = 12;
      margin-right = 12;
      spacing = 0;

      modules-left = ["custom/logo" "niri/workspaces" "niri/window"];
      modules-center = ["custom/weather" "custom/media"];
      modules-right = ["tray" "custom/caffeine" "custom/powerprofile" "bluetooth" "pulseaudio" "backlight" "network" "cpu" "memory" "temperature" "battery" "clock" "niri/language" "custom/power"];

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

      "custom/caffeine" = {
        format = "{}";
        return-type = "json";
        interval = 2;
        exec = "~/.local/bin/caffeine status";
        on-click = "~/.local/bin/caffeine toggle";
      };

      "custom/powerprofile" = {
        format = "{}";
        return-type = "json";
        interval = 5;
        exec = ''
          profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown")
          case $profile in
            "performance") icon="󰓅"; class="performance" ;;
            "balanced") icon="󰾅"; class="balanced" ;;
            "low-power") icon="󰾆"; class="powersave" ;;
            *) icon="󰾅"; class="balanced" ;;
          esac
          echo "{\"text\": \"$icon\", \"tooltip\": \"Profile: $profile\", \"class\": \"$class\"}"
        '';
        on-click = "~/.local/bin/power-menu";
        on-click-right = "ghostty -e sudo tlp-stat";
      };

      "niri/language" = {
        format = "{}";
        on-click = "niri msg action switch-layout";
      };

      "custom/weather" = {
        format = "{}";
        interval = 900;
        exec = ''
          city=$(curl -4sf --max-time 3 "http://ip-api.com/line/?fields=city" 2>/dev/null | head -1)
          [ -z "$city" ] && city="Bangkok"
          curl -sf --max-time 5 "wttr.in/$city?format=%c+%t" 2>/dev/null | sed 's/+//' || echo "󰖐 --"
        '';
        tooltip-format = "Click for details";
        on-click = "xdg-open https://wttr.in";
      };

      "niri/window" = {
        format = "{title}";
        max-length = 35;
      };

      "niri/workspaces" = {
        format = "{index}";
        on-click = "activate";
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
        format-off = "󰂲";
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
        states = {
          warning = 70;
          critical = 90;
        };
      };

      memory = {
        format = "{icon} {percentage}%";
        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
        interval = 3;
        tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      temperature = {
        format = "{icon} {temperatureC}°";
        format-icons = ["󱃃" "󰔏" "󱃂"];
        hwmon-path-abs = "/sys/devices/platform/coretemp.0/hwmon";
        input-filename = "temp1_input";
        critical-threshold = 80;
        tooltip-format = "CPU Temp: {temperatureC}°C";
      };

      battery = {
        states = {
          good = 80;
          warning = 30;
          critical = 15;
        };
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

      #bluetooth, #pulseaudio, #backlight, #network,
      #cpu, #memory, #temperature, #battery,
      #custom-caffeine, #custom-powerprofile, #language {
        padding: 0 8px;
      }

      #custom-caffeine { color: @overlay1; }
      #custom-caffeine.active { color: @yellow; }

      #custom-powerprofile { color: @green; }
      #custom-powerprofile.performance { color: @red; }
      #custom-powerprofile.powersave { color: @blue; }

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

      #bluetooth:hover, #pulseaudio:hover, #backlight:hover,
      #network:hover, #cpu:hover, #memory:hover,
      #temperature:hover, #battery:hover, #clock:hover,
      #custom-caffeine:hover, #custom-weather:hover, #custom-powerprofile:hover, #language:hover {
        background: @surface0;
        border-radius: 6px;
      }
    '';
  };

  programs.swaylock = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font";
      font-size = 24;
      indicator-radius = 100;
      indicator-thickness = 7;
      show-failed-attempts = true;
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f";
      }
      {
        timeout = 600;
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
      {
        timeout = 900;
        command = "systemctl suspend";
      }
    ];
    events = {
      before-sleep = "pidof swaylock || swaylock -f";
      lock = "pidof swaylock || swaylock -f";
    };
  };

  home.file.".local/bin/kb-switch-niri" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      niri msg action switch-layout
      sleep 0.05
      layout=$(niri msg keyboard-layouts 2>/dev/null | grep '^\*' | sed 's/^\* //' | head -1)
      notify-send -t 1500 "Keyboard" "$layout" -h string:x-canonical-private-synchronous:kb-layout
    '';
  };
}
