{...}: {
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
      k = "kubectl";
      tf = "terraform";
      tg = "terragrunt";
      lg = "lazygit";
      rebuild = "nh os switch /etc/nixos";
      update = "cd /etc/nixos && nix flake update && nh os switch /etc/nixos";
    };
    initContent = ''
      HISTSIZE=10000
      SAVEHIST=10000
      setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS

      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        IFS= read -r -d "" cwd < "$tmp"
        [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
        rm -f -- "$tmp"
      }

      function ssh() {
        if [[ "$TERM" =~ ^(xterm-kitty|xterm-ghostty|alacritty)$ ]] && command -v infocmp &>/dev/null; then
          local host_args=()
          for arg in "$@"; do [[ "$arg" != -* ]] && host_args+=("$arg"); done
          infocmp -x "$TERM" 2>/dev/null | command ssh -o BatchMode=yes "''${host_args[@]}" 'mkdir -p ~/.terminfo && tic -x - 2>/dev/null' 2>/dev/null &
        fi
        command ssh "$@"
      }
    '';
  };

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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.nix-index-database.comma.enable = true;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings.mgr = {
      show_hidden = true;
      sort_by = "natural";
      sort_dir_first = true;
      linemode = "size";
    };
  };
}
