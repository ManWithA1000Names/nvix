{
  description = "A very basic flake";

  inputs = {
    vix.url = "github:manwitha1000names/vix";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # Languages <start> {
    lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim/legacy";
      flake = false;
    };

    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    schemastore = {
      url = "github:b0o/SchemaStore.nvim";
      flake = false;
    };
    # } Languages <end>

    # Completions <start> {
    cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    cmp_path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp_buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp_cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    cmp_nvim_lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    # } COmpletions <end>

    # Key mapping <start> {
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    # } Key mapping <end>

    # Colorschemes <start> {
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    horizon = {
      url = "github:lunarvim/horizon.nvim";
      flake = false;
    };
    # } Colorschemes <end>

    # Syntax highlighting <start> {
    tree-sitter = {
      url =
        "github:nvim-treesitter/nvim-treesitter/4c4d586a05e236d8199ab6faab8cb733a9b5bd24";
      flake = false;
    };
    # } Syntax highlighting <end>

    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Nvim-Tree <start> {
    nvim-tree = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    # } Nvim-Tree <end>

    bufferline = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };

    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };

    # Nvim Autopairs <start> {
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };
    # } Nvim Autopairs <end>

    # Commenting <start> {
    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    nvim-ts-context-commentstring = {
      url = "github:JoosepAlviste/nvim-ts-context-commentstring";
      flake = false;
    };
    # } Commenting <end>

    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    project_nvim = {
      url = "github:ahmedkhalf/project.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, vix, ... }@plugin-sources:
    vix.mkFlake {
      inherit nixpkgs;
      less = [ "self" "nixpkgs" "vix" ];
      config = import ./neovim-config.nix vix;
      plugin-sources = plugin-sources // {
        statusline = ./custom-plugins/statusline;
        signature = ./custom-plugins/signature;
      };
      plugin-setups = {
        fidget = { setup = true; };
        signature = { setup = true; };
        toggleterm = { setup = true; };
        project_nvim = { setup = true; };

        nvim-tree = {
          setup = builtins.readFile ./lua/plugins-configs/nvim-tree.lua;
          urgent = true;
        };

        tree-sitter = {
          setup = builtins.readFile ./lua/plugins-configs/treesitter.lua;
        };
        telescope = {
          setup = builtins.readFile ./lua/plugins-configs/telescope.lua;
        };
        lspconfig = {
          setup = builtins.readFile ./lua/plugins-configs/lspconfig.lua;
        };
        cmp = { setup = builtins.readFile ./lua/plugins-configs/cmp.lua; };

        horizon = {
          setup = false;
          lazy = true;
        };

        gitsigns = {
          setup = ''
            vim.api.nvim_create_autocmd({ "BufRead" }, {
              group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
              callback = function()
                vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
                if vim.v.shell_error == 0 then
                  vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
                  vim.schedule(function()
                    vim.cmd([[packadd gitsigns]]);
                    require("gitsigns").setup({});
                  end)
                end
              end,
            })
          '';
          lazy = true;
        };

        comment = {
          setup = builtins.readFile ./lua/plugins-configs/comment.lua;
          lazy.events = [ "BufRead" ];
        };

        nvim-autopairs = {
          setup = builtins.readFile ./lua/plugins-configs/autopairs.lua;
          lazy.events = [ "InsertEnter" ];
        };

        bufferline = {
          setup = {
            options = {
              diagnostics = "nvim_lsp";
              offsets = [{
                filetype = "NvimTree";
                text = "Explorer";
                highlight = "PanelHeading";
                padding = 1;
              }];
            };
          };
          lazy.events = [ "BufRead" ];
        };
        rust-tools = {
          lua = "vim.defer_fn(function() vim.cmd[[LspStart]] end, 250)";
          setup = pkgs: {
            tools = {
              executor = _: ''require("rust-tools/executors").termopen'';
              reload_workspace_from_cargo_toml = true;
              runnables = { use_telescope = true; };
              inlay_hints = { auto = false; };
              hover_actions = { border = "rounded"; };
              on_initialized = _: ''
                function()
                  vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter", "CursorHold", "InsertLeave"}, {
                    pattern = {"*.rs"},
                    callback = function() pcall(vim.lsp.codelens.refresh) end,
                  });
                end'';
            };
            # dap = {};
            server = {
              cmd = [ (pkgs.lib.getExe pkgs.rust-analyzer) ];
              settings = {
                rust-analyzer = {
                  lens.enalbe = true;
                  checkOnSave = {
                    enable = true;
                    command = "clippy";
                  };
                };
              };
            };
          };
          lazy = {
            pattern = vix.filetypes-for.rust;
            events = [ "FileType" ];
          };
        };
      };
      tools = [
        vix.tools-for.go
        vix.tools-for.zig
        vix.tools-for."c/cpp"
        vix.tools-for.lua
        vix.tools-for.elm
        vix.tools-for.tailwindcss
        vix.tools-for.python
        vix.tools-for.toml
        vix.tools-for.sh
        vix.tools-for.json
        vix.tools-for."ts/js"
        vix.tools-for.yaml
        vix.tools-for.nix
        vix.tools-for.haskell
      ];
    };
}
