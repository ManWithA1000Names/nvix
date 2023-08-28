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

    project_nvim = {
      url = "github:ahmedkhalf/project.nvim";
      flake = false;
    };

    indent_blankline = {
      url = "github:/lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, vix, ... }@plugin-sources:
    vix.mkFlake {
      config = import ./neovim-config.nix;
      plugin-sources = plugin-sources // {
        statusline = ./custom-plugins/statusline;
        signature = ./custom-plugins/signature;
      };
      less = [ "self" "nixpkgs" "vix" ];
      plugin-setups = {
        horizon = {
          setup = false;
          lazy = true;
        };

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
        comment = {
          setup = builtins.readFile ./lua/plugins-configs/comment.lua;
          lazy.events = [ "BufRead" ];
        };
        cmp = { setup = builtins.readFile ./lua/plugins-configs/cmp.lua; };
        nvim-autopairs = {
          setup = builtins.readFile ./lua/plugins-configs/autopairs.lua;
          lazy.events = [ "InsertEnter" ];
        };

        toggleterm = { setup = true; };

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

        project_nvim = { setup = true; };
        fidget = { setup = true; };
        indent_blankline = {
          setup = {
            char = "";
            char_highlight_list =
              [ "IndentBlanklineIndent1" "IndentBlanklineIndent2" ];
            space_char_highlight_list =
              [ "IndentBlanklineIndent1" "IndentBlanklineIndent2" ];
            show_end_of_line = true;
            show_trailing_blankline_indent = false;
          };
          lazy.events = [ "BufRead" ];
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
        };
        rust-tools = {
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
              on_attach = _: ''
                function(client, bufnr)
                  require"signature".setup(client)
                end'';
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
            pattern = [ "rust" ];
            events = [ "FileType" ];
          };
        };
      };
      tools = [
        vix.tool_presets_per_language.go
        vix.tool_presets_per_language."c/cpp"
        vix.tool_presets_per_language.lua
        vix.tool_presets_per_language.elm
        vix.tool_presets_per_language.tailwindcss
        vix.tool_presets_per_language.python
        vix.tool_presets_per_language.toml
        vix.tool_presets_per_language.sh
        vix.tool_presets_per_language.json
        vix.tool_presets_per_language."ts/js"
        vix.tool_presets_per_language.yaml
        vix.tool_presets_per_language.nix
        vix.tool_presets_per_language.haskell
      ];
      on_ls_attach = _: ''
        function(client, _bufnr)
          print("called on attach")
          if client.server_capabilities.signatureHelpProvider then
            print("calling the signature thing")
            local ok, sig = pcall(require, "signature");
            if not ok then
              print("failed to require signature");
              return
            end
            sig.setup(client)
          else
            print("language server " .. client.name .. " does not support signature help.")
          end
        end'';
    };
}
