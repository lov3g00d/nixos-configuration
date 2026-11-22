# Neovim configured via nvf.
#
# Philosophy: lean LSP loadout. Languages with direct evidence in this repo
# (packages.nix tooling, file types we actually edit) plus haskell + php which
# the user maintains explicitly. Adding a language is one line; carrying
# unused language servers is closure bloat.
{
  pkgs,
  lib,
  ...
}:
{
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

      # ─── Theme & display ─────────────────────────────────────────────────
      theme = {
        enable = true;
        name = "catppuccin";
        style = "mocha";
      };

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
        clipboard = "unnamedplus";
      };

      globals.mapleader = " ";

      # ─── LSP ─────────────────────────────────────────────────────────────
      lsp = {
        enable = true;
        formatOnSave = true;
        inlayHints.enable = true;
        lightbulb.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
        presets.tailwindcss-language-server.enable = true;
        servers.gopls.settings.gopls = {
          gofumpt = true;
          staticcheck = true;
          usePlaceholders = true;
          completeUnimported = true;
          analyses = {
            unusedparams = true;
            unusedwrite = true;
            nilness = true;
            shadow = true;
            useany = true;
          };
          hints = {
            assignVariableTypes = true;
            compositeLiteralFields = true;
            compositeLiteralTypes = true;
            constantValues = true;
            functionTypeParameters = true;
            parameterNames = true;
            rangeVariableTypes = true;
          };
          codelenses = {
            generate = true;
            test = true;
            tidy = true;
            upgrade_dependency = true;
            regenerate_cgo = true;
            vendor = true;
          };
        };
        servers.nixd.settings.nixd = {
          nixpkgs.expr = "import (builtins.getFlake \"/etc/nixos\").inputs.nixpkgs {}";
          options = {
            nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.nixos.options";
            home_manager.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions []";
          };
        };
        mappings = {
          codeAction = "<leader>ca";
          renameSymbol = "<leader>cr";
        };
      };

      # ─── Diagnostics ─────────────────────────────────────────────────────
      diagnostics = {
        enable = true;
        config = {
          underline = true;
          severity_sort = true;
          signs = true;
          virtual_text = true;
          update_in_insert = false;
        };
      };

      # ─── UI ──────────────────────────────────────────────────────────────
      ui = {
        noice.enable = true;
        illuminate.enable = true;
        colorizer.enable = true;
      };

      visuals = {
        indent-blankline.enable = true;
        nvim-cursorline.enable = true;
      };

      binds.whichKey = {
        enable = true;
        register = {
          "<leader>c" = "+Code";
          "<leader>d" = "+Debug";
          "<leader>g" = "+Git";
          "<leader>G" = "+Go";
        };
      };
      notify.nvim-notify.enable = true;
      dashboard.alpha.enable = true;
      tabline.nvimBufferline.enable = true;

      statusline.lualine = {
        enable = true;
        setupOpts.options.theme = "auto";
        integrations.breadcrumbs.nvim-navic.enable = true;
      };

      # ─── Languages ───────────────────────────────────────────────────────
      # Each entry pulls an LSP server, treesitter grammar, and formatter into
      # the closure. Keep this list intentional. To add: enable here, rebuild.
      languages = {
        enableTreesitter = true;

        # Editing this repo + shells
        nix = {
          enable = true;
          lsp = {
            enable = true;
            servers = [ "nixd" ];
          };
          format = {
            enable = true;
            type = [ "nixfmt" ];
          };
          extraDiagnostics.enable = true;
        };
        bash.enable = true;
        zsh.enable = true;
        lua.enable = true;

        # Daily-driver languages
        python = {
          enable = true;
          dap.enable = true;
          lsp.servers = [
            "basedpyright"
            "ruff"
          ];
        };
        typescript.enable = true;
        go = {
          enable = true;
          format = {
            enable = true;
            type = [
              "goimports"
              "gofumpt"
            ];
          };
          dap.enable = true;
          extraDiagnostics.enable = true;
          extensions.gopher-nvim.enable = true;
        };
        rust = {
          enable = true;
          dap = {
            enable = true;
            debugger = [ "lldb" ];
          };
        };
        clang = {
          enable = true;
          dap.enable = true;
        };

        # Web
        html.enable = true;
        css.enable = true;

        # Infra / DevOps
        docker.enable = true;
        terraform.enable = true;
        hcl.enable = true;
        helm.enable = true;
        sql.enable = true;

        # Data / config formats
        yaml.enable = true;
        json.enable = true;
        toml.enable = true;
        markdown.enable = true;

        # Explicitly maintained
        haskell.enable = true;
        php.enable = true;
      };

      # ─── Treesitter ──────────────────────────────────────────────────────
      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
        textobjects.enable = true;
      };

      # ─── Completion & snippets ───────────────────────────────────────────
      autocomplete.nvim-cmp = {
        enable = true;
        sourcePlugins = [ pkgs.vimPlugins.cmp-cmdline ];
      };
      snippets.luasnip.enable = true;

      # ─── Debugger ────────────────────────────────────────────────────────
      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      # ─── File tree, fuzzy finder, git ────────────────────────────────────
      filetree.nvimTree = {
        enable = true;
        openOnSetup = false;
        setupOpts.view = {
          width = 30;
          side = "left";
        };
      };

      telescope = {
        enable = true;
        extensions = [
          {
            name = "fzf";
            packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
            setup.fzf.fuzzy = true;
          }
        ];
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        vim-fugitive.enable = true;
      };

      # ─── Editing helpers ─────────────────────────────────────────────────
      mini = {
        icons.enable = true;
        surround.enable = true;
      };

      utility.motion.hop = {
        enable = true;
        mappings.hop = "s";
      };
      utility.direnv.enable = true;
      autopairs.nvim-autopairs.enable = true;
      comments.comment-nvim.enable = true;

      terminal.toggleterm = {
        enable = true;
        setupOpts = {
          direction = "horizontal";
          enable_winbar = false;
        };
      };

      # ─── Keymaps (leader: <Space>) ───────────────────────────────────────
      # Namespaces:
      #   <leader>f… find         (telescope)
      #   <leader>c… code         (LSP actions)
      #   <leader>d… debug        (DAP)
      #   <leader>g… git          (fugitive)
      #   <leader>G… go           (gopher)
      #   <leader>h… git hunks    (gitsigns)
      #   <leader>x… diagnostics  (trouble)
      keymaps = [
        # Find (ff/fg/fb/fh/fr are nvf telescope natives; only extras here)
        {
          key = "<leader>fo";
          mode = "n";
          action = "<cmd>Telescope oldfiles<CR>";
          desc = "Recent files";
        }
        {
          key = "<leader>fd";
          mode = "n";
          action = "<cmd>Telescope diagnostics<CR>";
          desc = "All diagnostics";
        }

        # Files / windows / buffers
        {
          key = "<leader>e";
          mode = "n";
          action = "<cmd>NvimTreeToggle<CR>";
          desc = "Toggle file tree";
        }
        {
          key = "<leader>tt";
          mode = "n";
          action = "<cmd>ToggleTerm<CR>";
          desc = "Toggle terminal";
        }
        {
          key = "<leader>w";
          mode = "n";
          action = "<cmd>w<CR>";
          desc = "Save file";
        }
        {
          key = "<leader>q";
          mode = "n";
          action = "<cmd>q<CR>";
          desc = "Quit";
        }
        {
          key = "<Esc>";
          mode = "n";
          action = "<cmd>nohlsearch<CR>";
          desc = "Clear search highlight";
        }

        {
          key = "<C-h>";
          mode = "n";
          action = "<C-w>h";
          desc = "Window left";
        }
        {
          key = "<C-j>";
          mode = "n";
          action = "<C-w>j";
          desc = "Window down";
        }
        {
          key = "<C-k>";
          mode = "n";
          action = "<C-w>k";
          desc = "Window up";
        }
        {
          key = "<C-l>";
          mode = "n";
          action = "<C-w>l";
          desc = "Window right";
        }

        # Code (LSP): ca (code action) / cr (rename) are nvf lsp.mappings natives
        {
          key = "<leader>cf";
          mode = "n";
          action = "<cmd>lua require('conform').format({ lsp_format = 'fallback' })<CR>";
          desc = "Format buffer";
        }

        # Debug (DAP)
        {
          key = "<leader>db";
          mode = "n";
          action = "<cmd>DapToggleBreakpoint<CR>";
          desc = "Toggle breakpoint";
        }
        {
          key = "<leader>dc";
          mode = "n";
          action = "<cmd>DapContinue<CR>";
          desc = "Continue";
        }
        {
          key = "<leader>do";
          mode = "n";
          action = "<cmd>DapStepOver<CR>";
          desc = "Step over";
        }
        {
          key = "<leader>di";
          mode = "n";
          action = "<cmd>DapStepInto<CR>";
          desc = "Step into";
        }
        {
          key = "<leader>du";
          mode = "n";
          action = "<cmd>lua require('dapui').toggle()<CR>";
          desc = "Toggle DAP UI";
        }

        # Git (fugitive)
        {
          key = "<leader>gg";
          mode = "n";
          action = "<cmd>Git<CR>";
          desc = "Git status";
        }
        {
          key = "<leader>gp";
          mode = "n";
          action = "<cmd>Git push<CR>";
          desc = "Git push";
        }
        {
          key = "<leader>gb";
          mode = "n";
          action = "<cmd>Git blame<CR>";
          desc = "Git blame";
        }

        # Go (gopher.nvim)
        {
          key = "<leader>Ge";
          mode = "n";
          action = "<cmd>GoIfErr<CR>";
          desc = "Go: if err";
        }
        {
          key = "<leader>Gt";
          mode = "n";
          action = "<cmd>GoTagAdd json<CR>";
          desc = "Go: add json tags";
        }
        {
          key = "<leader>GT";
          mode = "n";
          action = "<cmd>GoTagRm json<CR>";
          desc = "Go: remove json tags";
        }
        {
          key = "<leader>Gs";
          mode = "n";
          action = "<cmd>GoTestAdd<CR>";
          desc = "Go: test for func";
        }

        # Diagnostics (trouble + native)
        {
          key = "<leader>xx";
          mode = "n";
          action = "<cmd>Trouble diagnostics toggle<CR>";
          desc = "Workspace diagnostics";
        }
        {
          key = "<leader>xX";
          mode = "n";
          action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
          desc = "Buffer diagnostics";
        }

        # Visual
        {
          key = "<";
          mode = "v";
          action = "<gv";
          desc = "Indent left";
        }
        {
          key = ">";
          mode = "v";
          action = ">gv";
          desc = "Indent right";
        }
      ];

      # ─── Cmdline completion ──────────────────────────────────────────────
      # cmp cmdline sources have no nvf option; they need cmp.setup.cmdline() at runtime.
      lazy.plugins.nvim-cmp.after = lib.mkAfter ''
        local cmp = require('cmp')
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
        })
        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = { { name = 'buffer' } }
        })
      '';
    };
  };
}
