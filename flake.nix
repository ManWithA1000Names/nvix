{
  description = "A very basic flake";

  inputs = {
    vix.url = "github:manwitha1000names/vix";

    lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , vix
    , null-ls
    , which-key
    , lspconfig
    , tokyonight
    }: vix.mkFlake {
      config = import ./neovim-config.nix;
      plugins = [
        lspconfig
        null-ls
        which-key
        tokyonight
      ];
      languages = [
        vix.languages.nix
      ];
    };
}
