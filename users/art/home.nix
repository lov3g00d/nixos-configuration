{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";

  # Catppuccin theme
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  # Set default editor
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # User packages
  home.packages = with pkgs; [
    # Terminal utilities
    ripgrep
    fd
    bat
    eza
    fzf
    zip
    unzip
    neofetch
    yazi
    btop
    atuin
    tmux
    lazygit
    lazydocker
    cliphist
    pavucontrol
    brightnessctl
    playerctl

    claude-code

    # Productivity
    slack
    thunderbird
    _1password-cli
    _1password-gui

    # Containers and orchestration
    docker
    docker-compose

    # Cloud providers
    awscli2
    google-cloud-sdk

    # Kubernetes tools
    kubectl
    krew
    k9s
    lens
    argocd
    velero

    # IaC & Configuration management
    terraform
    terragrunt
    ansible

    # Database tools
    dbeaver-bin

    # Development tools
    vscode
    devbox
    gcc
    gnumake

    # === === === #

    # Fonts
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    font-awesome
  ];

  # Font configuration
  fonts.fontconfig.enable = true;

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Additional zsh plugins
    # plugins = [ ];

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      cat = "bat";
      k = "kubectl";
      tf = "terraform";
      tg = "terragrunt";

      # NixOS helpers
      rebuild = "sudo nixos-rebuild switch --flake '/etc/nixos#nixos'";
      update = "cd /etc/nixos && nix flake update && sudo nixos-rebuild switch --flake '.#nixos'";
    };

    initContent = ''
      # Better history
      HISTSIZE=10000
      SAVEHIST=10000
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS

      # Yazi shell wrapper - changes directory on exit
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }
    '';
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
    };
  };

  # Neovim configuration with nvf
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # Use Catppuccin theme
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

      # Line numbers
      lineNumberMode = "relNumber";

      # Vim options (replaces deprecated top-level settings)
      options = {
        number = true;
        relativenumber = true;
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        autoindent = true;
        smartindent = true;
        cmdheight = 1;
        updatetime = 300;
        signcolumn = "yes";
        timeoutlen = 500;
        mouse = "a";
        termguicolors = true;
        splitbelow = true;
        splitright = true;
        scrolloff = 8;
      };

      # Globals (replaces leaderKey)
      globals.mapleader = " ";

      # Clipboard - use luaConfigRC for system clipboard
      luaConfigRC.clipboard = ''
        vim.opt.clipboard:append("unnamedplus")
      '';

      # LSP
      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      # UI - fastaction replaces nvimCodeActionMenu
      ui.fastaction.enable = true;

      # Language servers
      languages = {
        enableTreesitter = true;

        nix.enable = true;
        bash.enable = true;
        python.enable = true;
        ts.enable = true;
        go.enable = true;
        rust.enable = true;
        html.enable = true;
        markdown.enable = true;
      };

      # Treesitter
      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
      };

      # Autocompletion - use per-plugin enable
      autocomplete.nvim-cmp.enable = true;

      # Statusline
      statusline = {
        lualine = {
          enable = true;
          theme = "catppuccin";
        };
      };

      # File tree
      filetree = {
        nvimTree = {
          enable = true;
          openOnSetup = false;
          setupOpts = {
            view = {
              width = 20;
              side = "left";
            };
          };
        };
      };

      # Telescope
      telescope.enable = true;

      # Git integration
      git = {
        enable = true;
        gitsigns.enable = true;
      };

      # Autopairs - use per-plugin enable
      autopairs.nvim-autopairs.enable = true;

      # Comment plugin
      comments = {
        comment-nvim.enable = true;
      };

      # Terminal
      terminal = {
        toggleterm = {
          enable = true;
          setupOpts = {
            direction = "horizontal";
            enable_winbar = false;
          };
        };
      };

      # Keybindings
      maps = {
        normal = {
          # Telescope
          "<leader>ff" = {
            action = "<cmd>Telescope find_files<CR>";
            desc = "Find files";
          };
          "<leader>fg" = {
            action = "<cmd>Telescope live_grep<CR>";
            desc = "Live grep";
          };
          "<leader>fb" = {
            action = "<cmd>Telescope buffers<CR>";
            desc = "Buffers";
          };
          "<leader>fh" = {
            action = "<cmd>Telescope help_tags<CR>";
            desc = "Help tags";
          };

          # NvimTree
          "<leader>e" = {
            action = "<cmd>NvimTreeToggle<CR>";
            desc = "Toggle file tree";
          };

          # Terminal
          "<leader>t" = {
            action = "<cmd>ToggleTerm<CR>";
            desc = "Toggle terminal";
          };

          # Buffer navigation
          "<leader>bn" = {
            action = "<cmd>bnext<CR>";
            desc = "Next buffer";
          };
          "<leader>bp" = {
            action = "<cmd>bprevious<CR>";
            desc = "Previous buffer";
          };
          "<leader>bd" = {
            action = "<cmd>bdelete<CR>";
            desc = "Delete buffer";
          };

          # Window navigation
          "<C-h>" = {
            action = "<C-w>h";
            desc = "Move to left window";
          };
          "<C-j>" = {
            action = "<C-w>j";
            desc = "Move to bottom window";
          };
          "<C-k>" = {
            action = "<C-w>k";
            desc = "Move to top window";
          };
          "<C-l>" = {
            action = "<C-w>l";
            desc = "Move to right window";
          };

          # Save and quit
          "<leader>w" = {
            action = "<cmd>w<CR>";
            desc = "Save file";
          };
          "<leader>q" = {
            action = "<cmd>q<CR>";
            desc = "Quit";
          };
        };

        visual = {
          # Indent
          "<" = {
            action = "<gv";
            desc = "Indent left";
          };
          ">" = {
            action = ">gv";
            desc = "Indent right";
          };
        };
      };
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "lov3g00d";
        email = "zamkovoy99@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      # Monitor configuration - scale 1.25x to match GNOME
      monitor = ",preferred,auto,1.25";

      # Auto-start programs
      exec-once = [
        "waybar"
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # Input configuration
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
        # Applications
        "$mod, Return, exec, kitty"
        "$mod, D, exec, rofi -show drun"
        "$mod, E, exec, nautilus"

        # Window management
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Move focus (arrow keys)
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move focus (vim keys)
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

        # Move windows (vim keys)
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"

        # Resize windows
        "$mod CTRL, H, resizeactive, -40 0"
        "$mod CTRL, L, resizeactive, 40 0"
        "$mod CTRL, K, resizeactive, 0 -40"
        "$mod CTRL, J, resizeactive, 0 40"

        # Workspaces
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

        # Move windows to workspace
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

        # Special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"

        # Screen lock
        "$mod, Escape, exec, swaylock"

        # Exit Hyprland
        "$mod SHIFT, M, exit"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window rules - assign apps to specific workspaces
      windowrulev2 = [
        "workspace 3, class:^(firefox)$"
        "workspace 4, class:^(Slack)$"
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
    };
  };

  # Waybar
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;

        modules-left = [ "hyprland/window" ];

        # Center: workspaces + media
        modules-center = [
          "hyprland/workspaces"
          "custom/media"
        ];

        # Right panel
        modules-right = [
          "pulseaudio"
          "backlight"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "tray"
          "clock"
        ];

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
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            urgent = "";
            default = "";
          };
        };

        # 🎵 Center media widget (uses your installed playerctl)
        "custom/media" = {
          format = "󰎆  {}";
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

        # 💡 Brightness (you already have brightnessctl)
        backlight = {
          format = "󰃠 {percent}%";
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        # 🌐 Better icons + cleaner output
        network = {
          format-wifi = " {signalStrength}% {bandwidthDownBytes}";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%) - {ipaddr}";
          tooltip-format-ethernet = "{ifname} - {ipaddr}";
          on-click = "kitty -e nmtui";
          interval = 2;
        };

        cpu = {
          format = " {usage}%";
          interval = 2;
          tooltip = true;
        };

        memory = {
          format = " {percentage}%";
          interval = 2;
          tooltip-format = "{used:0.1f}G / {total:0.1f}G used";
        };

        temperature = {
          format = " {temperatureC}°C";
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
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo}";
        };

        tray = {
          spacing = 8;
        };

        clock = {
          format = " {:%I:%M %p}";
          format-alt = "{:%A, %B %d, %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
        };
      };
    };

    style = ''
      /* Catppuccin Mocha Colors */
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
        font-family: "Symbols Nerd Font Mono", "JetBrainsMono Nerd Font Mono", "Font Awesome 6 Free", monospace;
        font-size: 14px;
        min-height: 0;
        border: none;
        border-radius: 0;
        transition-duration: 0.3s;
      }

      #workspaces button {
        border-radius: 999px;
      }

      #workspaces button.active,

      #workspaces button.urgent {
        border-radius: 999px;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0);
      }

      /* Left Section */
      .modules-left {
        background-color: @base;
        padding: 0 10px;
        margin: 0;
        border-radius: 15px;
      }

      #window {
        color: @text;
        padding: 5px 10px;
      }

      /* Center Section */
      .modules-center {
        background-color: @base;
        padding: 0 5px;
        margin: 0;
        border-radius: 15px;
      }

      #workspaces {
        padding: 0;
      }

      #workspaces button {
        padding: 5px 10px;
        color: @overlay0;
        background: transparent;
        transition: all 0.3s ease;
      }

      #workspaces button.active {
        background-color: @lavender;
        color: @base;
      }

      #workspaces button.urgent {
        background-color: @red;
        color: @base;
      }

      #workspaces button:hover {
        box-shadow: inset 0 -3px @lavender;
      }

      #custom-media {
        padding: 5px 10px;
        color: @mauve;
      }

      /* Right Section */
      .modules-right {
        background-color: @base;
        padding: 0 10px;
        margin: 0;
        border-radius: 15px;
      }

      #pulseaudio,
      #backlight,
      #network,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #tray,
      #clock {
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

      #temperature.critical {
        color: @red;
        animation: blink 1s linear infinite;
      }

      #battery.warning {
        color: @yellow;
      }

      #battery.critical {
        color: @red;
        animation: blink 1s linear infinite;
      }

      #battery.charging {
        color: @sapphire;
      }

      @keyframes blink {
        to {
          background-color: @red;
          color: @base;
        }
      }
    '';
  };

  # Rofi customization
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

  # Hyprpaper wallpaper daemon
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;

      preload = [
        "~/Pictures/wallpapers/default.png"
      ];

      wallpaper = [
        ",~/Pictures/wallpapers/default.png"
      ];
    };
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        linemode = "size";
      };
    };
  };

  # Kitty terminal
  programs.kitty = {
    enable = true;

    font = {
      name = "Fira Code";
      size = 14;
    };

    settings = {
      # Window
      background_opacity = "0.90";
      confirm_os_window_close = 0;
      window_padding_width = 8;

      # Cursor
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      # Scrollback
      scrollback_lines = 10000;

      # Bell
      enable_audio_bell = false;

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Tab bar
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
    };

    keybindings = {
      # Tabs
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";

      # Font size
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      # Copy/Paste
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };
}
