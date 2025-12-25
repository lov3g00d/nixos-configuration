{pkgs, ...}: {
  programs.nvf = {
    enable = true;
    settings.vim = {
      viAlias = true;
      vimAlias = true;

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

      luaConfigRC.clipboard = ''
        vim.opt.clipboard:append("unnamedplus")
      '';

      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        lspSignature.enable = true;
      };

      ui = {
        fastaction.enable = true;
        noice.enable = true;
        illuminate.enable = true;
        breadcrumbs.enable = true;
        colorizer.enable = true;
      };

      binds.whichKey.enable = true;
      notify.nvim-notify.enable = true;
      dashboard.alpha.enable = true;
      tabline.nvimBufferline.enable = true;

      visuals = {
        indent-blankline.enable = true;
        nvim-cursorline.enable = true;
      };

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

      debugger.nvim-dap = {
        enable = true;
        ui.enable = true;
      };

      treesitter = {
        enable = true;
        fold = true;
        context.enable = true;
      };

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

      statusline.lualine = {
        enable = true;
        theme = "catppuccin";
      };

      filetree.nvimTree = {
        enable = true;
        openOnSetup = false;
        setupOpts.view = {
          width = 20;
          side = "left";
        };
      };

      telescope.enable = true;

      git = {
        enable = true;
        gitsigns.enable = true;
        vim-fugitive.enable = true;
      };

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

      maps = {
        normal = {
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
          "<leader>e" = {
            action = "<cmd>NvimTreeToggle<CR>";
            desc = "Toggle file tree";
          };
          "<leader>t" = {
            action = "<cmd>ToggleTerm<CR>";
            desc = "Toggle terminal";
          };
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
          "<leader>w" = {
            action = "<cmd>w<CR>";
            desc = "Save file";
          };
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
          "<leader>hw" = {
            action = "<cmd>HopWord<CR>";
            desc = "Hop to word";
          };
          "<leader>hl" = {
            action = "<cmd>HopLine<CR>";
            desc = "Hop to line";
          };
          "<leader>gg" = {
            action = "<cmd>Git<CR>";
            desc = "Git status";
          };
          "<leader>gp" = {
            action = "<cmd>Git push<CR>";
            desc = "Git push";
          };
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
}
