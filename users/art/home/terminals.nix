{...}: let
  commonSettings = {
    font = "Hack Nerd Font";
    fontSize = 14;
    opacity = 0.80;
    padding = 8;
    scrollback = 1000000;
  };
in {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = commonSettings.font;
      font-size = commonSettings.fontSize;
      background-opacity = commonSettings.opacity;
      window-padding-x = commonSettings.padding;
      window-padding-y = commonSettings.padding;
      cursor-style = "bar";
      cursor-style-blink = false;
      scrollback-limit = commonSettings.scrollback;
      confirm-close-surface = false;
      shell-integration-features = "no-cursor,sudo,ssh-terminfo";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = commonSettings.font;
        size = commonSettings.fontSize;
      };
      window = {
        opacity = commonSettings.opacity;
        padding = {
          x = commonSettings.padding;
          y = commonSettings.padding;
        };
      };
      cursor.style = {
        shape = "Beam";
        blinking = "Off";
      };
      scrolling.history = commonSettings.scrollback;
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = commonSettings.font;
      size = commonSettings.fontSize;
    };
    settings = {
      background_opacity = toString commonSettings.opacity;
      confirm_os_window_close = 0;
      window_padding_width = commonSettings.padding;
      cursor_shape = "beam";
      cursor_blink_interval = 0;
      scrollback_lines = commonSettings.scrollback;
      enable_audio_bell = false;
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      wheel_scroll_multiplier = 1;
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
