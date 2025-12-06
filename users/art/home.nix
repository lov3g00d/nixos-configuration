{ config, pkgs, ... }:

{
  home.stateVersion = "25.11";

  # User packages
  home.packages = with pkgs; [
    # Terminal tools
    ripgrep
    fd
    bat
    eza
    fzf
    yazi

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono

    # Development
    gcc
    gnumake
  ];

  # Font configuration
  fonts.fontconfig.enable = true;

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      cat = "bat";

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

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      # Essential plugins
      vim-nix
      nvim-treesitter.withAllGrammars
      telescope-nvim
      plenary-nvim

      # LSP
      nvim-lspconfig

      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path

      # UI
      lualine-nvim
      nvim-web-devicons

      # Color scheme
      catppuccin-nvim
    ];

    extraLuaConfig = ''
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true
      vim.opt.termguicolors = true

      -- Color scheme
      require("catppuccin").setup()
      vim.cmd.colorscheme "catppuccin"

      -- Lualine statusline
      require('lualine').setup {
        options = { theme = 'catppuccin' }
      }

      -- Telescope keybindings
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    '';
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

      # Auto-start programs
      exec-once = [
        "waybar"
      ];

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, nautilus"
        "$mod, V, togglefloating"
        "$mod, D, exec, rofi -show drun"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };
    };
  };

  # Waybar (top bar for Hyprland)
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
          };
        };

        "hyprland/window" = {
          max-length = 50;
        };

        clock = {
          format = "{:%H:%M %d/%m/%Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };

        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          tooltip-format = "{ifname}: {ipaddr}";
        };

        battery = {
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          format-charging = "󰂄 {capacity}%";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background: transparent;
        border-radius: 8px;
      }

      #workspaces button.active {
        background: #89b4fa;
        color: #1e1e2e;
      }

      #workspaces button:hover {
        background: #45475a;
      }

      #window,
      #clock,
      #pulseaudio,
      #network,
      #battery,
      #tray {
        padding: 0 10px;
        margin: 5px 5px;
        background: rgba(69, 71, 90, 0.8);
        border-radius: 8px;
      }

      #pulseaudio.muted {
        color: #f38ba8;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #fab387;
      }

      #battery.critical {
        color: #f38ba8;
      }
    '';
  };

  # Rofi customization
  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
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
}

