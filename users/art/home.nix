{
  config,
  pkgs,
  pkgs-24-05,
  ...
}: {
  imports = [
    ../../modules/home/welcome.nix
  ];

  home.stateVersion = "25.11";

  # Catppuccin theme
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.waybar.enable = false;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    KREW_ROOT = "${config.home.homeDirectory}/.krew";
  };

  # PATH additions
  home.sessionPath = [
    "${config.home.homeDirectory}/.krew/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  # User packages
  home.packages = with pkgs; [
    # Terminal utilities
    ripgrep
    fd
    bat
    eza
    fzf
    jq
    yq
    zip
    unzip
    fastfetch
    btop
    tmux
    httpie
    tldr
    mtr
    dnsutils
    sd
    dust
    duf
    procs
    tokei
    hyperfine
    nh
    nix-output-monitor
    nvd

    # Git & Docker TUI
    lazygit
    lazydocker
    gh
    git-absorb
    difftastic

    # Desktop utilities
    cliphist
    pavucontrol
    brightnessctl
    playerctl

    # Network tools
    wireguard-tools
    speedtest-cli
    bandwhich
    dogdns

    # Hyprland utilities
    grim
    slurp
    wl-clipboard
    swww

    claude-code

    # Connect
    slack
    telegram-desktop

    # Productivity
    thunderbird
    _1password-cli
    _1password-gui

    # Containers and orchestration
    docker
    docker-compose

    # Cloud providers
    awscli2
    (pkgs-24-05.google-cloud-sdk.withExtraComponents [
      pkgs-24-05.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])

    # Kubernetes tools
    kubectl
    krew
    k9s
    kubernetes-helm
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
      lg = "lazygit";

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

      # SSH wrapper that auto-installs terminfo on remote hosts
      function ssh() {
        if [[ "$TERM" =~ ^(xterm-kitty|xterm-ghostty|alacritty)$ ]] && command -v infocmp &>/dev/null; then
          # Extract just the host (last arg that doesn't start with -)
          local host_args=()
          for arg in "$@"; do
            [[ "$arg" != -* ]] && host_args+=("$arg")
          done
          # Install terminfo silently in background
          infocmp -x "$TERM" 2>/dev/null | command ssh -o BatchMode=yes "''${host_args[@]}" 'mkdir -p ~/.terminfo && tic -x - 2>/dev/null' 2>/dev/null &
        fi
        command ssh "$@"
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

  # Direnv - per-directory environments
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  # Atuin - shell history
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      auto_sync = false;
      search_mode = "fuzzy";
      filter_mode = "global";
      style = "compact";
      inline_height = 20;
      show_preview = true;
      enter_accept = true;
    };
  };

  # Zoxide - smarter cd
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # nix-index + comma - run any package without installing
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.nix-index-database.comma.enable = true;

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

      options = {
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

      # UI enhancements
      ui = {
        fastaction.enable = true;
        noice.enable = true;
        illuminate.enable = true;
        breadcrumbs.enable = true;
        colorizer.enable = true;
      };

      # Which-key for keybinding hints
      binds.whichKey.enable = true;

      # Notifications
      notify.nvim-notify.enable = true;

      # Dashboard on startup
      dashboard.alpha.enable = true;

      # Bufferline for buffer tabs
      tabline.nvimBufferline.enable = true;

      # Indent guides
      visuals = {
        indent-blankline.enable = true;
        nvim-cursorline.enable = true;
      };

      # Language servers
      languages = {
        enableTreesitter = true;

        nix = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          extraDiagnostics.enable = true;
        };
        bash.enable = true;
        python = {
          enable = true;
          dap.enable = true;
        };
        ts.enable = true;
        go = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          dap.enable = true;
          treesitter.enable = true;
        };
        rust = {
          enable = true;
          dap.enable = true;
        };
        html.enable = true;
        css.enable = true;
        markdown.enable = true;
        yaml.enable = true;
        lua.enable = true;
        sql.enable = true;
        terraform.enable = true;
      };

      extraPackages = with pkgs; [
        gofumpt
        golangci-lint
        gotools
        go-tools
        delve
      ];

      # Debugging
      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      # Treesitter
      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
      };

      # Autocompletion with snippets
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;

      extraPlugins = with pkgs.vimPlugins; {
        cmp-path = {package = cmp-path;};
        cmp-buffer = {package = cmp-buffer;};
        cmp-cmdline = {package = cmp-cmdline;};
      };

      luaConfigRC.cmp-sources = ''
        local cmp = require('cmp')
        local config = cmp.get_config()

        table.insert(config.sources, { name = 'path' })
        table.insert(config.sources, { name = 'buffer', keyword_length = 3 })
        cmp.setup(config)

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })
      '';

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
        vim-fugitive.enable = true;
      };

      # Mini modules
      mini = {
        icons.enable = true;
        surround.enable = true;
      };

      # Utilities
      utility = {
        motion.hop.enable = true;
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

          # Debugging (DAP)
          "<leader>db" = {
            action = "<cmd>DapToggleBreakpoint<CR>";
            desc = "Toggle breakpoint";
          };
          "<leader>dc" = {
            action = "<cmd>DapContinue<CR>";
            desc = "Continue";
          };
          "<leader>do" = {
            action = "<cmd>DapStepOver<CR>";
            desc = "Step over";
          };
          "<leader>di" = {
            action = "<cmd>DapStepInto<CR>";
            desc = "Step into";
          };
          "<leader>du" = {
            action = "<cmd>lua require('dapui').toggle()<CR>";
            desc = "Toggle DAP UI";
          };

          # Hop motions
          "<leader>hw" = {
            action = "<cmd>HopWord<CR>";
            desc = "Hop to word";
          };
          "<leader>hl" = {
            action = "<cmd>HopLine<CR>";
            desc = "Hop to line";
          };

          # Git
          "<leader>gg" = {
            action = "<cmd>Git<CR>";
            desc = "Git status";
          };
          "<leader>gp" = {
            action = "<cmd>Git push<CR>";
            desc = "Git push";
          };

          # Trouble diagnostics
          "<leader>xx" = {
            action = "<cmd>Trouble diagnostics toggle<CR>";
            desc = "Toggle diagnostics";
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
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  # Delta - better git diffs
  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      side-by-side = true;
      line-numbers = true;
    };
  };

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      # Monitor configuration - scale 1.25x
      monitor = ",preferred,auto,auto";

      # Auto-start programs
      exec-once = [
        "waybar"
        "mako"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "swww-daemon"
        "~/.local/bin/hypr-session-restore"
      ];

      exec = ["~/.local/bin/wallpaper-random"];

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
        "$mod, Return, exec, ghostty"
        "$mod SHIFT, Return, exec, alacritty"
        "$mod ALT, Return, exec, kitty"
        "$mod, D, exec, rofi -show drun"
        "$mod, E, exec, nautilus"

        # Window management
        "$mod, Q, killactive"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, P, pseudo"
        "$mod, O, togglesplit"

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
        "$mod SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +%Y%m%d_%H%M%S).png"

        # Clipboard history
        "$mod, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # Screen lock
        "$mod, Escape, exec, swaylock"

        # Exit Hyprland
        "$mod SHIFT, M, exit"

        "$mod SHIFT, R, exec, hyprctl reload"

        # Quick app shortcuts
        "$mod, B, exec, firefox"

        # Floating window controls
        "$mod, G, centerwindow"
        "$mod, T, pin"

        # Swap with master/biggest
        "$mod, M, layoutmsg, swapwithmaster"

        # Cycle through windows
        "$mod, Tab, cyclenext"
        "$mod SHIFT, Tab, cyclenext, prev"

        # Move workspace to other monitor
        "$mod CTRL, left, movecurrentworkspacetomonitor, l"
        "$mod CTRL, right, movecurrentworkspacetomonitor, r"
      ];

      # Media and function keys
      bindl = [
        # Volume control
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        # Media playback control
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindle = [
        # Screen brightness
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # Keyboard backlight brightness
        ", XF86KbdBrightnessUp, exec, brightnessctl --device='*::kbd_backlight' set +10%"
        ", XF86KbdBrightnessDown, exec, brightnessctl --device='*::kbd_backlight' set 10%-"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Window rules - assign apps to specific workspaces
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

      dwindle = {
        preserve_split = true;
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

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];

        modules-center = [
          "custom/media"
        ];

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
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "";
            "9" = "";
            "10" = "";
            urgent = "";
            default = "";
          };
        };

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

        backlight = {
          format = "󰃠 {percent}%";
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
        };

        network = {
          format-wifi = " {signalStrength}% {bandwidthDownBytes}";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{essid} ({signalStrength}%) - {ipaddr}";
          tooltip-format-ethernet = "{ifname} - {ipaddr}";
          on-click = "ghostty -e nmtui";
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

  # Mako notifications
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

  # Swaylock screen locker (colors from Catppuccin module)
  programs.swaylock = {
    enable = true;
    settings = {
      indicator-radius = 100;
      indicator-thickness = 10;
      show-failed-attempts = true;
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
    Install = {
      WantedBy = ["timers.target"];
    };
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

  # Custom welcome message
  programs.welcome.enable = true;

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

  # Ghostty terminal (default)
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "Hack Nerd Font";
      font-size = 14;
      background-opacity = 0.80;
      window-padding-x = 8;
      window-padding-y = 8;
      cursor-style = "bar";
      cursor-style-blink = false;
      scrollback-limit = 10000;
      confirm-close-surface = false;
    };
  };

  # Alacritty terminal (secondary)
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "Hack Nerd Font";
        size = 14;
      };
      window = {
        opacity = 0.80;
        padding = {
          x = 8;
          y = 8;
        };
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "Off";
        };
      };
      scrolling.history = 10000;
    };
  };

  # Kitty terminal (tertiary)
  programs.kitty = {
    enable = true;

    font = {
      name = "Hack Nerd Font";
      size = 14;
    };

    settings = {
      # Window
      background_opacity = "0.80";
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
