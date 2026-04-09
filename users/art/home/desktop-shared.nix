{pkgs, ...}: {
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 10;
      border-size = 2;
      padding = "15";
      margin = "10";
      layer = "overlay";
      on-notify = "exec pw-play /run/current-system/sw/share/sounds/freedesktop/stereo/message-new-instant.oga";
    };
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

  home.file.".local/bin/bt-autoconnect" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      sleep 3
      BT_DEVICE="''${BT_HEADPHONES:-50:5E:5C:88:38:93}"
      [ -f ~/.config/bt-headphones ] && BT_DEVICE=$(cat ~/.config/bt-headphones)
      bluetoothctl connect "$BT_DEVICE"
    '';
  };

  home.file.".local/bin/gammastep-auto" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      get_location() {
        LOC=$(curl -4sf --max-time 5 "http://ip-api.com/line/?fields=lat,lon" 2>/dev/null | tr '\n' ':')
        [ -n "$LOC" ] && echo "$LOC" && return
        LOC=$(curl -sf --max-time 5 "https://ipinfo.io/loc" 2>/dev/null | tr ',' ':')
        [ -n "$LOC" ] && echo "$LOC" && return
        LAT=$(curl -sf --max-time 5 "https://ifconfig.co/latitude" 2>/dev/null)
        LON=$(curl -sf --max-time 5 "https://ifconfig.co/longitude" 2>/dev/null)
        [ -n "$LAT" ] && [ -n "$LON" ] && echo "$LAT:$LON" && return
      }

      LOC=$(get_location)
      LAT=$(echo "$LOC" | cut -d: -f1)
      LON=$(echo "$LOC" | cut -d: -f2)

      if [ -n "$LAT" ] && [ -n "$LON" ]; then
        exec gammastep -l "$LAT:$LON" -t 6000:3400 -b 1.0:0.9
      else
        exec gammastep -l 44.43:26.1 -t 6000:3400 -b 1.0:0.9
      fi
    '';
  };

  home.file.".local/bin/power-menu" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      current=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown")

      options="󰾆  Power Saver\n󰾅  Balanced\n󰓅  Performance"
      selected=$(echo -e "$options" | rofi -dmenu -p "Power Profile" -mesg "Current: $current" -theme-str 'window {width: 300px;}')

      case "$selected" in
        *"Power Saver"*) profile="low-power" ;;
        *"Balanced"*) profile="balanced" ;;
        *"Performance"*) profile="performance" ;;
        *) exit 0 ;;
      esac

      echo "$profile" | pkexec tee /sys/firmware/acpi/platform_profile > /dev/null
      notify-send "Power Profile" "Switched to $profile" -i battery
    '';
  };

  home.file.".local/bin/caffeine" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      PIDFILE="/tmp/caffeine-$USER.pid"

      toggle() {
        if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
          kill "$(cat "$PIDFILE")" 2>/dev/null
          rm -f "$PIDFILE"
          notify-send "Caffeine" "Disabled - sleep allowed" -i battery-caution
        else
          systemd-inhibit --what=idle:sleep:handle-lid-switch \
            --who="Caffeine" \
            --why="User requested stay awake" \
            sleep infinity &
          echo $! > "$PIDFILE"
          notify-send "Caffeine" "Enabled - preventing sleep" -i battery-full-charged
        fi
      }

      status() {
        if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
          echo '{"text": "󰅶", "tooltip": "Caffeine: ON (click to disable)", "class": "active"}'
        else
          echo '{"text": "󰛊", "tooltip": "Caffeine: OFF (click to enable)", "class": "inactive"}'
        fi
      }

      case "''${1:-toggle}" in
        toggle) toggle ;;
        status) status ;;
        on)
          if ! ([ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null); then
            toggle
          fi
          ;;
        off)
          if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
            toggle
          fi
          ;;
        *) echo "Usage: caffeine [toggle|status|on|off]" ;;
      esac
    '';
  };

  home.file."Pictures/screenshots/.keep".text = "";

  # Suppress blueman tray applet — waybar bluetooth module handles this
  xdg.configFile."autostart/blueman.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
}
