vix: {
  init = "";

  set = {
    lua = ''
      vim.opt.isfname:append("@-@")
      vim.opt.shortmess:append("c")
      vim.opt.listchars:append("eol:↴")
      vim.opt.listchars:append("space:⋅")
    '';
    laststatus = 3;
    list = true;
    nu = true;
    relativenumber = true;
    conceallevel = 0;
    completeopt = [ "menuone" "noselect" ];

    clipboard = "unnamedplus";

    errorbells = false;
    tabstop = 2;
    softtabstop = 2;
    shiftwidth = 2;
    expandtab = true;

    smartindent = true;

    wrap = false;

    swapfile = false;
    backup = false;
    undodir = _: ''vim.fn.stdpath("cache") .. "/vix/undodir"'';
    undofile = true;

    hlsearch = true;
    incsearch = true;

    termguicolors = true;
    guifont = "FiraCode Nerd Font:h10";

    scrolloff = 8;
    sidescrolloff = 8;
    signcolumn = "yes";

    cmdheight = 1;
    updatetime = 100;

    colorcolumn = "100";
    timeout = true;
    timeoutlen = 200;
    pumheight = 10;
    splitright = true;
    splitbelow = true;

    foldlevel = 20;
    foldmethod = "indent";
  };

  globals = {
    loaded = 1;
    leader = " ";
    mapleader = " ";
    loaded_netrwPlugin = 1;
    skip_ts_context_commentstring_module = true;
    markdown_fenced_languages = [ "ts=typescript" ];
  };

  colorscheme = "tokyonight-night";

  ftkeybinds = [{
    filetypes = vix.filetypes-for.rust;
    lua = ''
      local ok_rust, rust = pcall(require, "rust-tools");
      if not ok_rust then
        return
      end
    '';
    normal = { g.h = [ (_: "rust.hover_actions.hover_actions") "Hover" ]; };
  }];

  keybinds = {
    lua = builtins.readFile ./lua/keybind_functions.lua;
    normal = {
      useWhichKey = true;
      # LSP <start>
      formatKey = ";";
      g.h = [ (_: "vim.lsp.buf.hover") "Hover" ];
      g.l = [ (_: "line_diagnostics") "line diagnostics" ];
      g.a = [ (_: "vim.lsp.buf.code_action") "Code action" ];
      g.d = [ (_: "vim.lsp.buf.definition") "Go to definition" ];
      g.D = [ (_: "vim.lsp.buf.declaration") "Go to Declaration" ];
      g.s = [ (_: "vim.lsp.buf.signature_help") "Signature help" ];
      g.r = [ ":Telescope lsp_references<CR>" "References" ];
      g.I = [ (_: "vim.lsp.buf.implementation") "Go to implementation" ];
      g.t = [ (_: "vim.lsp.buf.type_definition") "Go to type definition" ];
      g.L = [ (_: "vim.lsp.codelens.run") "Codelens actions" ];
      # LSP <end>

      Y = [ "yg$" "Copy to end of line" ];
      Q = [ "<nop>" "Disable command mode" ];
      H = [ ":BufferLineCyclePrev<CR>" "Prev buffer" ];
      L = [ ":BufferLineCycleNext<CR>" "Next buffer" ];
      n = [ "nzzzv" "Go to next match and center the screen" ];
      N = [ "Nzzzv" "Go to prev match and center the screen" ];

      "." = [ ";" "nex thing" ];
      "'" = [ ":w<CR>" "Save" ];
      ${"\\"} = [ "za" "Fold" ];
      "<C-q>" = [ ":q<CR>" "Quit" ];
      ${''"''} = [ ":nohl<CR>" "no highlight" ];
      "<C-i>" = [ "<C-i>" "jump forward" ];
      "<C-j>" = [ "<C-w>j" "Move to the window below" ];
      "<C-k>" = [ "<C-w>k" "Move to the window above" ];
      "<Return>" = [ "@a" "Map enter to the 'a' macro" ];
      "<A-j>" = [ ":m .+1<CR>==" "Move current line up" ];
      "<A-k>" = [ ":m .-2<CR>==" "Move current line down" ];
      "<C-h>" = [ "<C-w>h" "Move to the window to the left" ];
      "<C-l>" = [ "<C-w>l" "Move to the window to the right" ];
      "<C-Up>" = [ ":resize -2<CR>" "Make the smaller on the y axis" ];
      "<C-Down>" = [ ":resize +2<CR>" "Make the window bigger on the y axis" ];
      "<C-Left>" =
        [ ":vertical resize +2<CR>" "Make the window bigger on the x axis" ];
      "<C-Right>" =
        [ ":vertical resize -2<CR>" "Make the window smaller on the x axis" ];

      "<leader>" = {
        # LSP <start>
        r = [ (_: "vim.lsp.buf.rename") "Rename" ];
        l.name = "LSP";
        l.l = [ ":LspInfo<CR>" "Lsp information" ];
        l.n = [ ":NullLsInfo<CR>" "Null-ls information" ];
        l.j = [ (_: "next_diagnostic") "Go to next diagnostic" ];
        l.k = [ (_: "prev_diagnostic") "Go to prev diagnostic" ];
        l.d = [ ":Telescope diagnostics<CR>" "Workspace diagnostics" ];
        # LSP <end>

        q = [ ":qa<CR>" "Quit all" ];
        w = [ ":wa<CR>" "Save all" ];
        T = [ (_: "new_term()") "New terminal" ];
        b = [ (_: "buffers") "Buffer picker" ];
        f = [ (_: "find_files") "File picker" ];
        c = [ (_: "buffer_kill") "Close buffer" ];
        o = [ (_: "save_source") "Save & source" ];
        v = [ ":vsplit<CR>" "Vertical Split" ];
        D = [ ''"_d'' "Delete without copying" ];
        x = [ ":split<CR>" "Horizontal Split" ];
        W = [ "<cmd>wqa<CR>" "Save and quit all" ];
        e = [ (_: "nvim_tree_focus_toggle()") "Nvim tree" ];
        h = [ ":lua print('harpooning')<CR>" "Harpoon" ];
        E = [ ":NvimTreeToggle<CR>" "Nvim tree toggle" ];
        Q = [ "<cmd>wqa!<CR>" "Quit all, no matter what" ];
        s = [ ":Telescope live_grep<CR>" "Project search" ];
        t = [ (_: "custom_toggle_term()") "Toggle terminal" ];
        S = [ ":Telescope spell_suggest<CR>" "Spelling suggestions" ];
        n = [ ":cnext<CR>" "Next item on the quick fix list" ];
        N = [ ":cprev<CR>" "Previous item on the quick fix list" ];

        V.name = "vim";
        V.c = [
          (_: ''":e "  .. vim.fn.stdpath("config") .. "/init.lua<CR>"'')
          "Edit config"
        ];

        g.name = "git";
        g.b = [ ":Gitsigns blame_line<CR>" "Blame" ];
        g.d = [ ":Gitsigns diffthis HEAD<CR>" "Diff" ];
        g.j = [ ":Gitsigns next_hunk<CR>" "Next hunk" ];
        g.k = [ ":Gitsigns prev_hunk<CR>" "Prev hunk" ];
        g.r = [ ":Gitsigns reset_hunk<CR>" "Reset hunk" ];
        g.s = [ ":Gitsigns state_hunk<CR>" "Stage hunk" ];
        g.R = [ ":Gitsigns reset_buffer<CR>" "Reset hunk" ];
        g.p = [ ":Gitsigns preview_hunk<CR>" "Preview hunk" ];
        g.u = [ ":Gitsigns undo_stage_hunk<CR>" "Unstage hunk" ];
        g. # Telescope
        g.c = [ ":Telescope git_commits<CR>" "Checkout commit" ];
        g.o = [ ":Telescope git_status<CR>" "Open changed files" ];
        g.C = [
          ":Telescope git_bcommits<CR>"
          "Checkout commit (for current file)"
        ];
      };
    };

    insert = {
      j.k = [ "<Esc>" "Exit insert mode" ];
      k.j = [ "<Esc>" "Exit insert mode" ];
      "<A-j>" = [ "<Esc>:m .+1<CR>==gi" "move current line down" ];
      "<A-k>" = [ "<Esc>:m .-2<CR>==gi" "move current line up" ];
    };

    visual = {
      useWhichKey = true;
      "<A-j>" = [ ":m >+1<CR>gv=gv" "move current selection down" ];
      "<A-K>" = [ ":m <-2<CR>gv=gv" "move current selection up" ];
      "<" = [ "<gv" "dedent" ];
      ">" = [ ">gv" "indent" ];

      ${"<leader>"} = {
        d = [ ''"_d'' "Delete wihtout copying" ];
        p = [ ''"_dP"'' "Paste wihtout copying" ];
      };
    };

    terminal = {
      "<Esc>" = [ "<Cmd>ToggleTermToggleAll<CR>" "Toggle the terminal" ];
      "jk" = [ "<C-\\><C-n>" "Escape terminal mode" ];
      "<C-h>" = [ "<Cmd>wincmd h<CR>" "Move to the left window" ];
      "<C-k>" = [ "<Cmd>wincmd k<CR>" "Move to the up window" ];
      "<C-j>" = [ "<Cmd>wincmd j<CR>" "Move to the down window" ];
      "<C-l>" = [ "<Cmd>wincmd l<CR>" "Move to the right window" ];
    };
  };
}
