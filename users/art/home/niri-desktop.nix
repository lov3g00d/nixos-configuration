{
  config,
  pkgs,
  lib,
  ...
}:
{
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
        { proportion = 1.0 / 3.0; }
        { proportion = 0.5; }
        { proportion = 2.0 / 3.0; }
      ];

      default-column-width = {
        proportion = 0.5;
      };

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
      { command = [ "noctalia" ]; }
      {
        command = [
          "1password"
          "--silent"
        ];
      }
    ];

    # Noctalia's notification actions and window activation need this.
    debug.honor-xdg-activation-with-invalid-serial = [ ];

    window-rules = [
      {
        geometry-corner-radius =
          let
            r = 10.0;
          in
          {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
        clip-to-geometry = true;
        opacity = 0.99;
      }
      {
        matches = [ { is-focused = false; } ];
        opacity = 0.92;
      }
      {
        matches = [ { app-id = "^1Password$"; } ];
        open-floating = true;
        block-out-from = "screencast";
      }
      {
        matches = [
          {
            app-id = "^vivaldi";
            title = "(?i)^picture.in.picture$";
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
        action.spawn = [ "ghostty" ];
        hotkey-overlay.title = "Terminal (Ghostty)";
      };
      "Mod+Shift+Return" = {
        action.spawn = [ "alacritty" ];
        hotkey-overlay.title = "Terminal (Alacritty)";
      };
      "Mod+D" = {
        action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "launcher"
        ];
        hotkey-overlay.title = "App Launcher";
      };
      "Mod+B" = {
        action.spawn = [ "vivaldi" ];
        hotkey-overlay.title = "Browser";
      };
      "Mod+C" = {
        action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "clipboard"
        ];
        hotkey-overlay.title = "Clipboard History";
      };

      "Mod+S" = {
        action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "control-center"
        ];
        hotkey-overlay.title = "Control Center";
      };
      "Mod+X" = {
        action.spawn = [
          "noctalia"
          "msg"
          "panel-toggle"
          "session"
        ];
        hotkey-overlay.title = "Session Menu";
      };
      "Mod+N" = {
        action.spawn = [
          "noctalia"
          "msg"
          "notification-dnd-toggle"
        ];
        hotkey-overlay.title = "Toggle Do Not Disturb";
      };
      "Alt+Tab" = {
        action.spawn = [
          "noctalia"
          "msg"
          "window-switcher"
          "hold"
        ];
        hotkey-overlay.title = "Window Switcher";
      };
      "Alt+Shift+Tab".action.spawn = [
        "noctalia"
        "msg"
        "window-switcher"
        "hold"
        "reverse"
      ];

      "Mod+Q" = {
        action.close-window = [ ];
        hotkey-overlay.title = "Close Window";
      };
      "Mod+F" = {
        action.fullscreen-window = [ ];
        hotkey-overlay.title = "Fullscreen";
      };
      "Mod+V" = {
        action.toggle-window-floating = [ ];
        hotkey-overlay.title = "Toggle Floating";
      };
      "Mod+Space" = {
        action.switch-focus-between-floating-and-tiling = [ ];
        hotkey-overlay.title = "Focus Float/Tile";
      };

      "Mod+H".action.focus-column-left = [ ];
      "Mod+J".action.focus-window-down = [ ];
      "Mod+K".action.focus-window-up = [ ];
      "Mod+L".action.focus-column-right = [ ];
      "Mod+Left".action.focus-column-left = [ ];
      "Mod+Down".action.focus-window-down = [ ];
      "Mod+Up".action.focus-window-up = [ ];
      "Mod+Right".action.focus-column-right = [ ];
      "Mod+Home".action.focus-column-first = [ ];
      "Mod+End".action.focus-column-last = [ ];
      "Mod+Tab" = {
        action.focus-window-down-or-column-right = [ ];
        hotkey-overlay.title = "Next Window/Column";
      };
      "Mod+Shift+Tab".action.focus-window-up-or-column-left = [ ];

      "Mod+Shift+H".action.move-column-left = [ ];
      "Mod+Shift+J".action.move-window-down = [ ];
      "Mod+Shift+K".action.move-window-up = [ ];
      "Mod+Shift+L".action.move-column-right = [ ];
      "Mod+Shift+Left".action.move-column-left = [ ];
      "Mod+Shift+Down".action.move-window-down = [ ];
      "Mod+Shift+Up".action.move-window-up = [ ];
      "Mod+Shift+Right".action.move-column-right = [ ];
      "Mod+Shift+Home".action.move-column-to-first = [ ];
      "Mod+Shift+End".action.move-column-to-last = [ ];

      "Mod+BracketLeft" = {
        action.consume-or-expel-window-left = [ ];
        hotkey-overlay.title = "Consume/Expel Left";
      };
      "Mod+BracketRight" = {
        action.consume-or-expel-window-right = [ ];
        hotkey-overlay.title = "Consume/Expel Right";
      };
      "Mod+W" = {
        action.toggle-column-tabbed-display = [ ];
        hotkey-overlay.title = "Toggle Tabs";
      };

      "Mod+R" = {
        action.switch-preset-column-width = [ ];
        hotkey-overlay.title = "Cycle Width (⅓ ½ ⅔)";
      };
      "Mod+M" = {
        action.maximize-column = [ ];
        hotkey-overlay.title = "Maximize Column";
      };
      "Mod+G" = {
        action.center-column = [ ];
        hotkey-overlay.title = "Center Column";
      };
      "Mod+Ctrl+F" = {
        action.expand-column-to-available-width = [ ];
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
        action.focus-workspace-up = [ ];
        hotkey-overlay.title = "Workspace Up";
      };
      "Mod+Page_Down" = {
        action.focus-workspace-down = [ ];
        hotkey-overlay.title = "Workspace Down";
      };
      "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [ ];
      "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [ ];
      "Mod+Ctrl+Page_Up".action.move-workspace-up = [ ];
      "Mod+Ctrl+Page_Down".action.move-workspace-down = [ ];

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
        action.toggle-overview = [ ];
        hotkey-overlay.title = "Overview (all workspaces)";
      };

      "Print" = {
        action.spawn = [
          "noctalia"
          "msg"
          "screenshot-region"
          "--annotate"
        ];
        hotkey-overlay.title = "Screenshot + Annotate";
      };
      "Mod+Print".action.screenshot-screen = [ ];
      "Mod+Shift+Print".action.screenshot-window = [ ];

      "Mod+Escape" = {
        action.spawn = [
          "noctalia"
          "msg"
          "session"
          "lock"
        ];
        hotkey-overlay.title = "Lock Screen";
      };
      "Mod+Shift+E" = {
        action.quit = [ ];
        hotkey-overlay.title = "Quit Niri";
      };
      "Mod+Shift+P".action.power-off-monitors = [ ];
      "Mod+Shift+Slash" = {
        action.show-hotkey-overlay = [ ];
        hotkey-overlay.title = "Show This Overlay";
      };

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "volume-up"
        ];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "volume-down"
        ];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "volume-mute"
        ];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "mic-mute"
        ];
      };
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "play-pause"
        ];
      };
      "XF86AudioPause" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "play-pause"
        ];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "next"
        ];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "previous"
        ];
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "brightness-up"
        ];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "brightness-down"
        ];
      };
      "XF86KbdBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "keyboard-backlight-up"
        ];
      };
      "XF86KbdBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = [
          "noctalia"
          "msg"
          "keyboard-backlight-down"
        ];
      };
    };
  };

  programs.noctalia = {
    enable = true;
    settings = {
      shell = {
        font_family = "JetBrainsMono Nerd Font";
        setup_wizard_enabled = false;
        polkit_agent = true;
        greeter_sync.auto_sync = true;
        niri_overview_type_to_launch_enabled = true;
        niri_overview_close_on_launch_enabled = true;
        screenshot.directory = "${config.home.homeDirectory}/Pictures/screenshots";
      };

      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      bar.default = {
        margin_edge = 6;
        margin_ends = 12;
        background_opacity = 0.9;
        widget_spacing = 8;
        start = [
          "launcher"
          "workspaces"
          "active_window"
          "media"
        ];
        center = [
          "clock"
          "weather"
        ];
        end = [
          "tray"
          "group:controls"
          "group:system"
          "battery"
          "keyboard_layout"
          "notifications"
          "session"
        ];
        capsule_group = [
          {
            id = "controls";
            members = [
              "caffeine"
              "bluetooth"
              "volume"
              "brightness"
              "network"
            ];
          }
          {
            id = "system";
            members = [
              "cpu"
              "ram"
              "temp"
            ];
          }
        ];
      };

      widget = {
        active_window.max_length = 200;
        media = {
          hide_when_no_media = true;
          max_length = 180;
        };
        weather.show_condition = false;
        network.show_label = false;
        ram = {
          type = "sysmon";
          stat = "ram_pct";
        };
      };

      # TLP owns power profiles, so the power_profile shortcut is left out.
      control_center.shortcuts = [
        { type = "wifi"; }
        { type = "bluetooth"; }
        { type = "caffeine"; }
        { type = "nightlight"; }
        { type = "notification"; }
      ];

      lockscreen.blurred_desktop = true;

      wallpaper.default.path = "${config.home.homeDirectory}/Pictures/wallpapers/pokemon-rowlet-sleeping-in-wreath-desktop-wallpaper.jpg";

      location.auto_locate = true;
      nightlight = {
        enabled = true;
        temperature_day = 6000;
        temperature_night = 3400;
      };

      idle.behavior = {
        lock = {
          action = "lock";
          enabled = true;
          timeout = 300;
        };
        screen-off = {
          action = "screen_off";
          enabled = true;
          timeout = 600;
        };
        lock-and-suspend = {
          action = "lock_and_suspend";
          enabled = true;
          timeout = 900;
        };
      };
    };
  };
}
