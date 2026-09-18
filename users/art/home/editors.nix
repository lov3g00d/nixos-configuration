# Neovim configured via nvf.
#
# Philosophy: lean LSP loadout. Languages with direct evidence in this repo
# (packages.nix tooling, file types we actually edit) plus haskell + php which
# the user maintains explicitly. Adding a language is one line; carrying
# unused language servers is closure bloat.
{pkgs, ...}: {
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
      };

      # ─── UI ──────────────────────────────────────────────────────────────
      ui = {
        noice.enable = true;
        illuminate.enable = true;
        breadcrumbs.enable = true;
        colorizer.enable = true;
      };

      visuals = {
        indent-blankline.enable = true;
        nvim-cursorline.enable = true;
      };

      binds.whichKey.enable = true;
      notify.nvim-notify.enable = true;
      dashboard.alpha.enable = true;
      tabline.nvimBufferline.enable = true;

      statusline.lualine = {
        enable = true;
        theme = "catppuccin";
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
            servers = ["nixd"];
          };
          format.enable = true;
          extraDiagnostics.enable = true;
        };
        bash.enable = true;
        zsh.enable = true;
        lua.enable = true;

        # Daily-driver languages
        python = {
          enable = true;
          dap.enable = true;
        };
        typescript.enable = true;
        go = {
          enable = true;
          lsp.enable = true;
          format.enable = true;
          dap.enable = true;
          treesitter.enable = true;
        };
        rust.enable = true;
        clang.enable = true;

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

      extraPackages = with pkgs; [
        gofumpt
        golangci-lint
        gotools
        go-tools
        delve
      ];

      # ─── Treesitter ──────────────────────────────────────────────────────
      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
        textobjects.enable = true;
      };

      # ─── Completion & snippets ───────────────────────────────────────────
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;

      extraPlugins = with pkgs.vimPlugins; {
        cmp-cmdline = {package = cmp-cmdline;};
      };

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
            packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
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

      utility.motion.hop.enable = true;
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
      #   <leader>h… hop          (motion)
      #   <leader>x… diagnostics  (trouble)
      keymaps = [
        # Find
        {
          key = "<leader>ff";
          mode = "n";
          action = "<cmd>Telescope find_files<CR>";
          desc = "Find files";
        }
        {
          key = "<leader>fg";
          mode = "n";
          action = "<cmd>Telescope live_grep<CR>";
          desc = "Live grep";
        }
        {
          key = "<leader>fb";
          mode = "n";
          action = "<cmd>Telescope buffers<CR>";
          desc = "Buffers";
        }
        {
          key = "<leader>fh";
          mode = "n";
          action = "<cmd>Telescope help_tags<CR>";
          desc = "Help tags";
        }
        {
          key = "<leader>fr";
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
          key = "<leader>t";
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

        # Code (LSP)
        {
          key = "<leader>cf";
          mode = "n";
          action = "<cmd>lua vim.lsp.buf.format()<CR>";
          desc = "Format buffer";
        }
        {
          key = "<leader>ca";
          mode = "n";
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          desc = "Code action";
        }
        {
          key = "<leader>cr";
          mode = "n";
          action = "<cmd>lua vim.lsp.buf.rename()<CR>";
          desc = "Rename symbol";
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

        # Hop (motion)
        {
          key = "<leader>hw";
          mode = "n";
          action = "<cmd>HopWord<CR>";
          desc = "Hop word";
        }
        {
          key = "<leader>hl";
          mode = "n";
          action = "<cmd>HopLine<CR>";
          desc = "Hop line";
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
        {
          key = "[d";
          mode = "n";
          action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
          desc = "Previous diagnostic";
        }
        {
          key = "]d";
          mode = "n";
          action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
          desc = "Next diagnostic";
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

      # ─── Lua overrides ───────────────────────────────────────────────────
      # Kept here because nvf doesn't expose a structured option for either:
      #  - clipboard: needs vim.opt append, not a flag
      #  - cmp-cmdline: cmdline sources require cmp.setup.cmdline() at runtime
      luaConfigRC.clipboard = ''
        vim.opt.clipboard:append("unnamedplus")
      '';

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
    };
  };
}
