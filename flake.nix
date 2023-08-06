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
    # } Languages <end>

    # Completions <start> {
    cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    LuaSnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-nvim-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
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
      url = "github:nvim-treesitter/nvim-treesitter";
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

    project = {
      url = "github:ahmedkhalf/project.nvim";
      flake = false;
    };
  };

  outputs = { self, vix, nixpkgs, plenary, lspconfig, null-ls, fidget, cmp
    , LuaSnip, cmp-path, cmp-buffer, cmp-cmdline, cmp-nvim-lsp
    , cmp-nvim-lsp-signature-help, cmp_luasnip, which-key, tokyonight, horizon
    , tree-sitter, telescope, nvim-tree, nvim-web-devicons, bufferline
    , toggleterm, nvim-autopairs, nvim-ts-autotag, comment
    , nvim-ts-context-commentstring, gitsigns, project }:
    vix.mkFlake {
      config = import ./neovim-config.nix;
      plugins = [
        plenary
        null-ls
        which-key
        tokyonight
        horizon
        LuaSnip
        cmp-path
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp_luasnip
        nvim-web-devicons
        nvim-ts-autotag
        nvim-ts-context-commentstring
        {
          name = "nvim-tree";
          src = nvim-tree;
          urgent = true;
          config = builtins.readFile ./plugins-configs/nvim-tree.lua;
        }
        {
          name = "tree-sitter";
          src = tree-sitter;
          config = builtins.readFile ./plugins-configs/treesitter.lua;
        }
        {
          name = "telescope";
          src = telescope;
          config = builtins.readFile ./plugins-configs/telescope.lua;
        }
        {
          name = "lspconfig";
          src = lspconfig;
          config = builtins.readFile ./plugins-configs/lspconfig.lua;
        }
        {
          name = "comment";
          src = comment;
          config = builtins.readFile ./plugins-configs/comment.lua;
        }
        {
          name = "cmp";
          src = cmp;
          config = builtins.readFile ./plugins-configs/cmp.lua;
        }
        {
          name = "nvim-autopairs";
          src = nvim-autopairs;
          config = builtins.readFile ./plugins-configs/autopairs.lua;
        }
        {
          name = "bufferline";
          src = bufferline;
          config = {
            options = {
              diagnostics = "nvim_lsp";
              offests = [{
                filetype = "NvimTree";
                text = "Explorer";
                highlight = "PanelHeading";
                padding = 1;
              }];
            };
          };
        }
        {
          name = "toggleterm";
          src = toggleterm;
        }
        {
          name = "gitsigns";
          src = gitsigns;
        }
        {
          name = "project_nvim";
          src = project;
        }
        {
          name = "fidget";
          src = fidget;
        }
      ];
      languages = [ vix.languages.nix ];
    };
}
