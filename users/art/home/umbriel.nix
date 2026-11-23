{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
let
  umbriel = osConfig.programs.umbriel.package;

  setLayout = pkgs.writeShellScript "umbriel-set-layout" ''
    ${lib.getExe umbriel} msg workspace-set-layout "$@" || exit 1
    layout=$(${lib.getExe umbriel} workspaces --json | ${lib.getExe pkgs.jq} -r '.[] | select(.focused) | .layout')
    case "$layout" in
      scrolling) icon=layout-columns ;;
      dwindle) icon=layout-board-split ;;
      master) icon=layout-sidebar ;;
      stacking) icon=stack-2 ;;
      *) icon=layout-grid ;;
    esac
    noctalia msg osd-show "$icon" "Layout: $layout"
  '';

  noctalia = args: {
    action = "spawn noctalia msg ${args}";
    repeat = false;
  };
  locked = args: {
    action = "spawn noctalia msg ${args}";
    allow_when_locked = true;
  };

  workspaces = lib.listToAttrs (
    lib.concatMap (
      n:
      let
        s = toString n;
      in
      [
        (lib.nameValuePair "Mod+${s}" "workspace-switch ${s}")
        (lib.nameValuePair "Mod+Shift+${s}" "window-move-to-workspace ${s}")
      ]
    ) (lib.range 1 5)
  );

  settings = {
    general.autostart = [
      "noctalia"
      "1password --silent"
    ];

    environment = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
    };

    output."eDP-1" = {
      mode = "2880x1800@120";
      scale = 1.75;
    };

    input = {
      keyboard = {
        layout = "us,ua,ru";
        options = "grp:alt_shift_toggle";
        repeat_delay = 600;
        repeat_rate = 25;
      };
      touchpad = {
        tap = true;
        natural_scroll = true;
        disable_while_typing = true;
        scroll_factor = 0.3;
      };
      cursor = {
        theme = "catppuccin-mocha-mauve-cursors";
        size = 24;
        hide_when_typing = true;
      };
    };

    appearance = {
      border_width = 2;
      corner_radius = 10;
      blur.radius = 3;
    };
    colors.border = {
      focused = "#CBA6F7FF";
      unfocused = "#313244FF";
    };

    workspaces.back_and_forth = true;

    hot_corners.top_left = {
      enabled = true;
      delay_ms = 0;
      action = "overview-toggle";
    };

    layout = {
      mode = "scrolling";
      gap = 8;
      extent_presets = [
        0.333
        0.5
        0.667
      ];
      scrolling.default_extent_fraction = 0.5;
    };

    # Defining keybinds replaces Umbriel's built-in set, so this is the full list.
    keybinds = workspaces // {
      "Mod+Return" = {
        action = "spawn ghostty";
        repeat = false;
      };
      "Mod+Shift+Return" = {
        action = "spawn alacritty";
        repeat = false;
      };
      "Mod+B" = {
        action = "spawn vivaldi";
        repeat = false;
      };
      "Mod+D" = noctalia "panel-toggle launcher";
      "Mod+C" = noctalia "panel-toggle clipboard";
      "Mod+S" = noctalia "panel-toggle control-center";
      "Mod+X" = noctalia "panel-toggle session";
      "Mod+N" = noctalia "notification-dnd-toggle";
      "Alt+Tab" = noctalia "window-switcher hold";
      "Alt+Shift+Tab" = noctalia "window-switcher hold reverse";
      "Print" = noctalia "screenshot-region --annotate";
      "Mod+Print" = noctalia "screenshot-fullscreen";
      "Mod+Shift+Print" = noctalia "screenshot-window";
      "Mod+Escape" = noctalia "session lock";

      "Mod+Q" = {
        action = "window-close";
        repeat = false;
      };
      "Mod+F" = {
        action = "window-toggle-fullscreen";
        repeat = false;
      };
      "Mod+V" = {
        action = "window-toggle-floating";
        repeat = false;
      };
      "Mod+Space" = {
        action = "window-focus-switch-floating";
        repeat = false;
      };
      "Mod+M" = {
        action = "window-toggle-maximize";
        repeat = false;
      };
      "Mod+W" = {
        action = "column-toggle-tabbed";
        repeat = false;
      };
      "Mod+O" = {
        action = "overview-toggle";
        repeat = false;
      };
      "Mod+T" = {
        action = "spawn ${setLayout} toggle scrolling dwindle master stacking";
        repeat = false;
      };
      "Mod+Alt+S" = "spawn ${setLayout} scrolling";
      "Mod+Alt+D" = "spawn ${setLayout} dwindle";
      "Mod+Alt+M" = "spawn ${setLayout} master";
      "Mod+Alt+F" = "spawn ${setLayout} stacking";
      "Mod+Alt+T" = "layout-toggle-split";
      "Mod+Grave" = {
        action = "scratchpad-toggle";
        repeat = false;
      };
      "Mod+Shift+Grave" = {
        action = "window-move-to-scratchpad";
        repeat = false;
      };
      "Mod+Ctrl+Grave" = {
        action = "window-restore-from-scratchpad";
        repeat = false;
      };
      "Mod+Shift+E" = "session-quit";
      "Mod+Shift+P" = "dpms-off";
      "Mod+Shift+Slash" = {
        action = "cheatsheet-toggle";
        repeat = false;
      };

      "Mod+H" = "window-focus-left";
      "Mod+J" = "window-focus-down";
      "Mod+K" = "window-focus-up";
      "Mod+L" = "window-focus-right";
      "Mod+Left" = "window-focus-left";
      "Mod+Down" = "window-focus-down";
      "Mod+Up" = "window-focus-up";
      "Mod+Right" = "window-focus-right";
      "Mod+Home" = "column-focus-first";
      "Mod+End" = "column-focus-last";
      "Mod+Tab" = "window-focus-next";
      "Mod+Shift+Tab" = "window-focus-previous";

      "Mod+Shift+H" = "column-move-left";
      "Mod+Shift+J" = "window-move-down";
      "Mod+Shift+K" = "window-move-up";
      "Mod+Shift+L" = "column-move-right";
      "Mod+Shift+Left" = "column-move-left";
      "Mod+Shift+Down" = "window-move-down";
      "Mod+Shift+Up" = "window-move-up";
      "Mod+Shift+Right" = "column-move-right";
      "Mod+Shift+Home" = "column-move-to-first";
      "Mod+Shift+End" = "column-move-to-last";

      "Mod+BracketLeft" = "window-consume-or-expel-left";
      "Mod+BracketRight" = "window-consume-or-expel-right";
      "Mod+R" = "window-cycle-primary-extent";
      "Mod+G" = "column-center";
      "Mod+Ctrl+H" = "window-modify-primary-extent -0.05";
      "Mod+Ctrl+L" = "window-modify-primary-extent +0.05";
      "Mod+Ctrl+K" = "window-modify-secondary-extent -0.05";
      "Mod+Ctrl+J" = "window-modify-secondary-extent +0.05";
      "Mod+Ctrl+Left" = "window-modify-primary-extent -0.05";
      "Mod+Ctrl+Right" = "window-modify-primary-extent +0.05";
      "Mod+Ctrl+Up" = "window-modify-secondary-extent -0.05";
      "Mod+Ctrl+Down" = "window-modify-secondary-extent +0.05";

      "Mod+Page_Up" = "workspace-previous";
      "Mod+Page_Down" = "workspace-next";
      "Mod+Shift+Page_Up" = "window-move-to-workspace-previous";
      "Mod+Shift+Page_Down" = "window-move-to-workspace-next";
      "Mod+Ctrl+Page_Up" = "workspace-move-up";
      "Mod+Ctrl+Page_Down" = "workspace-move-down";

      "XF86AudioRaiseVolume" = locked "volume-up";
      "XF86AudioLowerVolume" = locked "volume-down";
      "XF86AudioMute" = locked "volume-mute";
      "XF86AudioMicMute" = locked "mic-mute";
      "XF86AudioPlay" = locked "media toggle";
      "XF86AudioPause" = locked "media toggle";
      "XF86AudioNext" = locked "media next";
      "XF86AudioPrev" = locked "media previous";
      "XF86MonBrightnessUp" = locked "brightness-up";
      "XF86MonBrightnessDown" = locked "brightness-down";
      "XF86KbdBrightnessUp" = locked "keyboard-backlight-up";
      "XF86KbdBrightnessDown" = locked "keyboard-backlight-down";
    };

    window_rule = [
      { blur = true; }
      {
        match.app_id = "^dev.noctalia.Noctalia$";
        default_floating = true;
        default_floating_size_px = {
          width = 1020;
          height = 900;
        };
      }
      {
        match.app_id = "^dev.noctalia.UmbrielSharePicker$";
        default_floating = true;
        default_floating_size_px = {
          width = 800;
          height = 600;
        };
      }
      {
        match.app_id = "^1Password$";
        default_floating = true;
        block_capture = true;
      }
      {
        match.title = "^(Picture-in-Picture|Picture in picture)$";
        default_floating = true;
      }
    ];

    layer_rule = [
      {
        match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
        blur = true;
        blur_ignore_alpha = 0.5;
        blur_popups = true;
      }
      {
        match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
        blur_optimized = false;
      }
    ];
  };

  rawConfig = (pkgs.formats.toml { }).generate "umbriel-config.toml" settings;
in
{
  xdg.configFile."umbriel/config.toml".source = pkgs.runCommand "umbriel-config.toml" { } ''
    out_text=$(${lib.getExe umbriel} config validate -c ${rawConfig} 2>&1) || true
    echo "$out_text"
    if echo "$out_text" | grep -qE 'warning:|error:|invalid'; then
      exit 1
    fi
    cp ${rawConfig} $out
  '';
}
